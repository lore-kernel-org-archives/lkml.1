Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYK0WgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYK0WgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 17:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYK0Wfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 17:35:46 -0500
Received: from web27505.mail.ukl.yahoo.com ([217.146.177.209]:26885 "HELO
	web27505.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754775AbYK0Wfo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 17:35:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=h7viruJ95mNUmnnW8rjSiqj1EXNEIek1aEKBG65io3NpnjEO2cQq1Ke2PbzZazU8qGY1Sq52av/s2ad78jSCg6Tt0l+mHscBvlXuRqYZtgUNJelW5OsAgLyESQRpPhdxIEh9EgIZLSmZfWi0Cm7dN+KdOlUWuB60hqgXX4v7e4I=;
X-YMail-OSG: sXF1rdUVM1lNPhNTXi9o1pNwWKYpTzB84PUdSGD5.uB5ZcuL4dZPWL7XapINptdxy.TcmU_h23jgL1se4gnVei0eT_A5pQJPWLeZgl1H5EZbFlHnBIJxfQ2Imx8miILE0CV.VMDaI5fOuf1W1uYBKCNs02keEfs44mVAIPiM
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 27 Nov 2008 22:35:42 +0000 (GMT)
From: Andrea Amerini <amerini_a@yahoo.it>
Subject: kernel 2.6.27.7 TSC calibration issue
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <495130.50092.qm@web27505.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Kernel 2.6.27.7 doesn't use the right value for TSC calibration

I've updated my system (Slackware 12.1) to kernel 2.6.27.7 vanilla and looking in dmesg I read this:

TSC: PIT calibration deviates from PMTIMER: 2968361 3400012.
TSC: Using PIT calibration value

But my cpu is :

cpu family      : 15
model           : 3
model name      : Intel(R) Pentium(R) 4 CPU 3.40GHz
stepping        : 4

So the clock frequency detected is 3Ghz instead of 3,4 Ghz.
Also bogomips are different:

for CPU0 I have this value:
 - bogomips        : 5939.08
and for the CPU1 this
 one:
 - bogomips        : 6802.52

Here it is some Kernel compilation flags of my .config:

# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not
 set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not
 set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_X86_PM_TIMER=y


With 2.6.26.8 version of kernel everything was fine.

My mainboard is an Intel D915GEV with 3 Gb of ram.

Sorry if my bug-report is not totally correct,I'm a newbie with linux.

If you need, I'll be happy to give you any help or other info.
Thanks for your time.






      


      
