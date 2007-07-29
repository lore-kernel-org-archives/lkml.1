Return-Path: <linux-kernel-owner+w=401wt.eu-S1766012AbXG2PEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766012AbXG2PEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764186AbXG2O6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:58:21 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47809 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764343AbXG2O6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:58:19 -0400
Date: Sun, 29 Jul 2007 16:57:57 +0200
From: Adrian Bunk <bunk@stusta.de>
To: neilb@suse.de
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/nfsd/export.c: make 3 functions static
Message-ID: <20070729145757.GS16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- exp_get_by_name()
- exp_parent()
- exp_find()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/nfsd/export.c            |   17 ++++++++---------
 include/linux/nfsd/export.h |   11 -----------
 2 files changed, 8 insertions(+), 20 deletions(-)

--- linux-2.6.23-rc1-mm1/include/linux/nfsd/export.h.old	2007-07-26 14:31:53.000000000 +0200
+++ linux-2.6.23-rc1-mm1/include/linux/nfsd/export.h	2007-07-26 15:04:52.000000000 +0200
@@ -127,17 +127,9 @@
 void			nfsd_export_flush(void);
 void			exp_readlock(void);
 void			exp_readunlock(void);
-struct svc_export *	exp_get_by_name(struct auth_domain *clp,
-					struct vfsmount *mnt,
-					struct dentry *dentry,
-					struct cache_req *reqp);
 struct svc_export *	rqst_exp_get_by_name(struct svc_rqst *,
 					     struct vfsmount *,
 					     struct dentry *);
-struct svc_export *	exp_parent(struct auth_domain *clp,
-				   struct vfsmount *mnt,
-				   struct dentry *dentry,
-				   struct cache_req *reqp);
 struct svc_export *	rqst_exp_parent(struct svc_rqst *,
 					struct vfsmount *mnt,
 					struct dentry *dentry);
@@ -157,9 +149,6 @@
 {
 	cache_get(&exp->h);
 }
-extern struct svc_export *
-exp_find(struct auth_domain *clp, int fsid_type, u32 *fsidv,
-	 struct cache_req *reqp);
 struct svc_export * rqst_exp_find(struct svc_rqst *, int, u32 *);
 
 #endif /* __KERNEL__ */
--- linux-2.6.23-rc1-mm1/fs/nfsd/export.c.old	2007-07-26 14:32:17.000000000 +0200
+++ linux-2.6.23-rc1-mm1/fs/nfsd/export.c	2007-07-26 14:36:58.000000000 +0200
@@ -860,9 +860,9 @@
 	return exp_find_key(clp, FSID_NUM, fsidv, NULL);
 }
 
-svc_export *
-exp_get_by_name(svc_client *clp, struct vfsmount *mnt, struct dentry *dentry,
-		struct cache_req *reqp)
+static svc_export *exp_get_by_name(svc_client *clp, struct vfsmount *mnt,
+				   struct dentry *dentry,
+				   struct cache_req *reqp)
 {
 	struct svc_export *exp, key;
 	int err;
@@ -886,9 +886,9 @@
 /*
  * Find the export entry for a given dentry.
  */
-struct svc_export *
-exp_parent(svc_client *clp, struct vfsmount *mnt, struct dentry *dentry,
-	   struct cache_req *reqp)
+static struct svc_export *exp_parent(svc_client *clp, struct vfsmount *mnt,
+				     struct dentry *dentry,
+				     struct cache_req *reqp)
 {
 	svc_export *exp;
 
@@ -1213,9 +1213,8 @@
 	return err;
 }
 
-struct svc_export *
-exp_find(struct auth_domain *clp, int fsid_type, u32 *fsidv,
-	 struct cache_req *reqp)
+static struct svc_export *exp_find(struct auth_domain *clp, int fsid_type,
+				   u32 *fsidv, struct cache_req *reqp)
 {
 	struct svc_export *exp;
 	struct svc_expkey *ek = exp_find_key(clp, fsid_type, fsidv, reqp);

