Return-Path: <linux-kernel-owner+w=401wt.eu-S1762577AbZLKEoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762577AbZLKEoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762276AbZLKEgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:43 -0500
Received: from kroah.org ([198.145.64.141]:36791 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760572AbZLKEf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:57 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:47 2009
Message-Id: <20091211042746.862451041@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andreas Schlick <schlick@lavabit.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [28/90] ext4: Always set dx_nodes fake_dirent explicitly.
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0028-ext4-Always-set-dx_node-s-fake_dirent-explicitly.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 1f7bebb9e911d870fa8f997ddff838e82b5715ea)

When ext4_dx_add_entry() has to split an index node, it has to ensure that
name_len of dx_node's fake_dirent is also zero, because otherwise e2fsck
won't recognise it as an intermediate htree node and consider the htree to
be corrupted.

Signed-off-by: Andreas Schlick <schlick@lavabit.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1590,9 +1590,9 @@ static int ext4_dx_add_entry(handle_t *h
 			goto cleanup;
 		node2 = (struct dx_node *)(bh2->b_data);
 		entries2 = node2->entries;
+		memset(&node2->fake, 0, sizeof(struct fake_dirent));
 		node2->fake.rec_len = ext4_rec_len_to_disk(sb->s_blocksize,
 							   sb->s_blocksize);
-		node2->fake.inode = 0;
 		BUFFER_TRACE(frame->bh, "get_write_access");
 		err = ext4_journal_get_write_access(handle, frame->bh);
 		if (err)


