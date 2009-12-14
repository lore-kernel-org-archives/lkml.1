Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZLNAJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZLNAJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbZLNAI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:08:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34402 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027AbZLMX6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:15 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, matthew@wil.cx,
       akpm@linux-foundation.org, jens.axboe@oracle.com,
       torvalds@linux-foundation.org
Subject: [PATCH 1/1] Constify struct lock_manager_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:08 +0100
Message-Id: <9f9a19ecaeef05f0f9adf44d343194e928db0dd5.1260663001.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663001.git.re.emese@gmail.com>
References: <cover.1260663001.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/linux/fs.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index a057f48..ea774a3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1033,14 +1033,14 @@ struct file_lock_operations {
 };
 
 struct lock_manager_operations {
-	int (*fl_compare_owner)(struct file_lock *, struct file_lock *);
-	void (*fl_notify)(struct file_lock *);	/* unblock callback */
-	int (*fl_grant)(struct file_lock *, struct file_lock *, int);
-	void (*fl_copy_lock)(struct file_lock *, struct file_lock *);
-	void (*fl_release_private)(struct file_lock *);
-	void (*fl_break)(struct file_lock *);
-	int (*fl_mylease)(struct file_lock *, struct file_lock *);
-	int (*fl_change)(struct file_lock **, int);
+	int (* const fl_compare_owner)(struct file_lock *, struct file_lock *);
+	void (* const fl_notify)(struct file_lock *);	/* unblock callback */
+	int (* const fl_grant)(struct file_lock *, struct file_lock *, int);
+	void (* const fl_copy_lock)(struct file_lock *, struct file_lock *);
+	void (* const fl_release_private)(struct file_lock *);
+	void (* const fl_break)(struct file_lock *);
+	int (* const fl_mylease)(struct file_lock *, struct file_lock *);
+	int (* const fl_change)(struct file_lock **, int);
 };
 
 struct lock_manager {
-- 
1.6.5.3

