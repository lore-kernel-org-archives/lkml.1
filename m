Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbZLKEgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbZLKEgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760836AbZLKEgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:17 -0500
Received: from kroah.org ([198.145.64.141]:52911 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759460AbZLKEfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:44 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:34 2009
Message-Id: <20091211042733.492375175@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>
Subject: [14/90] ext4: Limit number of links that can be created by ext4_link()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0014-ext4-Limit-number-of-links-that-can-be-created-by-ex.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit b05ab1dc3795e6f997fb0d34f38fce5012533c3e)

In ext4_link we need to check using EXT4_LINK_MAX, and not
EXT4_DIR_LINK_MAX(), since ext4_link() is creating hard links of
regular files, and not directories.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2310,7 +2310,7 @@ static int ext4_link(struct dentry *old_
 	struct inode *inode = old_dentry->d_inode;
 	int err, retries = 0;
 
-	if (EXT4_DIR_LINK_MAX(inode))
+	if (inode->i_nlink >= EXT4_LINK_MAX)
 		return -EMLINK;
 
 	/*


