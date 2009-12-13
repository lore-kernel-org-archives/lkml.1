Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZLMLnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZLMLnI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 06:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZLMLnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 06:43:00 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:51531 "HELO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752642AbZLMLm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 06:42:59 -0500
Date: Sun, 13 Dec 2009 12:42:56 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: perex@perex.cz, Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/9] sound/isa/gus: Correct code taking the size of a pointer
Message-ID: <Pine.LNX.4.64.0912131242420.24267@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

sizeof(share_id) is just the size of the pointer.  On the other hand,
block->share_id is an array, so its size seems more appropriate.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
expression f;
type T;
@@

*f(...,(T)x,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/isa/gus/gus_mem.c             |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/isa/gus/gus_mem.c b/sound/isa/gus/gus_mem.c
index 661205c..af888a0 100644
--- a/sound/isa/gus/gus_mem.c
+++ b/sound/isa/gus/gus_mem.c
@@ -127,7 +127,8 @@ static struct snd_gf1_mem_block *snd_gf1_mem_share(struct snd_gf1_mem * alloc,
 	    !share_id[2] && !share_id[3])
 		return NULL;
 	for (block = alloc->first; block; block = block->next)
-		if (!memcmp(share_id, block->share_id, sizeof(share_id)))
+		if (!memcmp(share_id, block->share_id,
+				sizeof(block->share_id)))
 			return block;
 	return NULL;
 }
