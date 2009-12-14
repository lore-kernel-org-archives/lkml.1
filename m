Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZLNAC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZLNAC5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbZLNACr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:02:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175AbZLMX6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:36 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, len.brown@intel.com, pavel@ucw.cz,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: [PATCH 05/10] Constify struct platform_suspend_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:21 +0100
Message-Id: <2218084c294878ee335de04178d4c0b93167e248.1260663003.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663003.git.re.emese@gmail.com>
References: <cover.1260663003.git.re.emese@gmail.com>
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
 include/linux/suspend.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 5e781d8..3a2553d 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -104,15 +104,15 @@ typedef int __bitwise suspend_state_t;
  *	which require special recovery actions in that situation.
  */
 struct platform_suspend_ops {
-	int (*valid)(suspend_state_t state);
-	int (*begin)(suspend_state_t state);
-	int (*prepare)(void);
-	int (*prepare_late)(void);
-	int (*enter)(suspend_state_t state);
-	void (*wake)(void);
-	void (*finish)(void);
-	void (*end)(void);
-	void (*recover)(void);
+	int (* const valid)(suspend_state_t state);
+	int (* const begin)(suspend_state_t state);
+	int (* const prepare)(void);
+	int (* const prepare_late)(void);
+	int (* const enter)(suspend_state_t state);
+	void (* const wake)(void);
+	void (* const finish)(void);
+	void (* const end)(void);
+	void (* const recover)(void);
 };
 
 #ifdef CONFIG_SUSPEND
@@ -120,7 +120,7 @@ struct platform_suspend_ops {
  * suspend_set_ops - set platform dependent suspend operations
  * @ops: The new suspend operations to set.
  */
-extern void suspend_set_ops(struct platform_suspend_ops *ops);
+extern void suspend_set_ops(const struct platform_suspend_ops *ops);
 extern int suspend_valid_only_mem(suspend_state_t state);
 
 /**
@@ -145,7 +145,7 @@ extern int pm_suspend(suspend_state_t state);
 #else /* !CONFIG_SUSPEND */
 #define suspend_valid_only_mem	NULL
 
-static inline void suspend_set_ops(struct platform_suspend_ops *ops) {}
+static inline void suspend_set_ops(const struct platform_suspend_ops *ops) {}
 static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
 #endif /* !CONFIG_SUSPEND */
 
-- 
1.6.5.3

