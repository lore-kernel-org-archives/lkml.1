Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbYKVRiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbYKVRiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759125AbYKVRgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:36:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58471 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759336AbYKVRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:36:05 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 17/32] fix the section noise in sparc head.S
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1L3wOq-0006X2-KM@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:36:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


usual .text.head trick

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/kernel/head.S        |    2 +-
 arch/sparc/kernel/vmlinux.lds.S |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/head.S b/arch/sparc/kernel/head.S
--- a/arch/sparc/kernel/head.S
+++ b/arch/sparc/kernel/head.S
@@ -72,7 +72,7 @@ sun4e_notsup:
 	.align 4
 
 	/* The Sparc trap table, bootloader gives us control at _start. */
-	.text
+	.section .text.head,"ax"
 	.globl	start, _stext, _start, __stext
 	.globl  trapbase
 _start:   /* danger danger */
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -13,6 +13,7 @@ SECTIONS
 	.text 0xf0004000 :
 	{
 		_text = .;
+		*(.text.head)
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
