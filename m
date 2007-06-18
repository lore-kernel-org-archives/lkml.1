Return-Path: <linux-kernel-owner+w=401wt.eu-S932348AbXFRPN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbXFRPN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932235AbXFRPMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:12:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216AbXFRPMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:12:36 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Nate Diller <nate.diller@gmail.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] [GFS2] use zero_user_page
Date: Mon, 18 Jun 2007 15:54:29 +0100
Message-Id: <1182178482182-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11821784801162-git-send-email-swhiteho@redhat.com>
References: y
 <11821784703600-git-send-email-swhiteho@redhat.com>
 <1182178478593-git-send-email-swhiteho@redhat.com>
 <11821784801162-git-send-email-swhiteho@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.1.2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nate Diller <nate.diller@gmail.com>

This is a multi-part message in MIME format.
--------------1.5.1.2
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


Use zero_user_page() instead of open-coding it.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/gfs2/bmap.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)
--------------1.5.1.2
Content-Type: text/x-patch; name="5f8edce5584b74bbe25c240ffe7a55934e8cb9de.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="5f8edce5584b74bbe25c240ffe7a55934e8cb9de.diff"

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index c53a5d2..1c40c4b 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -885,7 +885,6 @@ static int gfs2_block_truncate_page(struct address_space *mapping)
 	unsigned blocksize, iblock, length, pos;
 	struct buffer_head *bh;
 	struct page *page;
-	void *kaddr;
 	int err;
 
 	page = grab_cache_page(mapping, index);
@@ -933,10 +932,7 @@ static int gfs2_block_truncate_page(struct address_space *mapping)
 	if (sdp->sd_args.ar_data == GFS2_DATA_ORDERED || gfs2_is_jdata(ip))
 		gfs2_trans_add_bh(ip->i_gl, bh, 0);
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, length, KM_USER0);
 
 unlock:
 	unlock_page(page);

--------------1.5.1.2--


