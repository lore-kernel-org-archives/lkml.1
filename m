Return-Path: <linux-kernel-owner+w=401wt.eu-S1751520AbZFON6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbZFON6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZFON6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:58:41 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:10049 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZFON6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:58:40 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432R98dR1805Mzz1202hzzz32i6bh17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KLA9HG-02-RKI-01
Date: Mon, 15 Jun 2009 15:57:38 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@kernel.org>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC][GIT PULL][PATCH 0/10 -tip] cpu_debug patches 20090613
Message-ID: <20090615135738.GA7463@alberich.osrc.amd.com>
References: <1244910436.11733.14.camel@ht.satnam> <alpine.LFD.2.00.0906132056540.2800@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906132056540.2800@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 15 Jun 2009 13:58:32.0767 (UTC) FILETIME=[5E8EFCF0:01C9EDC1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 12:27:42AM +0200, Thomas Gleixner wrote:
> On Sat, 13 Jun 2009, Jaswinder Singh Rajput wrote:
> 
> > Please let me know how we can improve it and add more features so it
> > becomes more useful.

I second almost all of Thomas points. (The more I am wondering why
cpu_debug was merged at all.)

IMHO removing the cpuid, msr etc. stuff is the right thing to do.

But hey, I even can provide a "use case" for cpu_debug.

Recently I wanted to check some APIC registers. Instead of rebooting
the machine with apic=debug I loaded the module, mounted debugfs and
looked at the cpu_debug stuff to experience that ...

  The registers that I was interested in were not provided.

So I had to add some code to print some of the regs in the extended
APIC register with apic=debug code.  When submitting the patch
upstream I added the same regs to cpu_debug code. This really good
shows another weak point of cpu_debug:

  If the kernel has already code for debugging output cpu_debug just
  reinvents the wheel and does not even try to reuse existing code.

So in the end cpu_debug wasn't useful for me at all.

   <snip>

> Dumping random information out of any context is not helping us to
> debug problems. There is no value to look at debug registers, context
> registers and tss->regs without the context of the task we look at.
> 
> Can we please stop adding more random features to this?
> 
> This needs to be done the other way round. First we need to remove all
> redundant and useless interfaces from cpu_debug and then think
> carefully about in which way we want to expose the few really missing
> interesting things either by extending existing user space tools or by
> providing context aware and debug relevant interfaces in the kernel.

IMHO the cpu_debug feature should be renamed to platform_debug and
then already existing kernel debug code could be modified such that it
can also be called from this new platform_debug facility.  This would
allow to check certain things not only when booting Linux with certain
debug parameters but also on the fly when mounting the debugfs ...

The registers that come into my mind that would make some kind
of sense to provide with that interface are
- APIC stuff
- HPET stuff

Neither MSR, CPUID, CPU regs nor PCI config space stuff should be
added. Other facilities/tools exist for those (e.g. x86info,
msr-tools, pciutils or Magic SysRq).

... just my two cents.


Regards,

Andreas


