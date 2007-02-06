Return-Path: <linux-kernel-owner+w=401wt.eu-S964845AbXBFQJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845AbXBFQJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964934AbXBFQJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:09:14 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:59552 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964919AbXBFQJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:09:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=eBo2poFGN7OIEp9tyIh6O8S/RAZCLpw1C/+qSj+K4lpLtK4qPji7x+HGkXmLtaJHrE3elfwotn7d+03E6H2kiZMdnHLo9HzyUkW90mu2UfcQk1UMffETjV16yyuELRiXMuXfthDOTDtDh6Ejr3a2HEnPtjwMDPLDf3AXLPCudbE=
Date: Tue, 6 Feb 2007 18:08:50 +0200
To: reiserfs-dev@namesys.com
Cc: linux-kernel@vger.kernel.org, reiserfs-list@namesys.com
Subject: [PATCH 2.6.20] reiserfs: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206160850.GN8991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206160204.GA8991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/fs/reiserfs/do_balan.c b/fs/reiserfs/do_balan.c
index fba304e..f85c5cf 100644
--- a/fs/reiserfs/do_balan.c
+++ b/fs/reiserfs/do_balan.c
@@ -19,6 +19,7 @@
 #include <linux/time.h>
 #include <linux/reiserfs_fs.h>
 #include <linux/buffer_head.h>
+#include <linux/kernel.h>
 
 #ifdef CONFIG_REISERFS_CHECK
 
@@ -1756,7 +1757,7 @@ static void store_thrown(struct tree_balance *tb, struct buffer_head *bh)
 	if (buffer_dirty(bh))
 		reiserfs_warning(tb->tb_sb,
 				 "store_thrown deals with dirty buffer");
-	for (i = 0; i < sizeof(tb->thrown) / sizeof(tb->thrown[0]); i++)
+	for (i = 0; i < ARRAY_SIZE(tb->thrown); i++)
 		if (!tb->thrown[i]) {
 			tb->thrown[i] = bh;
 			get_bh(bh);	/* free_thrown puts this */
@@ -1769,7 +1770,7 @@ static void free_thrown(struct tree_balance *tb)
 {
 	int i;
 	b_blocknr_t blocknr;
-	for (i = 0; i < sizeof(tb->thrown) / sizeof(tb->thrown[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(tb->thrown); i++) {
 		if (tb->thrown[i]) {
 			blocknr = tb->thrown[i]->b_blocknr;
 			if (buffer_dirty(tb->thrown[i]))


-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
