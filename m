Return-Path: <linux-kernel-owner+w=401wt.eu-S934033AbZLKEpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033AbZLKEpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933492AbZLKEp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:45:28 -0500
Received: from kroah.org ([198.145.64.141]:37042 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762190AbZLKEgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:36 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:12 2009
Message-Id: <20091211042811.707301090@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [70/90] ext4: fix error handling in ext4_ind_get_blocks()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0070-ext4-fix-error-handling-in-ext4_ind_get_blocks.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 2bba702d4f88d7b010ec37e2527b552588404ae7)

When an error happened in ext4_splice_branch we failed to notice that
in ext4_ind_get_blocks and mapped the buffer anyway. Fix the problem
by checking for error properly.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1022,7 +1022,7 @@ static int ext4_ind_get_blocks(handle_t
 	if (!err)
 		err = ext4_splice_branch(handle, inode, iblock,
 					 partial, indirect_blks, count);
-	else
+	if (err)
 		goto cleanup;
 
 	set_buffer_new(bh_result);


