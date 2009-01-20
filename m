Return-Path: <linux-kernel-owner+w=401wt.eu-S1760919AbZATLcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919AbZATLcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 06:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbZATLcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 06:32:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50153 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119AbZATLcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:32:02 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: Alexander Viro <aviro@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/2] vfs: Further changes from macro to inline function in fs.h
Date: Tue, 20 Jan 2009 10:29:46 +0000
Message-Id: <1232447386-11758-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1232447386-11758-2-git-send-email-swhiteho@redhat.com>
References: <1232447386-11758-1-git-send-email-swhiteho@redhat.com>
 <1232447386-11758-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a second set of macros for when CONFIG_FILE_LOCKING is
not set. This patch updates those to become inline functions
as well.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 392c18a..7f5d794 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1794,13 +1794,44 @@ static inline int break_lease(struct inode *inode, unsigned int mode)
 	return 0;
 }
 #else /* !CONFIG_FILE_LOCKING */
-#define locks_mandatory_locked(a) ({ 0; })
-#define locks_mandatory_area(a, b, c, d, e) ({ 0; })
-#define __mandatory_lock(a) ({ 0; })
-#define mandatory_lock(a) ({ 0; })
-#define locks_verify_locked(a) ({ 0; })
-#define locks_verify_truncate(a, b, c) ({ 0; })
-#define break_lease(a, b) ({ 0; })
+static inline int locks_mandatory_locked(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int locks_mandatory_area(int rw, struct inode *inode,
+				       struct file *filp, loff_t offset,
+				       size_t count)
+{
+	return 0;
+}
+
+static inline int __mandatory_lock(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int mandatory_lock(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int locks_verify_locked(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int locks_verify_truncate(struct inode *inode, struct file *filp,
+					size_t size)
+{
+	return 0;
+}
+
+static inline int break_lease(struct inode *inode, unsigned int mode)
+{
+	return 0;
+}
+
 #endif /* CONFIG_FILE_LOCKING */
 
 /* fs/open.c */
-- 
1.6.0.3

