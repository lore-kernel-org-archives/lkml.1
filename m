Return-Path: <linux-kernel-owner+w=401wt.eu-S964876AbXG3QUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876AbXG3QUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938570AbXG3QOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:40568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933851AbXG3QOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:09 -0400
Message-Id: <20070730161325.355515545@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:47 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 24/26] union-mount: dont report EROFS for union mounts
Content-Disposition: inline; filename=um/union-mount-access.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SuS v2 requires we report a read only fs too. For union-mounts this is a very
expensive check. So I'm lazy and just disable the check if we are on a lower
layer of an union.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/open.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -483,7 +483,7 @@ asmlinkage long sys_faccessat(int dfd, c
 	   special_file(nd.dentry->d_inode->i_mode))
 		goto out_path_release;
 
-	if(IS_RDONLY(nd.dentry->d_inode))
+	if (!(nd.um_flags & LAST_LOWLEVEL) && IS_RDONLY(nd.dentry->d_inode))
 		res = -EROFS;
 
 out_path_release:

-- 

