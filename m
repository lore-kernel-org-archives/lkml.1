Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYKTOyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYKTOyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbYKTOoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:44:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41125 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227AbYKTOoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:44:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 29/45] NFS: Add comment banners to some NFS functions [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:44:09 +0000
Message-ID: <20081120144408.10667.33180.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add comment banners to some NFS functions so that they can be modified by the
NFS fscache patches for further information.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/file.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index d319b49..141c0ab 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -409,6 +409,13 @@ static int nfs_write_end(struct file *file, struct address_space *mapping,
 	return copied;
 }
 
+/*
+ * Partially or wholly invalidate a page
+ * - Release the private state associated with a page if undergoing complete
+ *   page invalidation
+ * - Called if either PG_private or PG_private_2 is set on the page
+ * - Caller holds page lock
+ */
 static void nfs_invalidate_page(struct page *page, unsigned long offset)
 {
 	dfprintk(PAGECACHE, "NFS: invalidate_page(%p, %lu)\n", page, offset);
@@ -419,6 +426,12 @@ static void nfs_invalidate_page(struct page *page, unsigned long offset)
 	nfs_wb_page_cancel(page->mapping->host, page);
 }
 
+/*
+ * Attempt to release the private state associated with a page
+ * - Called if either PG_private or PG_private_2 is set on the page
+ * - Caller holds page lock
+ * - Return true (may release page) or false (may not)
+ */
 static int nfs_release_page(struct page *page, gfp_t gfp)
 {
 	dfprintk(PAGECACHE, "NFS: release_page(%p)\n", page);
@@ -427,6 +440,14 @@ static int nfs_release_page(struct page *page, gfp_t gfp)
 	return 0;
 }
 
+/*
+ * Attempt to clear the private state associated with a page when an error
+ * occurs that requires the cached contents of an inode to be written back or
+ * destroyed
+ * - Called if either PG_private or PG_private_2 is set on the page
+ * - Caller holds page lock
+ * - Return 0 if successful, -error otherwise
+ */
 static int nfs_launder_page(struct page *page)
 {
 	struct inode *inode = page->mapping->host;
@@ -451,6 +472,11 @@ const struct address_space_operations nfs_file_aops = {
 	.launder_page = nfs_launder_page,
 };
 
+/*
+ * Notification that a PTE pointing to an NFS page is about to be made
+ * writable, implying that someone is about to modify the page through a
+ * shared-writable mapping
+ */
 static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 {
 	struct file *filp = vma->vm_file;

