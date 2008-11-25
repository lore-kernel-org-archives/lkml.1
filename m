Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYKYVnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYKYVnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbYKYVgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:36:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:11940 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbYKYVgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:36:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=XAGY87/Dc/016JyrNAe/CCLJdJzF0OvHiuVfKiLbOWEjEdUKKMrJw/ePJm/EUlOhoe
         kdzngMhWmE8VTqzZTCFvvY3WDBB4n3bepjP6DOQaRAx7+AmH4qqME/ypSo2zVuwyJRAh
         YEs5eB+Sap3y/W1TfDAm9gIdeyncU7wkYFrBU=
To: linux-kernel@vger.kernel.org
Subject: [patch 19/24] perfmon: X86 32-bit system calls support (x86)
From: eranian@googlemail.com
Date: Tue, 25 Nov 2008 13:36:35 -0800 (PST)
Message-ID: <492c6fe3.0407560a.6c4f.0d0f@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs adds the entry points for the X86 32-bit perfmon system calls.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/arch/x86/kernel/syscall_table_32.S
===================================================================
--- o3.orig/arch/x86/kernel/syscall_table_32.S	2008-11-03 10:44:00.000000000 +0100
+++ o3/arch/x86/kernel/syscall_table_32.S	2008-11-03 11:18:20.000000000 +0100
@@ -332,3 +332,8 @@
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_pfm_create
+	.long sys_pfm_write
+	.long sys_pfm_read		/* 335 */
+	.long sys_pfm_attach
+	.long sys_pfm_set_state
Index: o3/arch/x86/include/asm/unistd_32.h
===================================================================
--- o3.orig/arch/x86/include/asm/unistd_32.h	2008-11-03 11:23:44.000000000 +0100
+++ o3/arch/x86/include/asm/unistd_32.h	2008-11-03 11:25:12.000000000 +0100
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

