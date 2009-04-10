Return-Path: <linux-kernel-owner+w=401wt.eu-S938831AbZDJHaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938831AbZDJHaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938144AbZDJHSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:18:49 -0400
Received: from mfbichi11.ns.itscom.net ([219.110.2.189]:61591 "EHLO
	mfbichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938093AbZDJHSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:18:35 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #5 28/29] export lookup functions
Date: Fri, 10 Apr 2009 16:02:42 +0900
Message-Id: <1239346963-30953-29-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export lookup functions to aufs module and others

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/namei.c            |    4 ++--
 include/linux/namei.h |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b8433eb..dc199ac 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1200,7 +1200,7 @@ out:
  * needs parent already locked. Doesn't follow mounts.
  * SMP-safe.
  */
-static struct dentry *lookup_hash(struct nameidata *nd)
+struct dentry *lookup_hash(struct nameidata *nd)
 {
 	int err;
 
@@ -1210,7 +1210,7 @@ static struct dentry *lookup_hash(struct nameidata *nd)
 	return __lookup_hash(&nd->last, nd->path.dentry, nd);
 }
 
-static int __lookup_one_len(const char *name, struct qstr *this,
+int __lookup_one_len(const char *name, struct qstr *this,
 		struct dentry *base, int len)
 {
 	unsigned long hash;
diff --git a/include/linux/namei.h b/include/linux/namei.h
index fc2e035..182d43b 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -75,6 +75,9 @@ extern struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry
 extern struct file *nameidata_to_filp(struct nameidata *nd, int flags);
 extern void release_open_intent(struct nameidata *);
 
+extern struct dentry *lookup_hash(struct nameidata *nd);
+extern int __lookup_one_len(const char *name, struct qstr *this,
+			    struct dentry *base, int len);
 extern struct dentry *lookup_one_len(const char *, struct dentry *, int);
 extern struct dentry *lookup_one_noperm(const char *, struct dentry *);
 
-- 
1.6.1.284.g5dc13

