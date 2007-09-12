Return-Path: <linux-kernel-owner+w=401wt.eu-S1765296AbXILHrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765296AbXILHrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760870AbXILHnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:43:49 -0400
Received: from ozlabs.org ([203.10.76.45]:46488 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759344AbXILHns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:43:48 -0400
To: <linuxppc-dev@ozlabs.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-Id: <6566ec53f4b03dbf089291a7335f5370c6a88088.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 10/15] Add contents of npc file to SPU coredumps
Date: Wed, 12 Sep 2007 17:43:47 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/cell/spufs/file.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index d19220f..52f020a 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -1606,12 +1606,17 @@ static void spufs_npc_set(void *data, u64 val)
 	spu_release(ctx);
 }
 
+static u64 __spufs_npc_get(struct spu_context *ctx)
+{
+	return ctx->ops->npc_read(ctx);
+}
+
 static u64 spufs_npc_get(void *data)
 {
 	struct spu_context *ctx = data;
 	u64 ret;
 	spu_acquire(ctx);
-	ret = ctx->ops->npc_read(ctx);
+	ret = __spufs_npc_get(ctx);
 	spu_release(ctx);
 	return ret;
 }
@@ -2242,6 +2247,7 @@ struct spufs_coredump_reader spufs_coredump_read[] = {
 	{ "proxydma_info", __spufs_proxydma_info_read,
 			   NULL, sizeof(struct spu_proxydma_info)},
 	{ "object-id", NULL, __spufs_object_id_get, 19 },
+	{ "npc", NULL, __spufs_npc_get, 19 },
 };
 
 int spufs_coredump_num_notes = ARRAY_SIZE(spufs_coredump_read);
-- 
1.5.1.3.g7a33b

