Return-Path: <linux-kernel-owner+w=401wt.eu-S965596AbXBTAQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965596AbXBTAQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965638AbXBTAPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:15:33 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36099 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965593AbXBTAHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:07:35 -0500
Date: Tue, 20 Feb 2007 01:07:34 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, ericvh@gmail.com,
       rminnich@lanl.gov, lucho@ionkov.net
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Subject: [-mm patch] fs/9p/vfs_addr.c: make 2 functions static
Message-ID: <20070220000734.GX13958@stusta.de>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 09:51:46PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm1:
>...
>  git-v9fs.patch
>...
>  git trees
>...

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/9p/vfs_addr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.20-mm2/fs/9p/vfs_addr.c.old	2007-02-18 22:17:06.000000000 +0100
+++ linux-2.6.20-mm2/fs/9p/vfs_addr.c	2007-02-18 22:25:45.000000000 +0100
@@ -114,8 +114,8 @@
  *
  */
 
-int v9fs_prepare_write(struct file *file, struct page *page,
-		       unsigned from, unsigned to)
+static int v9fs_prepare_write(struct file *file, struct page *page,
+			      unsigned from, unsigned to)
 {
 	if(!PageUptodate(page)) {
 		if (to - from != PAGE_CACHE_SIZE) {
@@ -143,8 +143,8 @@
  * TODO: Perhaps I should just do the write here?
  */
 
-int v9fs_commit_write(struct file *file, struct page *page,
-		       unsigned offset, unsigned to)
+static int v9fs_commit_write(struct file *file, struct page *page,
+			     unsigned offset, unsigned to)
 {
         struct inode *inode = page->mapping->host;
         loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;

