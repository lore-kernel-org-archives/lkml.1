Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbZFKUVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbZFKUVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 16:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZFKUVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 16:21:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53919 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbZFKUVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 16:21:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: 2.6.30: hibernation/swsusp stuck in disable_nonboot_cpus
Date: Thu, 11 Jun 2009 22:21:57 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <20090611165608.GA4908@sig21.net>
In-Reply-To: <20090611165608.GA4908@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906112221.57926.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009, Johannes Stezenbach wrote:
> Hi,
> 
> on my work machine susend-to-disk is broken in 2.6.30.  Last
> known working kernel was 2.6.29.1. I'm running a 32bit kernel.
> CPU is an AMD Athlon(tm) Dual Core Processor 4850e.
> Board is a Gigabyte GA-MA78GM-S2H rev 1.1.
> 
> - usually it stops on suspend after the message
>   "Suspending console(s) (use no_console_suspend to debug)"
> 
> - I booted with no_console_suspend using serial console
>   as recommended in Documentation/power/basic-pm-debugging.txt.
> 
>   No joy, apparently the serial driver is disabled during suspend
>   and no interesting output on serial console...
> 
> - no_console_suspend on VESA fb console worked better, last msg is
>   "Disabling non-boot CPUs ..."
> 
> - I stripped down my config, and after serveral retries
>   it _sometimes_ gets past the "Disabling non-boot CPUs ...".
>   Then the last lines are (penciled from screen):
> 
>       Enabling non-boot CPUs ...
>       SMP alternatives: switching to SMP code
>       Booting processor 1 APIC 0x1 ip 0x6000
>       Initializing CPU#1
>       Stuck ??
>       Error taking CPU#1 up: -5
> 
>   I also got past this point once, but then it hung at the
>   same spot on resume.
> 
> - I tried    echo 0 > /sys/devices/system/cpu/cpu1/online
> 
>      CPU 1 is now offline
>      SMP alternatives: switching to UP code
>      CPU0 attaching NULL sched-domain.
>      CPU1 attaching NULL sched-domain.
>      CPU0 attaching NULL sched-domain.
>      PM: Removing info for No Bus:msr1
>      PM: Removing info for No Bus:cpu1
> 
> - and     echo 1 > /sys/devices/system/cpu/cpu1/online
> 
>      PM: Adding info for No Bus:msr1
>      PM: Adding info for No Bus:cpu1
>      SMP alternatives: switching to SMP code
>      Booting processor 1 APIC 0x1 ip 0x6000
>      Initializing CPU#1
>      Calibrating delay using timer specific routine.. 5022.45 BogoMIPS (lpj=10044915)
>      CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>      CPU: L2 Cache: 512K (64 bytes/line)
>      CPU: Physical Processor ID: 0
>      CPU: Processor Core ID: 1
>      Intel machine check architecture supported.
>      Intel machine check reporting enabled on CPU#1.
>      CPU1: AMD Athlon(tm) Dual Core Processor 4850e stepping 02
>      CPU0 attaching NULL sched-domain.
>      Switched to high resolution mode on CPU 1
>      CPU0 attaching sched-domain:
>       domain 0: span 0-1 level CPU
>        groups: 0 1
>      CPU1 attaching sched-domain:
>       domain 0: span 0-1 level CPU
>        groups: 1 0
>      Warning: Processor Platform Limit event detected, but not handled.
>      Consider compiling CPUfreq support into your kernel.
> 
> 
> Kernel config, dmesg and lspci below.  Is there anyting I could
> try besides git bisect?

Perhaps.  Please check if the kernel where the following commit is the head:

commit 2ed8d2b3a81bdbb0418301628ccdb008ac9f40b7
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Mar 16 22:34:06 2009 +0100

    PM: Rework handling of interrupts during suspend-resume

is also broken.

Best,
Rafael
