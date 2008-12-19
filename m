Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYLSUsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYLSUsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYLSUrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:47:33 -0500
Received: from kumera.dghda.com ([80.68.90.171]:35274 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYLSUrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:47:31 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>
Subject: [PATCH, v5] vfs: introduce helper function to safely NUL-terminate symlinks
Date: Fri, 19 Dec 2008 20:47:11 +0000
Message-Id: <1229719638-6982-4-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229719638-6982-3-git-send-email-duaneg@dghda.com>
References: <1229719638-6982-1-git-send-email-duaneg@dghda.com>
 <1229719638-6982-2-git-send-email-duaneg@dghda.com>
 <1229719638-6982-3-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of filesystems were potentially triggering kernel bugs due to
corrupted symlink names on disk. This function helps safely terminate
the names.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

Unchanged from v4.

 include/linux/namei.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/namei.h b/include/linux/namei.h
index 99eb803..fc2e035 100644
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

