Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbYGXHmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbYGXHmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 03:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYGXHmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 03:42:25 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:25542 "EHLO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbYGXHmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:42:24 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-3.tower-29.messagelabs.com!1216885344!19622273!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <trivial@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] move kernel-doc comment for might_sleep directly before its defining block
Date: Thu, 24 Jul 2008 09:42:20 +0200
Message-ID: <1216885340-12663-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.6.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jul 2008 07:42:20.0751 (UTC) FILETIME=[CDEC2DF0:01C8ED60]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 include/linux/kernel.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f9cd7a5..24439f9 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -100,6 +100,13 @@ struct completion;
 struct pt_regs;
 struct user;
 
+#ifdef CONFIG_PREEMPT_VOLUNTARY
+extern int _cond_resched(void);
+# define might_resched() _cond_resched()
+#else
+# define might_resched() do { } while (0)
+#endif
+
 /**
  * might_sleep - annotation for functions that can sleep
  *
@@ -110,13 +117,6 @@ struct user;
  * be bitten later when the calling function happens to sleep when it is not
  * supposed to.
  */
-#ifdef CONFIG_PREEMPT_VOLUNTARY
-extern int _cond_resched(void);
-# define might_resched() _cond_resched()
-#else
-# define might_resched() do { } while (0)
-#endif
-
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
   void __might_sleep(char *file, int line);
 # define might_sleep() \
-- 
1.5.6.3

