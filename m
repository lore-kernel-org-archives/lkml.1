Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbZBFDNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbZBFDNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 22:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbZBFDM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 22:12:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56481 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbZBFDMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 22:12:55 -0500
Message-ID: <498BAAB1.5030104@cn.fujitsu.com>
Date: Fri, 06 Feb 2009 11:12:49 +0800
From: Wei Yongjun <yjwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: fs/jffs2/malloc.c: kmem_cache_alloc/memset -> kmem_cache_zalloc
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used kmem_cache_zalloc instead of kmem_cache_alloc/memset.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 fs/jffs2/malloc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/jffs2/malloc.c b/fs/jffs2/malloc.c
index f921125..9eff2bd 100644
--- a/fs/jffs2/malloc.c
+++ b/fs/jffs2/malloc.c
@@ -284,10 +284,9 @@ void jffs2_free_inode_cache(struct jffs2_inode_cache *x)
 struct jffs2_xattr_datum *jffs2_alloc_xattr_datum(void)
 {
 	struct jffs2_xattr_datum *xd;
-	xd = kmem_cache_alloc(xattr_datum_cache, GFP_KERNEL);
+	xd = kmem_cache_zalloc(xattr_datum_cache, GFP_KERNEL);
 	dbg_memalloc("%p\n", xd);
 
-	memset(xd, 0, sizeof(struct jffs2_xattr_datum));
 	xd->class = RAWNODE_CLASS_XATTR_DATUM;
 	xd->node = (void *)xd;
 	INIT_LIST_HEAD(&xd->xindex);
@@ -303,10 +302,9 @@ void jffs2_free_xattr_datum(struct jffs2_xattr_datum *xd)
 struct jffs2_xattr_ref *jffs2_alloc_xattr_ref(void)
 {
 	struct jffs2_xattr_ref *ref;
-	ref = kmem_cache_alloc(xattr_ref_cache, GFP_KERNEL);
+	ref = kmem_cache_zalloc(xattr_ref_cache, GFP_KERNEL);
 	dbg_memalloc("%p\n", ref);
 
-	memset(ref, 0, sizeof(struct jffs2_xattr_ref));
 	ref->class = RAWNODE_CLASS_XATTR_REF;
 	ref->node = (void *)ref;
 	return ref;
-- 
1.5.3.8



