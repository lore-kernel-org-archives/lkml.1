Return-Path: <linux-kernel-owner+w=401wt.eu-S933560AbXGaSYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560AbXGaSYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbXGaSYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:24:08 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1675 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764318AbXGaSYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:24:06 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 43] fs/reiser4/ktxnmgrd.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:24:05 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-dev@namesys.com, reiserfs-devel@vger.kernel.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312024.06110.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/reiser4/ktxnmgrd.c | 5314 -> 5277 (-37 bytes)
 fs/reiser4/ktxnmgrd.o | 131624 -> 131496 (-128 bytes)

 fs/reiser4/ktxnmgrd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/fs/reiser4/ktxnmgrd.c	2007-07-26 13:07:46.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/fs/reiser4/ktxnmgrd.c	2007-07-31 14:58:09.000000000 +0200
@@ -130,13 +130,12 @@ int reiser4_init_ktxnmgrd(struct super_b

 	assert("zam-1014", mgr->daemon == NULL);

-	ctx = kmalloc(sizeof(ktxnmgrd_context), reiser4_ctx_gfp_mask_get());
-	if (ctx == NULL)
+	ctx = kzalloc(sizeof(ktxnmgrd_context), reiser4_ctx_gfp_mask_get());
+	if (!ctx)
 		return RETERR(-ENOMEM);

 	assert("nikita-2442", ctx != NULL);

-	memset(ctx, 0, sizeof *ctx);
 	init_waitqueue_head(&ctx->wait);

 	/*kcond_init(&ctx->startup);*/
