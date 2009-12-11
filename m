Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZLKFb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZLKFb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZLKFbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:31:23 -0500
Received: from kroah.org ([198.145.64.141]:53616 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165AbZLKFaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:30:07 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:57 2009
Message-Id: <20091211052557.153813326@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [31/34] ext4: fix incorrect block reservation on quota transfer.
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0027-ext4-fix-incorrect-block-reservation-on-quota-transf.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit 194074acacebc169ded90a4657193f5180015051)

Inside ->setattr() call both ATTR_UID and ATTR_GID may be valid
This means that we may end-up with transferring all quotas. Add
we have to reserve QUOTA_DEL_BLOCKS for all quotas, as we do in
case of QUOTA_INIT_BLOCKS.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Reviewed-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5232,7 +5232,7 @@ int ext4_setattr(struct dentry *dentry,
 		/* (user+group)*(old+new) structure, inode write (sb,
 		 * inode block, ? - but truncate inode update has it) */
 		handle = ext4_journal_start(inode, (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
-					EXT4_QUOTA_DEL_BLOCKS(inode->i_sb))+3);
+					EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
 			goto err_out;


