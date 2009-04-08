Return-Path: <linux-kernel-owner+w=401wt.eu-S1764304AbZDHLY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764304AbZDHLY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759262AbZDHLWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:22:43 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49424 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762561AbZDHLWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:22:41 -0400
X-Sasl-enc: aP9R3npvbr43VnKcN0eB1FyRuaPHpcmgdCc5xy4wzUYU 1239189760
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 07/56] coda: Remove void casts
Date: Wed,  8 Apr 2009 12:21:39 +0100
Message-Id: <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 fs/coda/inode.c  |    2 +-
 fs/coda/upcall.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 830f51a..a0407b3 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -43,7 +43,7 @@ static struct kmem_cache * coda_inode_cachep;
 static struct inode *coda_alloc_inode(struct super_block *sb)
 {
 	struct coda_inode_info *ei;
-	ei = (struct coda_inode_info *)kmem_cache_alloc(coda_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(coda_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	memset(&ei->c_fid, 0, sizeof(struct CodaFid));
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index c274d94..0f2e171 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -59,7 +59,7 @@ static void *alloc_upcall(int opcode, int size)
 
 #define UPARG(op)\
 do {\
-	inp = (union inputArgs *)alloc_upcall(op, insize); \
+	inp = alloc_upcall(op, insize); \
         if (IS_ERR(inp)) { return PTR_ERR(inp); }\
         outp = (union outputArgs *)(inp); \
         outsize = insize; \
-- 
1.5.4.3

