Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbXLLUI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbXLLUI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbXLLUIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:08:47 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:19645 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbXLLUIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:08:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aZf/s4EqhnI9LHIG2eO+ua9cI7iP6/Vqre0DVR7SQTH+RaoRxr+7/p4nvFssz7BEy7qYzcAqfFGGqXULMXOQ8ZsBuYkZurgeuXvNXPI4y+XKO5gizUqt9HCf9Wi8zdlmOpMlHCgUTY+JFxPE7eYi8+BT5nnMy51183iCGLdEiSw=
Subject: [PATCH] UML: Remove remaining FASTCALL uses
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeff Dike <jdike@addtoit.com>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 12:04:44 -0800
Message-Id: <1197489884.21291.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the x86 removal, FASTCALL is always empty now.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/um/kernel/ksyms.c   |    4 ++--
 include/asm-um/linkage.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/um/kernel/ksyms.c b/arch/um/kernel/ksyms.c
index 1b388b4..7c7142b 100644
--- a/arch/um/kernel/ksyms.c
+++ b/arch/um/kernel/ksyms.c
@@ -71,10 +71,10 @@ EXPORT_SYMBOL(dump_thread);
 
 /* required for SMP */
 
-extern void FASTCALL( __write_lock_failed(rwlock_t *rw));
+extern void __write_lock_failed(rwlock_t *rw);
 EXPORT_SYMBOL(__write_lock_failed);
 
-extern void FASTCALL( __read_lock_failed(rwlock_t *rw));
+extern void __read_lock_failed(rwlock_t *rw);
 EXPORT_SYMBOL(__read_lock_failed);
 
 #endif
diff --git a/include/asm-um/linkage.h b/include/asm-um/linkage.h
index 78b8624..cdb3024 100644
--- a/include/asm-um/linkage.h
+++ b/include/asm-um/linkage.h
@@ -6,7 +6,6 @@
 
 /* <linux/linkage.h> will pick sane defaults */
 #ifdef CONFIG_GPROF
-#undef FASTCALL
 #undef fastcall
 #endif
 
-- 
1.5.3.7.2212.gd092


