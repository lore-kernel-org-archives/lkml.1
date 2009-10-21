Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbZJUTUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbZJUTUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbZJUTUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:20:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbZJUTUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:20:10 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
Subject: [PATCH 02/41] VFS: propagate mnt_flags into do_loopback
Date: Wed, 21 Oct 2009 12:19:00 -0700
Message-Id: <1256152779-10054-3-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-2-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

The mnt_flags are propagated into do_loopback(), so that they can be checked
when mounting something loopback into a union.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7230787..4cd43ea 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1446,8 +1446,8 @@ static int do_change_type(struct path *path, int flag)
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
@@ -1944,7 +1944,8 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
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
1.6.3.3

