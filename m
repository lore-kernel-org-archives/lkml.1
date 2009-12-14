Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZLNAEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZLNAEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbZLMX6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:58:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34534 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110AbZLMX6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:30 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, pavel@ucw.cz, len.brown@intel.com,
       rjw@sisk.pl, akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: [PATCH 2/3] Constify struct platform_hibernation_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:22 +0100
Message-Id: <b8f2a18e81809fa76b68a3374f538311082fab96.1260663003.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663003.git.re.emese@gmail.com>
References: <cover.1260663003.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/linux/suspend.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 5e781d8..cb4cc7d 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -215,16 +215,16 @@ extern void mark_free_pages(struct zone *zone);
  *	platforms which require special recovery actions in that situation.
  */
 struct platform_hibernation_ops {
-	int (*begin)(void);
-	void (*end)(void);
-	int (*pre_snapshot)(void);
-	void (*finish)(void);
-	int (*prepare)(void);
-	int (*enter)(void);
-	void (*leave)(void);
-	int (*pre_restore)(void);
-	void (*restore_cleanup)(void);
-	void (*recover)(void);
+	int (* const begin)(void);
+	void (* const end)(void);
+	int (* const pre_snapshot)(void);
+	void (* const finish)(void);
+	int (* const prepare)(void);
+	int (* const enter)(void);
+	void (* const leave)(void);
+	int (* const pre_restore)(void);
+	void (* const restore_cleanup)(void);
+	void (* const recover)(void);
 };
 
 #ifdef CONFIG_HIBERNATION
@@ -243,7 +243,7 @@ extern void swsusp_set_page_free(struct page *);
 extern void swsusp_unset_page_free(struct page *);
 extern unsigned long get_safe_page(gfp_t gfp_mask);
 
-extern void hibernation_set_ops(struct platform_hibernation_ops *ops);
+extern void hibernation_set_ops(const struct platform_hibernation_ops *ops);
 extern int hibernate(void);
 extern bool system_entering_hibernation(void);
 #else /* CONFIG_HIBERNATION */
@@ -251,7 +251,7 @@ static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
 
-static inline void hibernation_set_ops(struct platform_hibernation_ops *ops) {}
+static inline void hibernation_set_ops(const struct platform_hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
 static inline bool system_entering_hibernation(void) { return false; }
 #endif /* CONFIG_HIBERNATION */
-- 
1.6.5.3

