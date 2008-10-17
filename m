Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbYJQPL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbYJQPL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbYJQPF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:05:58 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:22167 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbYJQPF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:05:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=oYSqhYbf7oFxAONlblUm8F3z5D2c/u+7z3oXg+aSYj+lfBpugIkKU2+ge1SLHGrq9B
         hMT3GadF+NAtq0WBheaPNFPfytDmef/ShEf4l8/YamuZL9s/L38EDOkgE//OwCjaSvOC
         UMQQKB24vUEThqkgEbuhZO7NzzxOi7339Docg=
To: linux-kernel@vger.kernel.org
Subject: [patch 19/24] perfmon3:  X86 32-bit system calls support
From: eranian@googlemail.com
Date: Fri, 17 Oct 2008 08:05:55 -0700 (PDT)
Message-ID: <48f8a9d3.0437560a.655a.6387@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs adds the entry points for the X86 32-bit perfmon system calls.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/arch/x86/kernel/syscall_table_32.S
===================================================================
--- o3.orig/arch/x86/kernel/syscall_table_32.S	2008-10-10 11:06:59.000000000 +0200
+++ o3/arch/x86/kernel/syscall_table_32.S	2008-10-10 11:33:04.000000000 +0200
@@ -332,3 +332,8 @@
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_pfm_create
+	.long sys_pfm_write
+	.long sys_pfm_read		/* 335 */
+	.long sys_pfm_attach
+	.long sys_pfm_set_state
Index: o3/include/asm-x86/unistd_32.h
===================================================================
--- o3.orig/include/asm-x86/unistd_32.h	2008-10-10 11:06:59.000000000 +0200
+++ o3/include/asm-x86/unistd_32.h	2008-10-10 11:33:50.000000000 +0200
@@ -338,6 +338,11 @@
 #define __NR_dup3		330
 #define __NR_pipe2		331
 #define __NR_inotify_init1	332
+#define __NR_pfm_create		333
+#define __NR_pfm_write		(__NR_pfm_create+1)
+#define __NR_pfm_read		(__NR_pfm_create+2)
+#define __NR_pfm_attach		(__NR_pfm_create+3)
+#define __NR_pfm_set_state	(__NR_pfm_create+4)
 
 #ifdef __KERNEL__
 

-- 

