Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbZGTO1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbZGTO1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 10:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZGTO1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 10:27:40 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:62983 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZGTO1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 10:27:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=r3S3ZdDxYe5H9uUqanoHC5MW0pof64RBWUFbAAi7H1w7raP1YlBGHlj4uZIrWnUEgm
         umE1ORGHbA0Gr6ZMsYjir4DMzZcayR7XUwiNnlkOg10HmdLutSNHL5BSrbAVAzBCFoKV
         Jus21HUnpcMXX+cJjGdThmgi5zChJZYcV7EfY=
From: tom.leiming@gmail.com
To: linux@arm.linux.org.uk, rmk@arm.linux.org.uk
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v2 4/4] ARM:dma-mapping:fix dma_map_sg and dma_unmap_sg
Date: Mon, 20 Jul 2009 22:25:54 +0800
Message-Id: <1248099954-6666-5-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1248099954-6666-4-git-send-email-tom.leiming@gmail.com>
References: <1248099954-6666-1-git-send-email-tom.leiming@gmail.com>
 <1248099954-6666-2-git-send-email-tom.leiming@gmail.com>
 <1248099954-6666-3-git-send-email-tom.leiming@gmail.com>
 <1248099954-6666-4-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch removes unnecessary calling of debug_dma_map_page
and debug_dma_unmap_page in dma_map_sg and dma_unmap_sg.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 arch/arm/mm/dma-mapping.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 64e5d82..584018c 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -610,7 +610,7 @@ int __dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	int i, j;
 
 	for_each_sg(sg, s, nents, i) {
-		s->dma_address = dma_map_page(dev, sg_page(s), s->offset,
+		s->dma_address = __dma_map_page(dev, sg_page(s), s->offset,
 						s->length, dir);
 		if (dma_mapping_error(dev, s->dma_address))
 			goto bad_mapping;
@@ -619,7 +619,7 @@ int __dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 
  bad_mapping:
 	for_each_sg(sg, s, i, j)
-		dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
+		__dma_unmap_single(dev, sg_dma_address(s), sg_dma_len(s), dir);
 	return 0;
 }
 EXPORT_SYMBOL(__dma_map_sg);
@@ -641,7 +641,7 @@ void __dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
 	int i;
 
 	for_each_sg(sg, s, nents, i)
-		dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
+		__dma_unmap_single(dev, sg_dma_address(s), sg_dma_len(s), dir);
 }
 EXPORT_SYMBOL(__dma_unmap_sg);
 
-- 
1.6.0.GIT

