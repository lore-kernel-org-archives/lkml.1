Return-Path: <linux-kernel-owner+w=401wt.eu-S1764083AbXG2O4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764083AbXG2O4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 10:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763847AbXG2O4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:56:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47746 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763603AbXG2O4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:56:12 -0400
Date: Sun, 29 Jul 2007 16:55:49 +0200
From: Adrian Bunk <bunk@stusta.de>
To: perex@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] sound/synth/util_mem.c: remove pointless check
Message-ID: <20070729145549.GB16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that if anyone would call this function 
with "prev == NULL", he would still get an Oops a few lines below.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

--- linux-2.6.22-rc6-mm1/sound/synth/util_mem.c.old	2007-07-24 19:37:50.000000000 +0200
+++ linux-2.6.22-rc6-mm1/sound/synth/util_mem.c	2007-07-24 19:38:37.000000000 +0200
@@ -112,15 +112,15 @@ __snd_util_memblk_new(struct snd_util_me
 	struct snd_util_memblk *blk;
 
 	blk = kmalloc(sizeof(struct snd_util_memblk) + hdr->block_extra_size,
 		      GFP_KERNEL);
 	if (blk == NULL)
 		return NULL;
 
-	if (! prev || prev == &hdr->block)
+	if (prev == &hdr->block)
 		blk->offset = 0;
 	else {
 		struct snd_util_memblk *p = get_memblk(prev);
 		blk->offset = p->offset + p->size;
 	}
 	blk->size = units;
 	list_add(&blk->list, prev);

