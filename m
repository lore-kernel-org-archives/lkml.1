Return-Path: <linux-kernel-owner+w=401wt.eu-S1761424AbYFIWeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424AbYFIWeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757993AbYFIWdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:33:41 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:26395 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbYFIWdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=R6HKdk7J10NI6F1FBVJ3TNaVVGo+/iwVYtlMXPOvVXMJgF0A0zpKTg9+PT5SmooniI
         oYzL4/PmKDoD3SzweIq9pQgLUG2kLeAbXUB3D/dYlyBnxAM3g5qVk8HwTIyMjoNMWJfY
         ZFBFgb8UgFPWSmh/qRR2leKouE3OLd6f4w9qM=
To: linux-kernel@vger.kernel.org
Subject: [patch 01/21] perfmon2 minimal:  generic hooks
From: eranian@googlemail.com
Date: Mon, 09 Jun 2008 15:33:36 -0700 (PDT)
Message-ID: <484dafc0.0af6660a.55fa.617b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple patch adds the perfmon subdirectory to the
top-level Makefile.

It also adds the perfmon2 context pointer to the task
struct. The field points to the perfmon context structure
only when a thread is monitored.

Signed-off-by: Stephane Eranian <eranian@gmail.com>

--

Index: o/Makefile
===================================================================
--- o.orig/Makefile	2008-06-05 11:00:37.000000000 +0200
+++ o/Makefile	2008-06-05 11:00:43.000000000 +0200
@@ -607,7 +607,7 @@
 
 
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ perfmon/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
Index: o/include/linux/sched.h
===================================================================
--- o.orig/include/linux/sched.h	2008-06-05 11:00:37.000000000 +0200
+++ o/include/linux/sched.h	2008-06-05 11:00:43.000000000 +0200
@@ -95,6 +95,7 @@
 struct futex_pi_state;
 struct robust_list_head;
 struct bio;
+struct pfm_context;
 
 /*
  * List of flags we want to share for kernel threads,
@@ -1303,6 +1304,9 @@
 	int latency_record_count;
 	struct latency_record latency_record[LT_SAVECOUNT];
 #endif
+#ifdef CONFIG_PERFMON
+	struct pfm_context *pfm_context;
+#endif
 };
 
 /*

-- 

