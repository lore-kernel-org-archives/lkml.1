Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbZFQUqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbZFQUqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760687AbZFQUpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:45:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757056AbZFQUpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:45:09 -0400
From: Jan Blunck <jblunck@suse.de>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       vaurora@redhat.com, hch@lst.de, miklos@szeredi.hu
Subject: [PATCH] VFS: propagate mnt_flags into do_loopback
Date: Wed, 17 Jun 2009 22:45:06 +0200
Message-Id: <1245271510-31542-3-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245271510-31542-1-git-send-email-jblunck@suse.de>
References: <1245271510-31542-1-git-send-email-jblunck@suse.de>
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
index 134d494..bdff9e4 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1475,8 +1475,8 @@ static int do_change_type(struct path *path, int flag)
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
@@ -1971,7 +1971,8 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
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
1.6.0.2

