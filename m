Return-Path: <linux-kernel-owner+w=401wt.eu-S1765239AbXG2PBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765239AbXG2PBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764182AbXG2O5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:57:41 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47787 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764167AbXG2O5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:57:40 -0400
Date: Sun, 29 Jul 2007 16:57:17 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       William Irwin <bill.irwin@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make hugetlbfs_read() static
Message-ID: <20070729145717.GN16817@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
> +hugetlbfs-read-support.patch
>...
>  More MM things
>...

hugetlbfs_read() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/fs/hugetlbfs/inode.c.old	2007-07-26 13:28:52.000000000 +0200
+++ linux-2.6.23-rc1-mm1/fs/hugetlbfs/inode.c	2007-07-26 13:29:30.000000000 +0200
@@ -217,8 +217,8 @@
  * data. Its *very* similar to do_generic_mapping_read(), we can't use that
  * since it has PAGE_CACHE_SIZE assumptions.
  */
-ssize_t
-hugetlbfs_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos)
+static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
+			      size_t len, loff_t *ppos)
 {
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;

