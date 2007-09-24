Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbXIXWlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbXIXWlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbXIXWlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:41:13 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41646 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbXIXWlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:41:12 -0400
Date: Mon, 24 Sep 2007 17:40:18 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 6/11] eCryptfs: Update metadata read/write functions
Message-ID: <20070924224018.GE11833@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com> <20070917214844.GN13679@halcrow.austin.ibm.com> <20070919224817.78d5c5a4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919224817.78d5c5a4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 10:48:17PM -0700, Andrew Morton wrote:
> On Mon, 17 Sep 2007 16:48:44 -0500 Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> > +		if ((rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode,
> 
> checkpatch missed the assignment-in-an-if here.

Fix an assignment-in-an-if.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 4bf1a95..b3795f6 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1306,8 +1306,9 @@ ecryptfs_write_metadata_to_contents(struct ecryptfs_crypt_stat *crypt_stat,
 	int header_pages;
 	int rc;
 
-	if ((rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode, page_virt,
-				       0, PAGE_CACHE_SIZE))) {
+	rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode, page_virt,
+				  0, PAGE_CACHE_SIZE);
+	if (rc) {
 		printk(KERN_ERR "%s: Error attempting to write header "
 		       "information to lower file; rc = [%d]\n", __FUNCTION__,
 		       rc);
