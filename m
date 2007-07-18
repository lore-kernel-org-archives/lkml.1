Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbXGRFal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbXGRFal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbXGRFad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:30:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:32844 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbXGRFac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:30:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=NstFsWP8fmqqJNZzYuYWpX3apCEKjMYZ2Ku2n9DgjTDCOpaLy5n4GK9A/2eHEtmiihO+IK2naFEbaKEanXGDycRTSn69qOtK1FxfhMEp0WnY8A2j0k9XGYL4LEeRaLogPH13YKLKdj2cKiBMD82uT4Xn4rtWwR4sDjraULstLeM=
Date: Wed, 18 Jul 2007 14:30:28 +0900
From: Tejun Heo <htejun@gmail.com>
To: Greg KH <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs: make sysfs_init_inode() static
Message-ID: <20070718053028.GH23568@htj.dyndns.org>
References: <20070715124232.4e371bf9@hyperion.delvare> <20070717034844.GB11602@suse.de> <20070717131255.71b7e72e@hyperion.delvare> <20070717183652.GG9702@suse.de> <20070717230530.64d9a896@hyperion.delvare> <20070718052906.GG23568@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718052906.GG23568@htj.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With sysfs_fill_super() converted to use sysfs_get_inode(), there is
no user of sysfs_init_inode() outside of fs/sysfs/inode.c.  Make it
static.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/inode.c |    2 +-
 fs/sysfs/sysfs.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

Index: work/fs/sysfs/inode.c
===================================================================
--- work.orig/fs/sysfs/inode.c
+++ work/fs/sysfs/inode.c
@@ -133,7 +133,7 @@ static inline void set_inode_attr(struct
  */
 static struct lock_class_key sysfs_inode_imutex_key;
 
-void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
+static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
 	inode->i_blocks = 0;
 	inode->i_mapping->a_ops = &sysfs_aops;
Index: work/fs/sysfs/sysfs.h
===================================================================
--- work.orig/fs/sysfs/sysfs.h
+++ work/fs/sysfs/sysfs.h
@@ -71,7 +71,6 @@ extern void sysfs_remove_one(struct sysf
 extern int sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
 
 extern void sysfs_delete_inode(struct inode *inode);
-extern void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode);
 extern struct inode * sysfs_get_inode(struct sysfs_dirent *sd);
 extern void sysfs_instantiate(struct dentry *dentry, struct inode *inode);
 
