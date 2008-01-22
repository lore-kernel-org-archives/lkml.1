Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbYAVDGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbYAVDGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYAVDDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:03:31 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64877 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756076AbYAVDD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:03:29 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Chris Snook <csnook@redhat.com>, "Stephen C. Tweedie" <sct@redhat.com>,
       "Theodore Ts'o" <tytso@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 25/49] jbd2: Remove printk from J_ASSERT to preserve registers during BUG
Date: Mon, 21 Jan 2008 22:02:04 -0500
Message-Id: <1200970948-17903-26-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-25-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
 <1200970948-17903-23-git-send-email-tytso@mit.edu>
 <1200970948-17903-24-git-send-email-tytso@mit.edu>
 <1200970948-17903-25-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Signed-off-by: Chris Snook <csnook@redhat.com>
Cc: "Stephen C. Tweedie" <sct@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 include/linux/jbd2.h |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 06ef114..d5f7cff 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -256,17 +256,7 @@ typedef struct journal_superblock_s
 #include <linux/fs.h>
 #include <linux/sched.h>
 
-#define JBD2_ASSERTIONS
-#ifdef JBD2_ASSERTIONS
-#define J_ASSERT(assert)						\
-do {									\
-	if (!(assert)) {						\
-		printk (KERN_EMERG					\
-			"Assertion failure in %s() at %s:%d: \"%s\"\n",	\
-			__FUNCTION__, __FILE__, __LINE__, # assert);	\
-		BUG();							\
-	}								\
-} while (0)
+#define J_ASSERT(assert)	BUG_ON(!(assert))
 
 #if defined(CONFIG_BUFFER_DEBUG)
 void buffer_assertion_failure(struct buffer_head *bh);
@@ -282,10 +272,6 @@ void buffer_assertion_failure(struct buffer_head *bh);
 #define J_ASSERT_JH(jh, expr)	J_ASSERT(expr)
 #endif
 
-#else
-#define J_ASSERT(assert)	do { } while (0)
-#endif		/* JBD2_ASSERTIONS */
-
 #if defined(JBD2_PARANOID_IOFAIL)
 #define J_EXPECT(expr, why...)		J_ASSERT(expr)
 #define J_EXPECT_BH(bh, expr, why...)	J_ASSERT_BH(bh, expr)
-- 
1.5.4.rc3.31.g1271-dirty

