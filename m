Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbZLANiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbZLANiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 08:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZLANix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 08:38:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbZLANix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 08:38:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org, akpm@linux-foundation.com
cc: dhowells@redhat.com, Kyle McMartin <kyle@redhat.com>,
       Xiaotian Feng <dfeng@redhat.com>,
       Stefan Lippers-Hollmann <s.l-h@gmx.de>, linux-kernel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net, ericvh@gmail.com
Subject: [PATCH] 9p: fix build breakage introduced by 201a15428bd54f83eccec8b7c64a04b8f9431204
Date: Tue, 01 Dec 2009 13:38:45 +0000
Message-ID: <25412.1259674725@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While building 2.6.32-rc8-git2 for Fedora I noticed the following thinko in
commit 201a15428bd54f83eccec8b7c64a04b8f9431204:

fs/9p/cache.c: In function '__v9fs_fscache_release_page':
fs/9p/cache.c:346: error: 'vnode' undeclared (first use in this function)
fs/9p/cache.c:346: error: (Each undeclared identifier is reported only once
fs/9p/cache.c:346: error: for each function it appears in.)
make[2]: *** [fs/9p/cache.o] Error 1

Fix the 9P filesystem to correctly construct the argument to
fscache_maybe_release_page().

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com> [from identical patch]
Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de> [from identical patch]
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/9p/cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


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
