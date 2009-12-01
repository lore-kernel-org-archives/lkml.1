Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZLAG4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZLAG4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZLAG4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:56:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbZLAG4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:56:21 -0500
Date: Tue, 1 Dec 2009 01:56:26 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, ericvh@gmail.com
Subject: [PATCH] 9p: fix build breakage introduced by
	201a15428bd54f83eccec8b7c64a04b8f9431204
Message-ID: <20091201065626.GN28962@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

While building 2.6.32-rc8-git2 for Fedora I noticed the following thinko in
201a15428bd54f83eccec8b7c64a04b8f9431204. This fix looks to be correct?

fs/9p/cache.c: In function '__v9fs_fscache_release_page':
fs/9p/cache.c:346: error: 'vnode' undeclared (first use in this function)
fs/9p/cache.c:346: error: (Each undeclared identifier is reported only once
fs/9p/cache.c:346: error: for each function it appears in.)
make[2]: *** [fs/9p/cache.o] Error 1

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---
diff --git a/fs/9p/cache.c b/fs/9p/cache.c
index bcc5357..e777961 100644
--- a/fs/9p/cache.c
+++ b/fs/9p/cache.c
@@ -343,7 +343,7 @@ int __v9fs_fscache_release_page(struct page *page, gfp_t gfp)
 
 	BUG_ON(!vcookie->fscache);
 
-	return fscache_maybe_release_page(vnode->cache, page, gfp);
+	return fscache_maybe_release_page(vcookie->fscache, page, gfp);
 }
 
 void __v9fs_fscache_invalidate_page(struct page *page)
