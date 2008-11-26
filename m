Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbYKZIs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbYKZIs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbYKZImu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:42:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:25617 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbYKZImt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:42:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:from:date:message-id;
        b=kcINO6xdE51cRb5sWUOxovclcnCPTcruWR28skOunGHgO5v7wfnu/T28DMq2HxOr/d
         MIwS25yNzKu3ZzKJwUASJ5hiTyQ6c5tVWmu3zCa1LfXSwMYJ7CjO0gPwkqtRIrd2duE+
         5M+hFrSWUhfcOkE6BY1yZHnQLXvKzz2GMpVxY=
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: [patch 19/24] perfmon: X86 32-bit system calls support (x86)
From: eranian@googlemail.com
Date: Wed, 26 Nov 2008 00:42:48 -0800 (PST)
Message-ID: <492d0c08.0b38560a.49b0.ffffbce9@mx.google.com>
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

