Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbZKFWHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbZKFWHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbZKFWHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:07:31 -0500
Received: from kroah.org ([198.145.64.141]:39818 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759985AbZKFWGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:06:02 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:53 2009
Message-Id: <20091106215953.387043228@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [26/30] NFSv4: The link() operation should return any delegation on the file
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=nfsv4-the-link-operation-should-return-any-delegation-on-the-file.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 9a3936aac133037f65124fcb2d676a6c201a90a4 upstream.

Otherwise, we have to wait for the server to recall it.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1526,6 +1526,8 @@ nfs_link(struct dentry *old_dentry, stru
 		old_dentry->d_parent->d_name.name, old_dentry->d_name.name,
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 
+	nfs_inode_return_delegation(inode);
+
 	d_drop(dentry);
 	error = NFS_PROTO(dir)->link(inode, dir, &dentry->d_name);
 	if (error == 0) {


