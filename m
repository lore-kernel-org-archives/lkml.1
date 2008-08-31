Return-Path: <linux-kernel-owner+w=401wt.eu-S1758406AbYHaUDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbYHaUDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 16:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757061AbYHaUD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 16:03:26 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:34682 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041AbYHaUD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 16:03:26 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Date: Sun, 31 Aug 2008 16:03:48 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <200808311422.12525.linux@sandersweb.net> <alpine.LFD.1.10.0808311140060.12958@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808311140060.12958@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808311603.49056.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 August 2008 14:47, Linus Torvalds wrote:
> On Sun, 31 Aug 2008, David Sanders wrote:
> > I recently discovered that x86 kernels won't boot under Virtual PC.
>
> What CPU does Virtual PC emulate? As far as Wikipedia is concerned (not
> that I'd take it on complete faith) it emulates a 32-bit Intel Pentium II.
>
> And that commit makes the kernel use the "P6 nops" for such hardware.
> Maybe Virtual PC doesn't support the newer intel nop things?
>
> Intel docs say that it should be available on any intel CPU that has
> CPUID.01H.EAX[11:8] = 0110B or 1111B. That's the "family ID", and Pentium
> II should have a family ID of 6 (ie that 0110B case).
>
> So it sounds like a Virtual PC bug, but I dunno. And maybe we should just
> use the legcay nops for anything that isn't modern (ie P4+ or Core)?
>
> 		Linus

Virtual PC does not emulate a processor like it does with the motherboard, 
video, NIC ,etc.  What you see in the virtual machine is the actual 
processor, except that Virtual PC looks at all of your instructions and 
modifies ring 0 code and the like.  It may be that Virtual PC was not 
designed with an awareness of these nops that the commit added.

I would suggest an configuration option to select legacy-nops or newer-nops 
and a kernel boot-time parameter so it can be disabled to allow installation 
of a distribution for example.

I would be happy to submit such a patch if you agree (or I'll try to anyway).
