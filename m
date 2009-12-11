Return-Path: <linux-kernel-owner+w=401wt.eu-S1751475AbZLKFdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbZLKFdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZLKFdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:33:38 -0500
Received: from kroah.org ([198.145.64.141]:53517 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbZLKF34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:29:56 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:50 2009
Message-Id: <20091211052549.883933582@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [18/34] ext4: fix error handling in ext4_ind_get_blocks()
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0014-ext4-fix-error-handling-in-ext4_ind_get_blocks.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1021,7 +1021,7 @@ static int ext4_ind_get_blocks(handle_t
 	if (!err)
 		err = ext4_splice_branch(handle, inode, iblock,
 					 partial, indirect_blks, count);
-	else
+	if (err)
 		goto cleanup;
 
 	set_buffer_new(bh_result);


