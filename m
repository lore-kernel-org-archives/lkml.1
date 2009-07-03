Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbZGCTlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbZGCTlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbZGCTlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:41:05 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:53721 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbZGCTlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:41:04 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
Date: Fri, 3 Jul 2009 14:41:01 -0500
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
Message-Id: <200907031441.04604.lkml@morethan.org>
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

Good point: (1<<(32-PAGE_SIFT)) would handle other than 4k pages.

I just hardcoded it as a working example of the change from setting
the page table size by design rather than numeric error.

And yes, it has 512Mbyte of ram, so 1/2Mbyte page table sounds right to me.

Mike
> 	-hpa
> 


