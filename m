Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbZEDSoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbZEDSoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZEDSoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:44:21 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:37503 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282AbZEDSoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:44:20 -0400
Subject: [PATCH] x86: Reduce the default HZ value
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 04 May 2009 11:44:21 -0700
Message-Id: <1241462661.412.8.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Given that there were no major objections that came up regarding
reducing the HZ value in http://lkml.org/lkml/2009/4/27/499. 

Below is the patch which actually reduces it, please consider for tip.

Thanks,
Alok

-- 
With HRT support in the kernel we shouldn't actually be needing a high interrupt
frequency. This patch reduces the HZ value to 100 for x86 defconfig.

A high HZ value may affect the performance of the system if its nonidle.
I ran a simple experiment with 2.6.29 kernel running on VMware..
A simple tight loop took about 264s to complete with a HZ value of 1000.
The system serviced a total of 264405 timer interrupts during that time.
The same loop with HZ=100 took only about 255sec to complete.
Total timer interrupts were 25593.
More information here - http://lkml.org/lkml/2009/4/28/401

With highres timers most of the important timers are not tied down with the
how often the jiffy value is updated so this shouldn't have any adverse
effects on the latency of these timers either.

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-tip-master/arch/x86/configs/i386_defconfig
===================================================================
--- linux-tip-master.orig/arch/x86/configs/i386_defconfig	2009-05-01 16:47:43.000000000 -0700
+++ linux-tip-master/arch/x86/configs/i386_defconfig	2009-05-01 16:49:48.000000000 -0700
@@ -312,11 +312,11 @@
 CONFIG_X86_PAT=y
 CONFIG_EFI=y
 CONFIG_SECCOMP=y
-# CONFIG_HZ_100 is not set
+CONFIG_HZ_100=y
 # CONFIG_HZ_250 is not set
 # CONFIG_HZ_300 is not set
-CONFIG_HZ_1000=y
-CONFIG_HZ=1000
+# CONFIG_HZ_1000 is not set
+CONFIG_HZ=100
 CONFIG_SCHED_HRTICK=y
 CONFIG_KEXEC=y
 CONFIG_CRASH_DUMP=y
Index: linux-tip-master/arch/x86/configs/x86_64_defconfig
===================================================================
--- linux-tip-master.orig/arch/x86/configs/x86_64_defconfig	2009-05-01 16:37:53.000000000 -0700
+++ linux-tip-master/arch/x86/configs/x86_64_defconfig	2009-05-01 16:50:22.000000000 -0700
@@ -316,11 +316,11 @@
 CONFIG_X86_PAT=y
 CONFIG_EFI=y
 CONFIG_SECCOMP=y
-# CONFIG_HZ_100 is not set
+CONFIG_HZ_100=y
 # CONFIG_HZ_250 is not set
 # CONFIG_HZ_300 is not set
-CONFIG_HZ_1000=y
-CONFIG_HZ=1000
+# CONFIG_HZ_1000 is not set
+CONFIG_HZ=100
 CONFIG_SCHED_HRTICK=y
 CONFIG_KEXEC=y
 CONFIG_CRASH_DUMP=y


