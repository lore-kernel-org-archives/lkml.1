Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbZLSHaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbZLSHaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 02:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZLSHad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 02:30:33 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:50396 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbZLSHac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 02:30:32 -0500
Date: Sat, 19 Dec 2009 08:30:30 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Dan Williams <dan.j.williams@intel.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] drivers/dma: drop unnecesary memset
Message-ID: <Pine.LNX.4.64.0912190830110.30546@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

memset of 0 is not needed after kzalloc

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x;
statement S;
@@

x = kzalloc(...);
if (x == NULL) S
... when != x
-memset(x,0,...);// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/dma/dw_dmac.c |    2 --
 1 file changed, 2 deletions(-)

diff -u -p a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1270,8 +1270,6 @@ static int __init dw_probe(struct platfo
 		goto err_kfree;
 	}
 
-	memset(dw, 0, sizeof *dw);
-
 	dw->regs = ioremap(io->start, DW_REGLEN);
 	if (!dw->regs) {
 		err = -ENOMEM;
