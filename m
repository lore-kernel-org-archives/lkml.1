Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbZLDWea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbZLDWea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932456AbZLDWe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:34:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44410 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932371AbZLDWe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:34:28 -0500
Message-ID: <4B198EE7.1020007@gmail.com>
Date: Fri, 04 Dec 2009 23:36:23 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: matthew@wil.cx, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 19/31] Constify struct lock_manager_operations for 2.6.32
 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
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

Constify struct lock_manager_operations.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/linux/fs.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2620a8c..8ed405e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1032,14 +1032,14 @@ struct file_lock_operations {
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

