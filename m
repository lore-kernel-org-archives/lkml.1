Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbYLPPwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbYLPPwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbYLPPwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:52:10 -0500
Received: from kumera.dghda.com ([80.68.90.171]:53422 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383AbYLPPwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:52:07 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] vfs: introduce helper function to safely NUL-terminate symlinks
Date: Tue, 16 Dec 2008 15:51:53 +0000
Message-Id: <1229442720-31056-2-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229442720-31056-1-git-send-email-duaneg@dghda.com>
References: <1229442720-31056-1-git-send-email-duaneg@dghda.com>
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
 include/linux/namei.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/namei.h b/include/linux/namei.h
index 99eb803..231ce28 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -94,4 +94,9 @@ static inline char *nd_get_link(struct nameidata *nd)
 	return nd->saved_names[nd->depth];
 }
 
+static inline void nd_terminate_link(void *name, unsigned len, unsigned maxlen)
+{
+	((char *) name)[min(len, maxlen)] = '\0';
+}
+
 #endif /* _LINUX_NAMEI_H */
-- 
1.6.0.4

