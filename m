Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab0BSRMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:12:44 -0500
Received: from kroah.org ([198.145.64.141]:57524 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab0BSRAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:35 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:41 2010
Message-Id: <20100219163240.999244166@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       David Howells <dhowells@redhat.com>
Subject: [37/93] NFS: Fix a bug in nfs_fscache_release_page()
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 2c1740098c708b465e87637b237feb2fd98f129a upstream.

Not having an fscache cookie is perfectly valid if the user didn't mount
with the fscache option.

This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=15234

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/fscache.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -354,12 +354,11 @@ void nfs_fscache_reset_inode_cookie(stru
  */
 int nfs_fscache_release_page(struct page *page, gfp_t gfp)
 {
-	struct nfs_inode *nfsi = NFS_I(page->mapping->host);
-	struct fscache_cookie *cookie = nfsi->fscache;
-
-	BUG_ON(!cookie);
-
 	if (PageFsCache(page)) {
+		struct nfs_inode *nfsi = NFS_I(page->mapping->host);
+		struct fscache_cookie *cookie = nfsi->fscache;
+
+		BUG_ON(!cookie);
 		dfprintk(FSCACHE, "NFS: fscache releasepage (0x%p/0x%p/0x%p)\n",
 			 cookie, page, nfsi);
 


