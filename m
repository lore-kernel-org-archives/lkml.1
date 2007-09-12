Return-Path: <linux-kernel-owner+w=401wt.eu-S1764449AbXILHob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764449AbXILHob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbXILHnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:43:43 -0400
Received: from ozlabs.org ([203.10.76.45]:46314 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbXILHnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:43:42 -0400
To: <linuxppc-dev@ozlabs.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-Id: <34d2658a9aa616e0971bfc3ea4c747772fd60cb1.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 03/15] Call spu_acquire_saved() before calculating the SPU note sizes
Date: Wed, 12 Sep 2007 17:43:41 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It makes sense to stop the SPU processes as soon as possible. Also if we
dont acquire_saved() I think there's a possibility that the value in
csa.priv2.spu_lslr_RW won't be accurate.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/cell/spufs/coredump.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index 6663669..21283f6 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -135,7 +135,9 @@ static int spufs_arch_notes_size(void)
 
 	fd = 0;
 	while ((ctx = coredump_next_context(&fd)) != NULL) {
+		spu_acquire_saved(ctx);
 		rc = spufs_ctx_note_size(ctx, fd);
+		spu_release_saved(ctx);
 		if (rc < 0)
 			break;
 
-- 
1.5.1.3.g7a33b

