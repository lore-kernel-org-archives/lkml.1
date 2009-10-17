Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbZJQGms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbZJQGms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 02:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZJQGmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 02:42:47 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39217 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbZJQGmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 02:42:46 -0400
Date: Sat, 17 Oct 2009 08:42:49 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 13/14] arch/arm/plat-s3c24xx: Move dereference after NULL
 test
Message-ID: <Pine.LNX.4.64.0910170842310.9213@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test on buf is needed, then the dereference should be after the
NULL test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/plat-s3c24xx/dma.c         |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-s3c24xx/dma.c b/arch/arm/plat-s3c24xx/dma.c
index 196b191..f046f8c 100644
--- a/arch/arm/plat-s3c24xx/dma.c
+++ b/arch/arm/plat-s3c24xx/dma.c
@@ -208,14 +208,14 @@ s3c2410_dma_loadbuffer(struct s3c2410_dma_chan *chan,
 {
 	unsigned long reload;
 
-	pr_debug("s3c2410_chan_loadbuffer: loading buff %p (0x%08lx,0x%06x)\n",
-		 buf, (unsigned long)buf->data, buf->size);
-
 	if (buf == NULL) {
 		dmawarn("buffer is NULL\n");
 		return -EINVAL;
 	}
 
+	pr_debug("s3c2410_chan_loadbuffer: loading buff %p (0x%08lx,0x%06x)\n",
+		 buf, (unsigned long)buf->data, buf->size);
+
 	/* check the state of the channel before we do anything */
 
 	if (chan->load_state == S3C2410_DMALOAD_1LOADED) {
