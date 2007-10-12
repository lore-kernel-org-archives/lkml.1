Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbXJLQXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbXJLQXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759179AbXJLQIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:08:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758819AbXJLQIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:08:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 34/52] CRED: Make Ext3 ACL set handlers pass credentials down
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:08:13 +0100
Message-ID: <20071012160813.15119.87077.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make Ext3 ACL set handlers pass credentials down to lower functions.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/acl.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index 1db810a..239efa9 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -483,9 +483,8 @@ ext3_xattr_get_acl_default(struct inode *inode, const char *name,
 
 static int
 ext3_xattr_set_acl(struct inode *inode, int type, const void *value,
-		   size_t size)
+		   size_t size, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct posix_acl *acl;
 	int error, retries = 0;
@@ -526,18 +525,20 @@ static int
 ext3_xattr_set_acl_access(struct inode *inode, const char *name,
 			  const void *value, size_t size, int flags)
 {
+	struct cred *cred = current->cred;
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
-	return ext3_xattr_set_acl(inode, ACL_TYPE_ACCESS, value, size);
+	return ext3_xattr_set_acl(inode, ACL_TYPE_ACCESS, value, size, cred);
 }
 
 static int
 ext3_xattr_set_acl_default(struct inode *inode, const char *name,
 			   const void *value, size_t size, int flags)
 {
+	struct cred *cred = current->cred;
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
-	return ext3_xattr_set_acl(inode, ACL_TYPE_DEFAULT, value, size);
+	return ext3_xattr_set_acl(inode, ACL_TYPE_DEFAULT, value, size, cred);
 }
 
 struct xattr_handler ext3_xattr_acl_access_handler = {

