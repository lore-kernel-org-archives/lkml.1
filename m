Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbYEACSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbYEACSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbYEACRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:17:21 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:57504 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758635AbYEACRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:17:19 -0400
Date: Thu, 1 May 2008 12:16:46 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010216.m412GkjW004111@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: add some missing sections into the linker script
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Siewior <bigeasy@linutronix.de>

Add some missing sections into the linker script.
Those are required for spinlocks & kallsyms.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/arch/m68knommu/kernel/vmlinux.lds.S linux-2.6.25-uc0/arch/m68knommu/kernel/vmlinux.lds.S
--- linux-2.6.25/arch/m68knommu/kernel/vmlinux.lds.S	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/arch/m68knommu/kernel/vmlinux.lds.S	2008-04-22 14:48:44.000000000 +1000
@@ -64,6 +64,7 @@ SECTIONS {
 		_stext = . ;
 		TEXT_TEXT
 		SCHED_TEXT
+		LOCK_TEXT
         	*(.text.lock)
 
 		. = ALIGN(16);          /* Exception table              */
@@ -73,6 +74,7 @@ SECTIONS {
 
 		*(.rodata) *(.rodata.*)
 		*(__vermagic)		/* Kernel version magic */
+		*(__markers_strings)
 		*(.rodata1)
 		*(.rodata.str1.1)
 
@@ -182,6 +184,7 @@ SECTIONS {
 		*(COMMON)
 		. = ALIGN(4) ;
 		_ebss = . ;
+	 	_end = . ;
 	} > BSS
 
 }
