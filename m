Return-Path: <linux-kernel-owner+w=401wt.eu-S934785AbYDNSpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934785AbYDNSpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934255AbYDNSmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:42:39 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51114 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934248AbYDNSmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:42:38 -0400
Date: Mon, 14 Apr 2008 21:41:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>, Trond.Myklebust@netapp.com
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make nfs_automount_list static
Message-ID: <20080414184132.GT6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nfs_automount_list can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008

 fs/nfs/namespace.c     |    2 +-
 include/linux/nfs_fs.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

7620c6ff4cdf4975d02158361f85e7d881f55ec3 diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 607f6eb..af4d0f1 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -20,7 +20,7 @@
 
 static void nfs_expire_automounts(struct work_struct *work);
 
-LIST_HEAD(nfs_automount_list);
+static LIST_HEAD(nfs_automount_list);
 static DECLARE_DELAYED_WORK(nfs_automount_task, nfs_expire_automounts);
 int nfs_mountpoint_expiry_timeout = 500 * HZ;
 
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index f4a0e4c..13f7c75 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -430,7 +430,6 @@ extern void nfs_unregister_sysctl(void);
 /*
  * linux/fs/nfs/namespace.c
  */
-extern struct list_head nfs_automount_list;
 extern const struct inode_operations nfs_mountpoint_inode_operations;
 extern const struct inode_operations nfs_referral_inode_operations;
 extern int nfs_mountpoint_expiry_timeout;

