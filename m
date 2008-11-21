Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbYKUM4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbYKUM4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 07:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYKUM40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 07:56:26 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:54982 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970AbYKUM4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 07:56:25 -0500
Subject: [PATCH] Update the kmem_cache_create documentation regarding the name
	parameter
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Fri, 21 Nov 2008 12:56:22 +0000
Message-ID: <20081121125622.11468.97451.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.286.g8983
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Nov 2008 12:56:23.0113 (UTC) FILETIME=[8E6A7390:01C94BD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmem_cache implementations like slub are allowed to merge multiple
caches but only the initial name is preserved. Therefore,
kmem_cache_name() is not guaranteed to return the same pointer passed to
the former function. This patch updates the documentation to make this
clearer.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 4887f1b..8924a03 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2124,6 +2124,8 @@ static int __init_refok setup_cpu_cache(struct kmem_cache *cachep)
  *
  * @name must be valid until the cache is destroyed. This implies that
  * the module calling this has to destroy the cache before getting unloaded.
+ * Note that kmem_cache_name() is not guaranteed to return the same pointer,
+ * therefore applications must manage it themselves.
  *
  * The flags are
  *

