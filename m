Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbZKZJ50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbZKZJ50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZKZJ5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:57:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:41472 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZKZJ5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:57:20 -0500
Date: Thu, 26 Nov 2009 09:56:37 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, brgerst@gmail.com, jeremy@goop.org,
       JBeulich@novell.com, tglx@linutronix.de, tim@klingt.org, mingo@elte.hu
Reply-To: jeremy@goop.org, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, brgerst@gmail.com,
       torvalds@linux-foundation.org, JBeulich@novell.com, tglx@linutronix.de,
       tim@klingt.org, mingo@elte.hu
In-Reply-To: <1259165856-3512-1-git-send-email-brgerst@gmail.com>
References: <1259165856-3512-1-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, 64-bit: Set data segments to null after switching to 64-bit mode
Message-ID: <tip-8ec6993d9f7d961014af970ded57542961fe9ad9@git.kernel.org>
Git-Commit-ID: 8ec6993d9f7d961014af970ded57542961fe9ad9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ec6993d9f7d961014af970ded57542961fe9ad9
Gitweb:     http://git.kernel.org/tip/8ec6993d9f7d961014af970ded57542961fe9ad9
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Wed, 25 Nov 2009 11:17:36 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 10:44:30 +0100

x86, 64-bit: Set data segments to null after switching to 64-bit mode

This prevents kernel threads from inheriting non-null segment
selectors, and causing optimizations in __switch_to() to be
ineffective.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Cc: Tim Blechmann <tim@klingt.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Beulich <JBeulich@novell.com>
LKML-Reference: <1259165856-3512-1-git-send-email-brgerst@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/head_64.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 2640660..17ba9ec 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -212,8 +212,8 @@ ENTRY(secondary_startup_64)
 	 */
 	lgdt	early_gdt_descr(%rip)
 
-	/* set up data segments. actually 0 would do too */
-	movl $__KERNEL_DS,%eax
+	/* set up data segments */
+	xorl %eax,%eax
 	movl %eax,%ds
 	movl %eax,%ss
 	movl %eax,%es
