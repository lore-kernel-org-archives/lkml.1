Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbYDYK5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbYDYK5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 06:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYDYK5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 06:57:44 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:44076 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbYDYK5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:57:43 -0400
X-IronPort-AV: E=Sophos;i="4.25,707,1199682000"; 
   d="scan'208";a="52532713"
From: Bryan Wu <cooloney@kernel.org>
To: mpm@selenic.com, lethal@linux-sh.org, linux-kernel@vger.kernel.org
Cc: Yi Li <yi.li@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] [mm/slob] fix bug - when slob allocates "struct kmem_cache", it does not force alignment.
Date: Fri, 25 Apr 2008 18:57:21 +0800
Message-Id: <1209121041-30524-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

This may trigger misaligned memory access exception.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 mm/slob.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index e2c3c0e..6038cba 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -533,7 +533,8 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 {
 	struct kmem_cache *c;
 
-	c = slob_alloc(sizeof(struct kmem_cache), flags, 0, -1);
+	c = slob_alloc(sizeof(struct kmem_cache),
+		flags, ARCH_KMALLOC_MINALIGN, -1);
 
 	if (c) {
 		c->name = name;
-- 
1.5.5
