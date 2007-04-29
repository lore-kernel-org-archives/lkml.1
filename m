Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbXD2LCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbXD2LCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbXD2LB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:01:26 -0400
Received: from ns1.suse.de ([195.135.220.2]:52066 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbXD2KxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:04 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Adrian Bunk <bunk@stusta.de>, Andi Kleen <ak@muc.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [11/48] i386: workaround for a -Wmissing-prototypes warning
Message-Id: <20070429105259.579CA151C5@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:52:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

Work around a warning with -Wmissing-prototypes in
arch/i386/kernel/asm-offsets.c

The warning isn't gcc's fault - asm-offsets.c is simply a special file.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/asm-offsets.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/arch/i386/kernel/asm-offsets.c
===================================================================
--- linux.orig/arch/i386/kernel/asm-offsets.c
+++ linux/arch/i386/kernel/asm-offsets.c
@@ -25,6 +25,9 @@
 #define OFFSET(sym, str, mem) \
 	DEFINE(sym, offsetof(struct str, mem));
 
+/* workaround for a warning with -Wmissing-prototypes */
+void foo(void);
+
 void foo(void)
 {
 	OFFSET(SIGCONTEXT_eax, sigcontext, eax);
