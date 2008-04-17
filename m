Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYDQVOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYDQVOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 17:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYDQVON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 17:14:13 -0400
Received: from styx.suse.cz ([82.119.242.94]:60266 "EHLO elijah.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753828AbYDQVOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 17:14:12 -0400
Subject: [PATCH] fix brd allocation flags
From: Petr Tesarik <ptesarik@suse.cz>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: SuSE CR
Date: Thu, 17 Apr 2008 23:14:07 +0200
Message-Id: <1208466847.8398.4.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

while looking at the implementation of the Ram backed block device
driver, I stumbled across a write-only local variable, which makes
little sense, so I assume it should actually work like this:

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 8536480..7bd7663 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -108,7 +108,7 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 #ifndef CONFIG_BLK_DEV_XIP
 	gfp_flags |= __GFP_HIGHMEM;
 #endif
-	page = alloc_page(GFP_NOIO | __GFP_HIGHMEM | __GFP_ZERO);
+	page = alloc_page(gfp_flags);
 	if (!page)
 		return NULL;
 

