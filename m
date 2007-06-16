Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbXFPSiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbXFPSiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 14:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXFPSih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 14:38:37 -0400
Received: from barikada.upol.cz ([158.194.242.200]:35205 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbXFPSih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 14:38:37 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Separate arch patching (Re: [patch-mm 06/25] clockevents: Fix resume logic)
In-Reply-To: <20070616101636.756850073@inhelltoy.tec.linutronix.de>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de> <20070616101636.756850073@inhelltoy.tec.linutronix.de>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: jed (x86_64-pc-linux-glibc-debian)
X-Mailer: slrn
Date: Sat, 16 Jun 2007 20:51:04 +0200
Message-Id: <E1HzdMW-0007PJ-Et@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* From: Thomas Gleixner

[]
> Fixup the existing users.
>
> This removes the sysfs entry for the HPET, which is now controlled by
> the clockevents resume code.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>
> ---
>  arch/arm/mach-davinci/time.c      |    2 +
>  arch/arm/mach-imx/time.c          |    1 
>  arch/arm/mach-ixp4xx/common.c     |    2 +
>  arch/arm/mach-omap1/time.c        |    1 
>  arch/arm/plat-omap/timer32k.c     |    2 +

Testers and users are most likely to run one particular arch on
one particular test bench. If individual patches are arch
separated, i think bisecting will be a little bit easier.

Thus, i would like to propose separate arch patching (x86_64/i386 mainly).

Is it possible to do that? (And even set such check in ``checkpatch''?)

You would say, why? Because current kbuild/kconfig support of builds for
whole tree.

That's because to make download, build, test and debug particular arch
more easily, i'm trying to re-think and re-do some kbuild parts. With
minimum set of files, downloaded with git one can spend less
time/bandwidth for starting testing.

>  arch/i386/kernel/apic.c           |    3 +
>  arch/i386/kernel/hpet.c           |   71 ++------------------------------------
>  arch/i386/kernel/i8253.c          |   26 ++++++-------
>  arch/i386/kernel/vmiclock.c       |    1 
>  arch/i386/xen/time.c              |    1 

Opinions?

>  arch/sh/kernel/timers/timer-tmu.c |    1 
>  arch/sparc64/kernel/time.c        |    1 
____
