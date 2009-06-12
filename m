Return-Path: <linux-kernel-owner+w=401wt.eu-S932076AbZFLSvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbZFLSvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760137AbZFLSvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:51:19 -0400
Received: from fifo99.com ([67.223.236.141]:46221 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbZFLSvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:51:17 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH 4/6] staging: android: binder: add enum usage in function arguments
Date: Fri, 12 Jun 2009 11:51:16 -0700
Message-Id: <1244832678-30329-4-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1244832678-30329-3-git-send-email-dwalker@fifo99.com>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
 <1244832678-30329-2-git-send-email-dwalker@fifo99.com>
 <1244832678-30329-3-git-send-email-dwalker@fifo99.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declare the binder_deferred_state enum, and use the new enum
for one of the binder_defer_work function arguments. This
should keep the argument within the confines of the enum
instead of the whole int range.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 drivers/staging/android/binder.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index ec86808..30a5ea5 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -243,7 +243,7 @@ struct binder_buffer {
 	uint8_t data[0];
 };
 
-enum {
+enum binder_deferred_state {
 	BINDER_DEFERRED_PUT_FILES    = 0x01,
 	BINDER_DEFERRED_FLUSH        = 0x02,
 	BINDER_DEFERRED_RELEASE      = 0x04,
@@ -326,7 +326,8 @@ struct binder_transaction {
 	uid_t	sender_euid;
 };
 
-static void binder_defer_work(struct binder_proc *proc, int defer);
+static void
+binder_defer_work(struct binder_proc *proc, enum binder_deferred_state defer);
 
 /*
  * copied from get_unused_fd_flags
@@ -3073,7 +3074,8 @@ static void binder_deferred_func(struct work_struct *work)
 }
 static DECLARE_WORK(binder_deferred_work, binder_deferred_func);
 
-static void binder_defer_work(struct binder_proc *proc, int defer)
+static void
+binder_defer_work(struct binder_proc *proc, enum binder_deferred_state defer)
 {
 	mutex_lock(&binder_deferred_lock);
 	proc->deferred_work |= defer;
-- 
1.5.4.3

