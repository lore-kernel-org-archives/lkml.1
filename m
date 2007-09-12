Return-Path: <linux-kernel-owner+w=401wt.eu-S1765081AbXILHqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765081AbXILHqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760093AbXILHns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:43:48 -0400
Received: from ozlabs.org ([203.10.76.45]:46427 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758309AbXILHnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:43:46 -0400
To: <linuxppc-dev@ozlabs.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-Id: <163f3c08c2c47d47103f234d6caa517ed9a44036.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 08/15] Use spufs_coredump_num_notes everywhere, and don't NULL terminate
Date: Wed, 12 Sep 2007 17:43:45 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The spufs_coredump_read array is NULL terminated, and we also store the size.
We only need one or the other, and storing the size should save a teensy bit
of memory vs NULL terminating, so do that.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/cell/spufs/coredump.c |    2 +-
 arch/powerpc/platforms/cell/spufs/file.c     |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index 52d6219..8348d21 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -72,7 +72,7 @@ static int spufs_ctx_note_size(struct spu_context *ctx, int dfd)
 	char *name;
 	char fullname[80];
 
-	for (i = 0; spufs_coredump_read[i].name; i++) {
+	for (i = 0; i < spufs_coredump_num_notes; i++) {
 		name = spufs_coredump_read[i].name;
 		sz = spufs_coredump_read[i].size;
 
diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index 85edbec..220c7fe 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -2250,7 +2250,6 @@ struct spufs_coredump_reader spufs_coredump_read[] = {
 	{ "proxydma_info", __spufs_proxydma_info_read,
 			   NULL, sizeof(struct spu_proxydma_info)},
 	{ "object-id", NULL, __spufs_object_id_get, 19 },
-	{ },
 };
-int spufs_coredump_num_notes = ARRAY_SIZE(spufs_coredump_read) - 1;
 
+int spufs_coredump_num_notes = ARRAY_SIZE(spufs_coredump_read);
-- 
1.5.1.3.g7a33b

