Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZGDNX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZGDNX6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 09:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZGDNXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 09:23:49 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:58956 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZGDNXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 09:23:48 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
Date: Sat, 4 Jul 2009 08:23:20 -0500
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
References: <200907031314.36243.lkml@morethan.org> <200907031403.34566.lkml@morethan.org> <4A4E58AC.7010905@zytor.com>
In-Reply-To: <4A4E58AC.7010905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907040823.23261.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri July 3 2009, H. Peter Anvin wrote:
> Michael S. Zick wrote:
> >>
> >> The PGTABLE reservation seems much too big.  I think 1 page should be
> >> sufficient for a system with large pages.  Even if not, 0x6d000 is way
> >> too large.  And they symptoms of failing to reserve the initial
> >> pagetable are pretty non-subtle.
> >>
> > 
> > Random system halts, deadlocks with interrupts disabled?
> > Yup, that sounds familiar.
> > 
> > If I ever get more than a stopped machine with a glowing power light;
> > I will be certain to share.
> > 
> 
> Let's see... on a non-PSE system we may need one PDE and one PTE page
> per 4 MB, up to 1 GB, for a total of 256 pages or 1 MB of memory, so in
> that sense 0x6d000 (109 pages) doesn't sound at all unreasonable
> (non-PSE system with 512 MB of RAM?)
> 
> However, we shouldn't have to do this kind of hacks with
> MAPPING_BEYOND_END, and we *certainly* shouldn't do it by implicitly
> hard-coding the value of PAGE_SHIFT.
> 

The calculation was correct - this thread title is a false alarm.

The difference posted was caused by disabling the "has pae" in the
build configuration system.
So I just need to dig around in head.S a bit more - get rid of the
"Intel Only" hard coding, check if the pae bit is a hardwired zero 
in cr4, make sure I have a usable stack before the testing - since
the test may generate a GP fault. . .
Get the in-memory copy of the cpu feature flags correct (some are
defined but not implemented on this processor). . .
Then find and fix everything that isn't using 'cpu_has(x, y)' -

That should keep me busy for a few weeks.  ;)

Mike
> 	-hpa
> 


