Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYLPQx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYLPQx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbYLPQxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:53:44 -0500
Received: from kumera.dghda.com ([80.68.90.171]:53936 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbYLPQxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:53:43 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH, v4] vfs: introduce helper function to safely NUL-terminate symlinks
Date: Tue, 16 Dec 2008 16:53:38 +0000
Message-Id: <1229446419-8680-1-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of filesystems were potentially triggering kernel bugs due to
corrupted symlink names on disk. This helper helps safely terminate the
names.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

Version 4, this time with size_t instead of unsigned. Thanks Al!

 include/linux/namei.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/namei.h b/include/linux/namei.h
index 99eb803..231ce28 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -94,4 +94,9 @@ static inline char *nd_get_link(struct nameidata *nd)
 	return nd->saved_names[nd->depth];
 }
 
+static inline void nd_terminate_link(void *name, size_t len, size_t maxlen)
+{
+	((char *) name)[min(len, maxlen)] = '\0';
+}
+
 #endif /* _LINUX_NAMEI_H */
-- 
1.6.0.4

