Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbZLKEgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbZLKEgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbZLKEgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:18 -0500
Received: from kroah.org ([198.145.64.141]:52906 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759453AbZLKEfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:43 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:33 2009
Message-Id: <20091211042732.645012343@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Tso" <tytso@mit.edu>
Subject: [13/90] ext4: Allow rename to create more than EXT4_LINK_MAX subdirectories
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0013-ext4-Allow-rename-to-create-more-than-EXT4_LINK_MAX-.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 2c94eb86c66e1eaaa1e7d8a2120f4fad5e7e7736)

Use EXT4_DIR_LINK_MAX so that rename() can move a directory into new
parent directory without running into the EXT4_LINK_MAX limit.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2413,7 +2413,7 @@ static int ext4_rename(struct inode *old
 			goto end_rename;
 		retval = -EMLINK;
 		if (!new_inode && new_dir != old_dir &&
-				new_dir->i_nlink >= EXT4_LINK_MAX)
+		    EXT4_DIR_LINK_MAX(new_dir))
 			goto end_rename;
 	}
 	if (!new_bh) {


