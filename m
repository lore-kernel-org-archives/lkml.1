Return-Path: <linux-kernel-owner+w=401wt.eu-S1765956AbYBTQMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765956AbYBTQMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764775AbYBTQIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:08:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763848AbYBTQIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:08:47 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/37] NFS: Add comment banners to some NFS functions
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:07:51 +0000
Message-ID: <20080220160751.4715.54315.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
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
index ef57a5a..26a073b 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -354,6 +354,13 @@ static int nfs_write_end(struct file *file, struct address_space *mapping,
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
 	if (offset != 0)
@@ -362,12 +369,26 @@ static void nfs_invalidate_page(struct page *page, unsigned long offset)
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
 	/* If PagePrivate() is set, then the page is not freeable */
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
 	return nfs_wb_page(page->mapping->host, page);
@@ -389,6 +410,11 @@ const struct address_space_operations nfs_file_aops = {
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

