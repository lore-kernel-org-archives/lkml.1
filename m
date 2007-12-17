Return-Path: <linux-kernel-owner+w=401wt.eu-S936088AbXLRBmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936088AbXLRBmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761829AbXLRBhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:37:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759081AbXLRBhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:37:51 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 16/21] [PATCH] unify mm_segment_t definition
Date: Mon, 17 Dec 2007 20:52:39 -0200
Message-Id: <11979320451308-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11979320401316-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com> <11979319903443-git-send-email-gcosta@redhat.com> <11979319953427-git-send-email-gcosta@redhat.com> <11979320011968-git-send-email-gcosta@redhat.com> <1197932006634-git-send-email-gcosta@redhat.com> <11979320114180-git-send-email-gcosta@redhat.com> <11979320163651-git-send-email-gcosta@redhat.com> <11979320211287-git-send-email-gcosta@redhat.com> <11979320252102-git-send-email-gcosta@redhat.com> <11979320302030-git-send-email-gcosta@redhat.com> <11979320354186-git-send-email-gcosta@redhat.com> <11979320401316-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the mm_segment_t structure definition to processor.h
This makes mmsegment.h file useless, and it is deleted.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/mmsegment.h      |    8 --------
 include/asm-x86/processor.h      |    5 +++++
 include/asm-x86/processor_32.h   |    5 -----
 include/asm-x86/processor_64.h   |    1 -
 include/asm-x86/thread_info_64.h |    2 +-
 5 files changed, 6 insertions(+), 15 deletions(-)

Index: linux-2.6-x86/include/asm-x86/mmsegment.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/mmsegment.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ASM_MMSEGMENT_H
-#define _ASM_MMSEGMENT_H 1
-
-typedef struct {
-	unsigned long seg;
-} mm_segment_t;
-
-#endif
Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h
+++ linux-2.6-x86/include/asm-x86/processor.h
@@ -420,6 +420,11 @@ struct extended_sigtable {
 	struct extended_signature sigs[0];
 };
 
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+
 /*
  * create a kernel thread without removing it from tasklists
  */
Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h
+++ linux-2.6-x86/include/asm-x86/processor_32.h
@@ -103,11 +103,6 @@ union i387_union {
 	struct i387_soft_struct soft;
 };
 
-typedef struct {
-	unsigned long seg;
-} mm_segment_t;
-
-
 #define INIT_THREAD  {							\
 	.sp0 = sizeof(init_stack) + (long)&init_stack,			\
 	.vm86_info = NULL,						\
Index: linux-2.6-x86/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_64.h
+++ linux-2.6-x86/include/asm-x86/processor_64.h
@@ -14,7 +14,6 @@
 #include <asm/msr.h>
 #include <asm/current.h>
 #include <asm/system.h>
-#include <asm/mmsegment.h>
 #include <linux/personality.h>
 #include <asm/desc_defs.h>
 
Index: linux-2.6-x86/include/asm-x86/thread_info_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/thread_info_64.h
+++ linux-2.6-x86/include/asm-x86/thread_info_64.h
@@ -21,7 +21,7 @@
 #ifndef __ASSEMBLY__
 struct task_struct;
 struct exec_domain;
-#include <asm/mmsegment.h>
+#include <asm/processor.h>
 
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
