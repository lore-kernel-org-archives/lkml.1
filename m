Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbXCYO77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbXCYO77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 10:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXCYO7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 10:59:53 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34051 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751431AbXCYO62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 10:58:28 -0400
Date: Sun, 25 Mar 2007 16:58:32 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>, neilb@suse.de,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove nfs4_acl_add_ace()
Message-ID: <20070325145832.GL16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nfs4_acl_add_ace() can now be removed.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 20 Feb 2007

 fs/nfsd/nfs4acl.c        |   17 -----------------
 include/linux/nfs4_acl.h |    1 -
 2 files changed, 18 deletions(-)

--- linux-2.6.20-mm2/include/linux/nfs4_acl.h.old	2007-02-18 22:40:31.000000000 +0100
+++ linux-2.6.20-mm2/include/linux/nfs4_acl.h	2007-02-18 22:40:36.000000000 +0100
@@ -44,7 +44,6 @@
 #define NFS4_ACL_MAX 170
 
 struct nfs4_acl *nfs4_acl_new(int);
-void nfs4_acl_add_ace(struct nfs4_acl *, u32, u32, u32, int, uid_t);
 int nfs4_acl_get_whotype(char *, u32);
 int nfs4_acl_write_who(int who, char *p);
 int nfs4_acl_permission(struct nfs4_acl *acl, uid_t owner, gid_t group,
--- linux-2.6.20-mm2/fs/nfsd/nfs4acl.c.old	2007-02-18 22:40:43.000000000 +0100
+++ linux-2.6.20-mm2/fs/nfsd/nfs4acl.c	2007-02-18 22:41:50.000000000 +0100
@@ -137,7 +137,6 @@
 static short ace2type(struct nfs4_ace *);
 static void _posix_to_nfsv4_one(struct posix_acl *, struct nfs4_acl *,
 				unsigned int);
-void nfs4_acl_add_ace(struct nfs4_acl *, u32, u32, u32, int, uid_t);
 
 struct nfs4_acl *
 nfs4_acl_posix_to_nfsv4(struct posix_acl *pacl, struct posix_acl *dpacl,
@@ -785,21 +784,6 @@
 	return acl;
 }
 
-void
-nfs4_acl_add_ace(struct nfs4_acl *acl, u32 type, u32 flag, u32 access_mask,
-		int whotype, uid_t who)
-{
-	struct nfs4_ace *ace = acl->aces + acl->naces;
-
-	ace->type = type;
-	ace->flag = flag;
-	ace->access_mask = access_mask;
-	ace->whotype = whotype;
-	ace->who = who;
-
-	acl->naces++;
-}
-
 static struct {
 	char *string;
 	int   stringlen;
@@ -851,6 +835,5 @@
 }
 
 EXPORT_SYMBOL(nfs4_acl_new);
-EXPORT_SYMBOL(nfs4_acl_add_ace);
 EXPORT_SYMBOL(nfs4_acl_get_whotype);
 EXPORT_SYMBOL(nfs4_acl_write_who);

