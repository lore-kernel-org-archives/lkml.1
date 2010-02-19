Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0BSRNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:13:50 -0500
Received: from kroah.org ([198.145.64.141]:57480 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab0BSRAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:31 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:39 2010
Message-Id: <20100219163239.547606475@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [32/93] NFS: Try to commit unstable writes in nfs_release_page()
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 82be934a59ff891cac598727e5a862ba2b9d1fac upstream.

If someone calls nfs_release_page(), we presumably already know that the
page is clean, however it may be holding an unstable write.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -486,6 +486,8 @@ static int nfs_release_page(struct page
 {
 	dfprintk(PAGECACHE, "NFS: release_page(%p)\n", page);
 
+	if (gfp & __GFP_WAIT)
+		nfs_wb_page(page->mapping->host, page);
 	/* If PagePrivate() is set, then the page is not freeable */
 	if (PagePrivate(page))
 		return 0;


