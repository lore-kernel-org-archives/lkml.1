Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbZDWTNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbZDWTNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758956AbZDWTMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:12:22 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41994 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957AbZDWTMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:12:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=JKIjTF1LsRqj2Tt8wUw7KLokDy5c/puf+7RtcwDmWFj6XcjNZ1E4Jtzd4jKCkSiYS+
         H691T9q6ITROLyS7pSbH/Xjg3abN4peXyMBVvsKY5qhFngkLHANAbKMBkFVCrpML2G2J
         5rWasH802+Z/nPXRtmx1urdpeZh5GpKGap7iQ=
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 3/5 -tip] fuse: umount_begin BKL pushdown
Date: Thu, 23 Apr 2009 21:12:03 +0200
Message-Id: <1240513925-5603-4-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1240513925-5603-3-git-send-email-abogani@texware.it>
References: <1240513925-5603-1-git-send-email-abogani@texware.it>
 <1240513925-5603-2-git-send-email-abogani@texware.it>
 <1240513925-5603-3-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/fuse/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 459b73d..d1bc4d3 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -19,6 +19,7 @@
 #include <linux/random.h>
 #include <linux/sched.h>
 #include <linux/exportfs.h>
+#include <linux/smp_lock.h>
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Filesystem in Userspace");
@@ -259,7 +260,9 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 
 static void fuse_umount_begin(struct super_block *sb)
 {
+	lock_kernel();
 	fuse_abort_conn(get_fuse_conn_super(sb));
+	unlock_kernel();
 }
 
 static void fuse_send_destroy(struct fuse_conn *fc)
-- 
1.6.0.4

