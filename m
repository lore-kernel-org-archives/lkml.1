Return-Path: <linux-kernel-owner+w=401wt.eu-S1760453AbYFQWH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760453AbYFQWH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759568AbYFQWDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:03:14 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:65020 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672AbYFQWDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:03:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=abpr72drfXSyAmKRfB8ZCtr7qlCyThjtxpJnbCU9BqQcqu8D4l9re7BzYheFve9M6I
         Q1SI+0x3uLZO7Zh9VkSJbFa36zGifwTjo5L6lSDDap44MweVEo49f6c3cFuIuMO1fkmJ
         LeSCBdKB47K2QRfagSQk4WOBp5BeSLW1eUsVM=
To: linux-kernel@vger.kernel.org
Subject: [patch 15/19] perfmon2 minimal v2:  X86 64-bit system calls support
From: eranian@googlemail.com
Date: Tue, 17 Jun 2008 15:03:09 -0700 (PDT)
Message-ID: <4858349d.232d400a.3892.7d34@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs adds the entry points for the X86 64-bit perfmon2 system calls.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o/arch/x86/ia32/ia32entry.S
===================================================================
--- o.orig/arch/x86/ia32/ia32entry.S	2008-06-04 11:09:38.000000000 +0200
+++ o/arch/x86/ia32/ia32entry.S	2008-06-04 11:33:03.000000000 +0200
@@ -731,4 +731,16 @@
 	.quad sys32_fallocate
 	.quad compat_sys_timerfd_settime	/* 325 */
 	.quad compat_sys_timerfd_gettime
+	.quad sys_pfm_create_context
+	.quad sys_pfm_write_pmcs
+	.quad sys_pfm_write_pmds
+	.quad sys_pfm_read_pmds		/* 330 */
+	.quad sys_pfm_load_context
+	.quad sys_pfm_start
+	.quad sys_pfm_stop
+	.quad sys_ni_syscall		/* reserved for pfm_restart */
+	.quad sys_ni_syscall		/* 335 reserverd for pfm_create_evtsets */
+	.quad sys_ni_syscall		/* reserved for pfm_getinfo_evtsets */
+	.quad sys_ni_syscall		/* reserved for pfm_delete_evtsets */
+	.quad sys_pfm_unload_context
 ia32_syscall_end:
Index: o/include/asm-x86/unistd_64.h
===================================================================
--- o.orig/include/asm-x86/unistd_64.h	2008-06-04 11:09:38.000000000 +0200
+++ o/include/asm-x86/unistd_64.h	2008-06-04 11:33:03.000000000 +0200
@@ -640,6 +640,23 @@
 #define __NR_timerfd_gettime			287
 __SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
 
+#define __NR_pfm_create_context	288
+__SYSCALL(__NR_pfm_create_context, sys_pfm_create_context)
+#define __NR_pfm_write_pmcs	(__NR_pfm_create_context+1)
+__SYSCALL(__NR_pfm_write_pmcs, sys_pfm_write_pmcs)
+#define __NR_pfm_write_pmds	(__NR_pfm_create_context+2)
+__SYSCALL(__NR_pfm_write_pmds, sys_pfm_write_pmds)
+#define __NR_pfm_read_pmds	(__NR_pfm_create_context+3)
+ __SYSCALL(__NR_pfm_read_pmds, sys_pfm_read_pmds)
+#define __NR_pfm_load_context	(__NR_pfm_create_context+4)
+__SYSCALL(__NR_pfm_load_context, sys_pfm_load_context)
+#define __NR_pfm_start		(__NR_pfm_create_context+5)
+__SYSCALL(__NR_pfm_start, sys_pfm_start)
+#define __NR_pfm_stop		(__NR_pfm_create_context+6)
+__SYSCALL(__NR_pfm_stop, sys_pfm_stop)
+#define __NR_pfm_restart	(__NR_pfm_create_context+7)
+#define __NR_pfm_unload_context	(__NR_pfm_create_context+11)
+__SYSCALL(__NR_pfm_unload_context, sys_pfm_unload_context)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR

-- 

