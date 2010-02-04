Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab0BDRWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:22:00 -0500
Received: from kroah.org ([198.145.64.141]:34672 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933119Ab0BDRVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:46 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:02 2010
Message-Id: <20100204171501.536548487@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [23/74] fix oops in fs/9p late mount failure
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 083c73c253c23c20359a344dfe1198ea628e6259 upstream.

if 9P ->get_sb() fails late (at root inode or root dentry
allocation), we'll hit its ->kill_sb() with NULL ->s_root

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/9p/vfs_super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -188,7 +188,8 @@ static void v9fs_kill_super(struct super
 
 	P9_DPRINTK(P9_DEBUG_VFS, " %p\n", s);
 
-	v9fs_dentry_release(s->s_root);	/* clunk root */
+	if (s->s_root)
+		v9fs_dentry_release(s->s_root);	/* clunk root */
 
 	kill_anon_super(s);
 


