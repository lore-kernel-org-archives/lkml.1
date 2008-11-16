Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYKPWTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYKPWTU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 17:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYKPWTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 17:19:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53219 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbYKPWTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 17:19:12 -0500
Date: Sun, 16 Nov 2008 22:19:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Peter Palfrader <peter@palfrader.org>, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: broken ownership of /proc/sys/ files on 2.6.27
Message-ID: <20081116221910.GQ28946@ZenIV.linux.org.uk>
References: <20081116205922.GI28958@anguilla.noreply.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081116205922.GI28958@anguilla.noreply.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 09:59:22PM +0100, Peter Palfrader wrote:
> Hi,
> 
> on several (probably all) of my systems running a 2.6.27 kernel on at
> least i386, amd64, ia64, sparc proc/sys does have files not owned by
> root:

D'oh...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 94fcfff..06ed10b 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -31,6 +31,7 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	inode->i_flags |= S_PRIVATE; /* tell selinux to ignore this inode */
 	inode->i_mode = table->mode;
+	inode->i_uid = inode->i_gid = 0;
 	if (!table->child) {
 		inode->i_mode |= S_IFREG;
 		inode->i_op = &proc_sys_inode_operations;
