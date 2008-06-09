Return-Path: <linux-kernel-owner+w=401wt.eu-S1761655AbYFIWlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761655AbYFIWlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762177AbYFIWe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:34:56 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:26395 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762120AbYFIWey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:34:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=Aaur698gCqY920Y0HizvmThBmK0faqpBnWjEpXDv+pHzIhQRHOa+sJ3pDxq8LHQ5lj
         HzzdIviLumz0OfrGb+Og9HKCJPEQac7r+JT/Lj1IcfzQFSCpr94PnakI1Ee12S9f7DFI
         NzIsOPv/ZNrfiTJluln2OSX2X63EVIOA97M+Q=
To: linux-kernel@vger.kernel.org
Subject: [patch 18/21] perfmon2 minimal:  X86 32-bit system calls support
From: eranian@googlemail.com
Date: Mon, 09 Jun 2008 15:34:52 -0700 (PDT)
Message-ID: <484db00c.0405560a.4d57.6e9b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs adds the entry points for the X86 32-bit perfmon2 system calls.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o/arch/x86/kernel/syscall_table_32.S
===================================================================
--- o.orig/arch/x86/kernel/syscall_table_32.S	2008-06-04 11:11:06.000000000 +0200
+++ o/arch/x86/kernel/syscall_table_32.S	2008-06-04 11:33:27.000000000 +0200
@@ -326,3 +326,16 @@
 	.long sys_fallocate
 	.long sys_timerfd_settime	/* 325 */
 	.long sys_timerfd_gettime
+	.long sys_pfm_create_context
+	.long sys_pfm_write_pmcs
+	.long sys_pfm_write_pmds
+	.long sys_pfm_read_pmds		/* 330 */
+	.long sys_pfm_load_context
+	.long sys_pfm_start
+	.long sys_pfm_stop
+	.long sys_ni_syscall		/* reserved for pfm_restart */
+	.long sys_ni_syscall		/* 335 reserverd for pfm_create_evtsets */
+	.long sys_ni_syscall		/* reserved for pfm_getinfo_evtsets */
+	.long sys_ni_syscall		/* reserved for pfm_delete_evtsets */
+	.long sys_pfm_unload_context
+
Index: o/include/asm-x86/unistd_32.h
===================================================================
--- o.orig/include/asm-x86/unistd_32.h	2008-06-04 11:11:06.000000000 +0200
+++ o/include/asm-x86/unistd_32.h	2008-06-04 11:33:27.000000000 +0200
@@ -332,6 +332,16 @@
 #define __NR_fallocate		324
 #define __NR_timerfd_settime	325
 #define __NR_timerfd_gettime	326
+#define __NR_pfm_create_context	327
+#define __NR_pfm_write_pmcs	(__NR_pfm_create_context+1)
+#define __NR_pfm_write_pmds	(__NR_pfm_create_context+2)
+#define __NR_pfm_read_pmds	(__NR_pfm_create_context+3)
+#define __NR_pfm_load_context	(__NR_pfm_create_context+4)
+#define __NR_pfm_start		(__NR_pfm_create_context+5)
+#define __NR_pfm_stop		(__NR_pfm_create_context+6)
+/* 7 to 10 reserved for future perfmon syscalls */
+#define __NR_pfm_unload_context	(__NR_pfm_create_context+11)
+
 
 #ifdef __KERNEL__
 

-- 

