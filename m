Return-Path: <linux-kernel-owner+w=401wt.eu-S1761297AbYFQWHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297AbYFQWHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760129AbYFQWDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:03:16 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:25963 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672AbYFQWDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:03:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=hHLd7wVIvPiG37Ud7Yr+F7DMi6jOTcm6q7Bd7JHB22lEKzp8y84la0YwP2O7jS61Mn
         DGypfQkmrv0bzy1sV206+okgzGQyG0zkI55NbpmKNFduBiFYesZ2qggYNhTKNHs9qE07
         ifJekdBhOxlGGB+XZKKDmNa5r1M31MXvAstNw=
To: linux-kernel@vger.kernel.org
Subject: [patch 16/19] perfmon2 minimal v2:  X86 32-bit system calls support
From: eranian@googlemail.com
Date: Tue, 17 Jun 2008 15:03:13 -0700 (PDT)
Message-ID: <485834a1.20664e0a.465b.2c7d@mx.google.com>
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

