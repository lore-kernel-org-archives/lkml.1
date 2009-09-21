Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbZIUB3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbZIUB3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 21:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZIUB3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 21:29:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbZIUB3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 21:29:37 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] VFS: document what MAY_ACCESS means
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org
Date: Sun, 20 Sep 2009 21:29:33 -0400
Message-ID: <20090921012933.2631.85495.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfs MAY_ACCESS flag really means that we might not use the object
immediately (consider chdir which might not actually use the new dir).
Thus permissions must be checked rather than relying on checkes during
later access of the object in question.  This patch just adds some
documentation so the meaning of the flag is clear.  I would rename the flag,
but it's already visable (although useless) to userspace.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fs.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 215b708..f683b29 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -51,6 +51,13 @@ struct inodes_stat_t {
 #define MAY_WRITE 2
 #define MAY_READ 4
 #define MAY_APPEND 8
+/*
+ * The vfs MAY_ACCESS flag really means that we might not use the object
+ * immediately (consider chdir which might not actually use the new dir).
+ * Thus permissions must be checked mmediately rather than relying on later
+ * checks during the actual user of the object in question.  This is an
+ * internal flag and should not come from userspace.
+ */
 #define MAY_ACCESS 16
 #define MAY_OPEN 32
 

