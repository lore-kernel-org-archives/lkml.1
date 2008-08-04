Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYHDKWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYHDKWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYHDKWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:22:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbYHDKWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:22:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] mn10300: Fix up __bug_table handling in module loader.
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, lethal@linux-sh.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Mon, 04 Aug 2008 11:21:23 +0100
Message-ID: <20080804102123.4399.82282.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>

Platforms that are using GENERIC_BUG must call in to
module_bug_finalize()/module_bug_cleanup() in order to scan modules with
their own __bug_table sections that are otherwise unaccounted.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/module.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/kernel/module.c b/arch/mn10300/kernel/module.c
index 0e4d2f6..8fa3689 100644
--- a/arch/mn10300/kernel/module.c
+++ b/arch/mn10300/kernel/module.c
@@ -24,6 +24,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/bug.h>
 
 #if 0
 #define DEBUGP printk
@@ -195,7 +196,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
 {
-	return 0;
+	return module_bug_finalize(hdr, sechdrs, me);
 }
 
 /*
@@ -203,4 +204,5 @@ int module_finalize(const Elf_Ehdr *hdr,
  */
 void module_arch_cleanup(struct module *mod)
 {
+	module_bug_cleanup(mod);
 }

