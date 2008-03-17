Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYCQSqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYCQSqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYCQSp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:45:56 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52788 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbYCQSp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:45:56 -0400
Date: Mon, 17 Mar 2008 13:38:09 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: Rajouri Jammu <rajouri.jammu@gmail.com>, linux-kernel@vger.kernel.org,
       sandeen@redhat.com
Subject: [PATCH] eCryptfs: Swap dput() and mntput()
Message-ID: <20080317183809.GM4627@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ecryptfs_d_release() is doing a mntput before doing the dput. This
patch moves the dput before the mntput.

Thanks to Rajouri Jammu for reporting this.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---

diff --git a/fs/ecryptfs/dentry.c b/fs/ecryptfs/dentry.c
index 841a032..5e59658 100644
--- a/fs/ecryptfs/dentry.c
+++ b/fs/ecryptfs/dentry.c
@@ -80,8 +80,8 @@ static void ecryptfs_d_release(struct dentry *dentry)
 {
 	if (ecryptfs_dentry_to_private(dentry)) {
 		if (ecryptfs_dentry_to_lower(dentry)) {
-			mntput(ecryptfs_dentry_to_lower_mnt(dentry));
 			dput(ecryptfs_dentry_to_lower(dentry));
+			mntput(ecryptfs_dentry_to_lower_mnt(dentry));
 		}
 		kmem_cache_free(ecryptfs_dentry_info_cache,
 				ecryptfs_dentry_to_private(dentry));
