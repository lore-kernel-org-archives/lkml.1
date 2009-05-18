Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZERQJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZERQJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbZERQJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:09:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbZERQJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:28 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 03/32] VFS: propagate mnt_flags into do_loopback
Date: Mon, 18 May 2009 18:08:59 +0200
Message-Id: <1242662968-11684-4-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mnt_flags are propagated into do_loopback(), so that they can be checked
when mounting something loopback into a union.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/namespace.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 06f8e63..f0a5ce7 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1461,8 +1461,8 @@ static int do_change_type(struct path *path, int flag)
 /*
  * do loopback mount.
  */
-static int do_loopback(struct path *path, char *old_name,
-				int recurse)
+static int do_loopback(struct path *path, char *old_name, int recurse,
+		       int mnt_flags)
 {
 	struct path old_path;
 	struct vfsmount *mnt = NULL;
@@ -1952,7 +1952,8 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
 				    data_page);
 	else if (flags & MS_BIND)
-		retval = do_loopback(&path, dev_name, flags & MS_REC);
+		retval = do_loopback(&path, dev_name, flags & MS_REC,
+				     mnt_flags);
 	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
 		retval = do_change_type(&path, flags);
 	else if (flags & MS_MOVE)
-- 
1.6.1.3

