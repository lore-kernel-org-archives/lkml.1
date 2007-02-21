Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221AbXBUL5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbXBUL5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbXBUL5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:57:21 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38596 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221AbXBUL5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:57:20 -0500
Date: Wed, 21 Feb 2007 12:57:19 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] i386 asm-offsets.c: workaround for a -Wmissing-prototypes warning
Message-ID: <20070221115719.GE13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch works around a warning with -Wmissing-prototypes in 
arch/i386/kernel/asm-offsets.c

The warning isn't gcc's fault - asm-offsets.c is simply a special file.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/arch/i386/kernel/asm-offsets.c.old	2007-02-20 23:28:45.000000000 +0100
+++ linux-2.6.20-mm2/arch/i386/kernel/asm-offsets.c	2007-02-20 23:29:42.000000000 +0100
@@ -29,6 +29,9 @@
 #define OFFSET(sym, str, mem) \
 	DEFINE(sym, offsetof(struct str, mem));
 
+/* workaround for a warning with -Wmissing-prototypes */
+void foo(void);
+
 void foo(void)
 {
 	OFFSET(SIGCONTEXT_eax, sigcontext, eax);

