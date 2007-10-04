Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbXJDF4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbXJDF4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 01:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXJDFvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 01:51:39 -0400
Received: from THUNK.ORG ([69.25.196.29]:44812 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbXJDFvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 01:51:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, "Jose R. Santos" <jrs@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] JBD2: debug code cleanup.
Date: Thu,  4 Oct 2007 01:50:41 -0400
Message-Id: <1191477059-5357-7-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.3.2.81.g17ed
In-Reply-To: <1191477059-5357-6-git-send-email-tytso@mit.edu>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
 <1191477059-5357-2-git-send-email-tytso@mit.edu>
 <1191477059-5357-3-git-send-email-tytso@mit.edu>
 <1191477059-5357-4-git-send-email-tytso@mit.edu>
 <1191477059-5357-5-git-send-email-tytso@mit.edu>
 <1191477059-5357-6-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Mostly stolen from akpm's JBD cleanup patch.

- use `#ifdef foo' instead of `#if defined(foo)'

- Make journal_enable_debug __read_mostly just for the heck of it

- Make jbd_debugfs_dir and jbd_debug static

- debugfs_remove(NULL) is legal: remove unneeded tests

- remove unnecessary empty loops

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/jbd2/journal.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index ff07bff..6ddc553 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1864,16 +1864,14 @@ void jbd2_journal_put_journal_head(struct journal_head *jh)
 /*
  * debugfs tunables
  */
-#if defined(CONFIG_JBD2_DEBUG)
-u8 jbd2_journal_enable_debug;
+#ifdef CONFIG_JBD2_DEBUG
+u8 jbd2_journal_enable_debug __read_mostly;
 EXPORT_SYMBOL(jbd2_journal_enable_debug);
-#endif
-
-#if defined(CONFIG_JBD2_DEBUG) && defined(CONFIG_DEBUG_FS)
 
 #define JBD2_DEBUG_NAME "jbd2-debug"
 
-struct dentry *jbd2_debugfs_dir, *jbd2_debug;
+static struct dentry *jbd2_debugfs_dir;
+static struct dentry *jbd2_debug;
 
 static void __init jbd2_create_debugfs_entry(void)
 {
@@ -1886,24 +1884,18 @@ static void __init jbd2_create_debugfs_entry(void)
 
 static void __exit jbd2_remove_debugfs_entry(void)
 {
-	if (jbd2_debug)
-		debugfs_remove(jbd2_debug);
-	if (jbd2_debugfs_dir)
-		debugfs_remove(jbd2_debugfs_dir);
+	debugfs_remove(jbd2_debug);
+	debugfs_remove(jbd2_debugfs_dir);
 }
 
 #else
 
 static void __init jbd2_create_debugfs_entry(void)
 {
-	do {
-	} while (0);
 }
 
 static void __exit jbd2_remove_debugfs_entry(void)
 {
-	do {
-	} while (0);
 }
 
 #endif
-- 
1.5.3.2.81.g17ed

