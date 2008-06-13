Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbYFMNKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbYFMNKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 09:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYFMNKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 09:10:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbYFMNKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 09:10:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] MN10300: Export certain arch symbols required to build
	allmodconfig
To: torvalds@osdl.org, akpm@linux-foundation.org, bunk@kernel.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Fri, 13 Jun 2008 14:09:53 +0100
Message-ID: <20080613130952.26794.26092.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export kernel_thread() and empty_zero_page so that allmodconfig can be built
for MN10300.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/mn10300_ksyms.c |    3 +++
 arch/mn10300/kernel/process.c       |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/arch/mn10300/kernel/mn10300_ksyms.c b/arch/mn10300/kernel/mn10300_ksyms.c
index 6d19628..544ee1a 100644
--- a/arch/mn10300/kernel/mn10300_ksyms.c
+++ b/arch/mn10300/kernel/mn10300_ksyms.c
@@ -10,8 +10,11 @@
  */
 #include <linux/module.h>
 #include <asm/uaccess.h>
+#include <asm/pgtable.h>
 
 
+EXPORT_SYMBOL(empty_zero_page);
+
 EXPORT_SYMBOL(change_bit);
 EXPORT_SYMBOL(test_and_change_bit);
 
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 3b0d579..345dadb 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -154,6 +154,7 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0,
 		       NULL, NULL);
 }
+EXPORT_SYMBOL(kernel_thread);
 
 /*
  * free current thread data structures etc..

