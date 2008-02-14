Return-Path: <linux-kernel-owner+w=401wt.eu-S1764269AbYBNF1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764269AbYBNF1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYBNF07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:26:59 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:60482 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbYBNF06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:26:58 -0500
X-Authority-Analysis: v=1.0 c=1 a=xxEvNtb_9vVihlCw_AwA:9
 a=yNjKd1tmSyXM_J2_xWUA:7 a=29GsQJN0c5bIZdhBPdfMeWLuyM0A:4 a=93ryfjaT_d8A:10
 a=gi0PWCVxevcA:10
Date: Thu, 14 Feb 2008 00:26:55 -0500
From: Jeff DeFouw <jeffd@i2k.com>
To: linux-kernel@vger.kernel.org
Subject: WARNING at x86 smp_32.c:561 native_smp_call_function_mask()
Message-ID: <20080214052654.GA27184@blorp.plorb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed this WARNING fly by while booting 2.6.24.2.  Everything seems 
to be working though.

Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel Pentium III (Katmai) stepping 02
Total of 2 processors activated (1805.98 BogoMIPS).
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
Pid: 1, comm: swapper Not tainted 2.6.24.2 #1
 [<c010ed51>] native_smp_call_function_mask+0x171/0x180
 [<c0103607>] common_interrupt+0x23/0x28
 [<c010f950>] enable_NMI_through_LVT0+0x0/0x30
 [<c010f950>] enable_NMI_through_LVT0+0x0/0x30
 [<c010f08c>] smp_call_function+0x1c/0x20
 [<c01210d1>] on_each_cpu+0x21/0x40
 [<c0110fc0>] setup_nmi+0x30/0x50
 [<c05ab3e5>] setup_IO_APIC+0xe15/0xf40
 [<c01331a7>] atomic_notifier_call_chain+0x17/0x20
 [<c02e756d>] notify_update+0x1d/0x30
 [<c05a74be>] native_smp_prepare_cpus+0x55e/0xac0
 [<c0116a29>] task_rq_lock+0x39/0x70
 [<c0117ee6>] set_cpus_allowed+0x46/0xa0
 [<c059f710>] kernel_init+0x0/0x300
 [<c059f762>] kernel_init+0x52/0x300
 [<c0118b17>] schedule_tail+0x17/0x60
 [<c0102b42>] ret_from_fork+0x6/0x1c
 [<c059f710>] kernel_init+0x0/0x300
 [<c059f710>] kernel_init+0x0/0x300
 [<c0103817>] kernel_thread_helper+0x7/0x10
 =======================
APIC timer registered as dummy, due to nmi_watchdog=1!
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs

560:        /* Can deadlock when called with interrupts disabled */
561:        WARN_ON(irqs_disabled());

-- 
Jeff DeFouw <jeffd@i2k.com>
