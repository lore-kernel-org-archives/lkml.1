Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXCVNmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXCVNmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932370AbXCVNmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:42:37 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37944 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932203AbXCVNmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:42:36 -0400
Date: Thu, 22 Mar 2007 14:42:38 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Len Brown <len.brown@intel.com>, Andi Kleen <ak@suse.de>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc[123] regression with NOAPIC
Message-ID: <20070322134238.GY752@stusta.de>
References: <4601573A.8070602@madrabbit.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4601573A.8070602@madrabbit.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 09:03:06AM -0700, Ray Lee wrote:
> Hey Thomas, Ingo, et al.
> 
> I'm having a problem, and tracked it down to what looks like a harmless
> commit of yours. I didn't quite believe the bisect at first, so tested
> it multiple times.
> 
> The original problem report, when I boot with NOAPIC on the command line
> on my x86_64 box, the boot hangs and the system is totally unresponsive:
> 
> > For me, this is a minor regression as I no longer need to boot with
> > NOAPIC, it just happened to still be the default when I tried 2.6.21-rc3.
> > 
> > During boot, the computer wedges, hard. It's unresponsive to SysRq
> > combos, or ctrl-alt-del, but the fan kicks in pretty quickly, so I'm
> > guessing the CPU is still going wild.
> > 
> > The boot locks right before, or during, or immediately after the ** line
> > below:
> > 
> >    [   15.020037] ACPI: CPU0 (power states: C1[C1] C3[C3])
> > ** [   15.020221] ACPI: Processor [C000] (supports 8 throttling states)
> >    [   15.036059] ACPI: Thermal Zone [TZ1] (66 C)
> >    [   15.041893] ACPI: Thermal Zone [TZ2] (53 C)
> >    [   15.051285] ACPI: Thermal Zone [TZ3] (33 C)
> >    [   15.054922] ACPI: Thermal Zone [TZ4] (34 C)
> > 
> > This is an x86-64 system, HP/Compaq nx6125, ATI chipset (sigh). Booting
> > with NOAPIC worked in 2.6.20, fails in 2.6.21-rc1 (and 2, and 3).
> (& UP, not compiled for SMP.)
> 
> Starting with head as of yesterday and reverting two commits (that are
> duplicates of each other -- the same commit came into Linus's tree via
> two different paths) 'fixes' the problem for me. I'll let those with the
> big brains decide just why.
> 
> The two commits are 5c95d3f5783ab184f64b7848f0a871352c35c3cf and
> 3434933b17fa64adddf83059603c61296f6e1ee2 . The net reverse diff of those
> two is below.
>...

Thanks for tracking it down.

It's quite possible that these commits trigger your problem.

Does it work if you do _not_ revert the commits, and instead replace in
drivers/acpi/processor_idle.c the
  #ifdef ARCH_APICTIMER_STOPS_ON_C3
with an
  #if 0
?

> Ray
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

