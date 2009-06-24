Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbZFXUrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbZFXUrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZFXUq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:46:59 -0400
Received: from smtp-out-036.synserver.de ([212.40.180.36]:1158 "HELO
	smtp-out-036.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751654AbZFXUq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:46:58 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 2448
Date: Wed, 24 Jun 2009 22:46:58 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build failure latest git. (acl related)
Message-ID: <20090624204658.GB31192@phenom2.trippelsdorf.de>
References: <20090624200941.GA30531@phenom2.trippelsdorf.de> <20090624202852.GA31192@phenom2.trippelsdorf.de> <20090624203330.GS8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624203330.GS8633@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 09:33:30PM +0100, Al Viro wrote:
> On Wed, Jun 24, 2009 at 10:28:52PM +0200, Markus Trippelsdorf wrote:
> > 
> > This patch should fix it:
> 
> Applied.

While we're at it:

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 78ad38d..1f7aa6c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2122,10 +2122,12 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	 * any xattrs or acls
 	 */
 	maybe_acls = acls_after_inode_item(leaf, path->slots[0], inode->i_ino);
+#ifdef CONFIG_FS_POSIX_ACL
 	if (!maybe_acls) {
 		inode->i_acl = NULL;
 		inode->i_default_acl = NULL;
 	}
+#endif
 
 	BTRFS_I(inode)->block_group = btrfs_find_block_group(root, 0,
 						alloc_group_block, 0);
-- 
Markus
