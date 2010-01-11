Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420Ab0AKUWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0AKUWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208Ab0AKUWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:22:21 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40053 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab0AKUWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:22:19 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 7/7] sysfs: Kill unused sysfs_sb variable.
Date: Mon, 11 Jan 2010 12:21:55 -0800
Message-Id: <1263241315-19499-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1d41g9z3q.fsf@fess.ebiederm.org>
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that there are no more users we can remove
the sysfs_sb variable.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/mount.c |    2 --
 fs/sysfs/sysfs.h |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 77bce54..50cf41c 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -23,7 +23,6 @@
 
 
 static struct vfsmount *sysfs_mount;
-struct super_block * sysfs_sb = NULL;
 struct kmem_cache *sysfs_dir_cachep;
 
 static const struct super_operations sysfs_ops = {
@@ -51,7 +50,6 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_magic = SYSFS_MAGIC;
 	sb->s_op = &sysfs_ops;
 	sb->s_time_gran = 1;
-	sysfs_sb = sb;
 
 	/* get root inode, initialize and unlock it */
 	mutex_lock(&sysfs_mutex);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 1ae6009..0ea96af 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -112,7 +112,6 @@ struct sysfs_addrm_cxt {
  * mount.c
  */
 extern struct sysfs_dirent sysfs_root;
-extern struct super_block *sysfs_sb;
 extern struct kmem_cache *sysfs_dir_cachep;
 
 /*
-- 
1.6.5.2.143.g8cc62

