Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbZCPHbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbZCPHbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758092AbZCPHYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:24:04 -0400
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:35686 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbZCPHXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:23:02 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #2 27/28] export lookup functions
Date: Mon, 16 Mar 2009 16:20:39 +0900
Message-Id: <1237188040-11404-28-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
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
index bbc15c2..db581b4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1196,7 +1196,7 @@ out:
  * needs parent already locked. Doesn't follow mounts.
  * SMP-safe.
  */
-static struct dentry *lookup_hash(struct nameidata *nd)
+struct dentry *lookup_hash(struct nameidata *nd)
 {
 	int err;
 
@@ -1206,7 +1206,7 @@ static struct dentry *lookup_hash(struct nameidata *nd)
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

