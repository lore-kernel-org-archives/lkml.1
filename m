Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZEETk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZEETk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbZEETkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:40:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147AbZEETkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:40:08 -0400
Message-Id: <20090505193206.840761438@suse.com>
User-Agent: quilt/0.47-14.9
Date: Tue, 05 May 2009 15:30:16 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: ReiserFS Devel <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Al Viron <viro@ZenIV.linux.org.uk>
Subject: [patch 2/3] reiserfs: dont associate security.* with xattr files
References: <20090505193014.926371851@suse.com>
Content-Disposition: inline; filename=reiserfs-fixup-security
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The security.* xattrs are ignored for xattr files, so don't create them.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 fs/reiserfs/xattr_security.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/reiserfs/xattr_security.c
+++ b/fs/reiserfs/xattr_security.c
@@ -55,8 +55,16 @@ int reiserfs_security_init(struct inode
 			   struct reiserfs_security_handle *sec)
 {
 	int blocks = 0;
-	int error = security_inode_init_security(inode, dir, &sec->name,
-						 &sec->value, &sec->length);
+	int error;
+
+	sec->name = NULL;
+
+	/* Don't add selinux attributes on xattrs - they'll never get used */
+	if (IS_PRIVATE(dir))
+		return 0;
+
+	error = security_inode_init_security(inode, dir, &sec->name,
+					     &sec->value, &sec->length);
 	if (error) {
 		if (error == -EOPNOTSUPP)
 			error = 0;


