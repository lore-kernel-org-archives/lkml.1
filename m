Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbYKVRih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbYKVRih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759468AbYKVRf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:35:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58469 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759466AbYKVRfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:35:55 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 16/32] m32r: section noise in head.S
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wOg-0006WF-KD@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:35:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


usual "introduce .text.head, put it in front of TEXT_TEXT in vmlinux.lds.S,
make the stuff up to jump to start_kernel live in it", same as on other
targets.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m32r/kernel/head.S        |    4 ++--
 arch/m32r/kernel/vmlinux.lds.S |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/m32r/kernel/head.S b/arch/m32r/kernel/head.S
--- a/arch/m32r/kernel/head.S
+++ b/arch/m32r/kernel/head.S
@@ -23,7 +23,7 @@ __INITDATA
 /*
  * References to members of the boot_cpu_data structure.
  */
-	.text
+.section .text.head, "ax"
 	.global	start_kernel
 	.global __bss_start
 	.global _end
@@ -133,7 +133,6 @@ loop1:
 /*
  * AP startup routine
  */
-	.text
 	.global	eit_vector
 ENTRY(startup_AP)
 ;; setup EVB
@@ -230,6 +229,7 @@ ENTRY(startup_AP)
 	nop
 #endif  /* CONFIG_SMP */
 
+	.text
 ENTRY(stack_start)
 	.long	init_thread_union+8192
 	.long	__KERNEL_DS
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -27,6 +27,7 @@ SECTIONS
   _text = .;			/* Text and read-only data */
   .boot : { *(.boot) } = 0
   .text : {
+	*(.text.head)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
