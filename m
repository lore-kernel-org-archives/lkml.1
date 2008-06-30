Return-Path: <linux-kernel-owner+w=401wt.eu-S1761688AbYF3NTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761688AbYF3NTC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761877AbYF3NOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:14:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:54996 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762207AbYF3NOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:14:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=sdCGruIaV3fobQMgJwzFivBjj+DdRDIFHYgtkottqrWwrqw+x10Kg79SIE9Yc0mYvX
         w78AYh5YsQ/4nBtI36kBW8WkT3WeWEWKG/kW32dzXgRrDlVF3I/YaURGEU9LJSqmjs0X
         Gg8RvHU67HMqxqHlf5hfHK0JovOMfobYnNTmQ=
To: linux-kernel@vger.kernel.org
Subject: [patch 15/19] perfmon2 minimal v3:  X86 64-bit system calls support
From: eranian@googlemail.com
Date: Mon, 30 Jun 2008 06:14:31 -0700 (PDT)
Message-ID: <4868dc37.21054e0a.7fa0.ffff8614@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs adds the entry points for the X86 64-bit perfmon2 system calls.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: linux-next/arch/x86/ia32/ia32entry.S
===================================================================
--- linux-next.orig/arch/x86/ia32/ia32entry.S	2008-06-26 20:07:15.000000000 +0200
+++ linux-next/arch/x86/ia32/ia32entry.S	2008-06-26 20:07:17.000000000 +0200
@@ -729,4 +729,16 @@
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
Index: linux-next/include/asm-x86/unistd_64.h
===================================================================
--- linux-next.orig/include/asm-x86/unistd_64.h	2008-06-26 20:07:15.000000000 +0200
+++ linux-next/include/asm-x86/unistd_64.h	2008-06-26 20:07:17.000000000 +0200
@@ -640,6 +640,22 @@
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
+#define __NR_pfm_unload_context	(__NR_pfm_create_context+11)
+__SYSCALL(__NR_pfm_unload_context, sys_pfm_unload_context)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR

-- 

