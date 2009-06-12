Return-Path: <linux-kernel-owner+w=401wt.eu-S933312AbZFLSw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312AbZFLSw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762271AbZFLSvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:51:21 -0400
Received: from fifo99.com ([67.223.236.141]:46224 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194AbZFLSvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:51:17 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH 5/6] staging: android: binder: global variable cleanup.
Date: Fri, 12 Jun 2009 11:51:17 -0700
Message-Id: <1244832678-30329-5-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1244832678-30329-4-git-send-email-dwalker@fifo99.com>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
 <1244832678-30329-2-git-send-email-dwalker@fifo99.com>
 <1244832678-30329-3-git-send-email-dwalker@fifo99.com>
 <1244832678-30329-4-git-send-email-dwalker@fifo99.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced a manual hlist_head declaration with a macro based one.
Also reorganized the globals to be grouped better.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 drivers/staging/android/binder.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 30a5ea5..01711e3 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -31,18 +31,21 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <linux/vmalloc.h>
+
 #include "binder.h"
 
 static DEFINE_MUTEX(binder_lock);
+static DEFINE_MUTEX(binder_deferred_lock);
+
 static HLIST_HEAD(binder_procs);
+static HLIST_HEAD(binder_deferred_list);
+static HLIST_HEAD(binder_dead_nodes);
+
+static struct proc_dir_entry *binder_proc_dir_entry_root;
+static struct proc_dir_entry *binder_proc_dir_entry_proc;
 static struct binder_node *binder_context_mgr_node;
 static uid_t binder_context_mgr_uid = -1;
 static int binder_last_id;
-static struct proc_dir_entry *binder_proc_dir_entry_root;
-static struct proc_dir_entry *binder_proc_dir_entry_proc;
-static struct hlist_head binder_dead_nodes;
-static HLIST_HEAD(binder_deferred_list);
-static DEFINE_MUTEX(binder_deferred_lock);
 
 static int binder_read_proc_proc(char *page, char **start, off_t off,
 				 int count, int *eof, void *data);
-- 
1.5.4.3

