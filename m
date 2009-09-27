Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbZI0OA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbZI0OA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 10:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZI0OA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 10:00:28 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:55158 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbZI0OA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 10:00:28 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Sep 2009 10:00:27 EDT
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>,
       Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] WARN_ONCE(): use bool for boolean flag
Date: Sun, 27 Sep 2009 10:53:10 -0300
Message-Id: <1254059590-31690-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 70867453092297be9afb2249e712a1f960ec0a09 changed printk_once()
to use bool instead of int for its guard variable. Do the same change
to WARN_ONCE() and WARN_ON_ONCE(), for the same reasons.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 include/asm-generic/bug.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 4b67559..18c435d 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -113,22 +113,22 @@ extern void warn_slowpath_null(const char *file, const int line);
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
-	static int __warned;					\
+	static bool __warned;					\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
 		if (WARN_ON(!__warned)) 			\
-			__warned = 1;				\
+			__warned = true;			\
 	unlikely(__ret_warn_once);				\
 })
 
 #define WARN_ONCE(condition, format...)	({			\
-	static int __warned;					\
+	static bool __warned;					\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
 		if (WARN(!__warned, format)) 			\
-			__warned = 1;				\
+			__warned = true;			\
 	unlikely(__ret_warn_once);				\
 })
 
-- 
1.6.4.4

