Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZLSHaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZLSHaS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 02:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZLSHaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 02:30:16 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:46920 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbZLSHaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 02:30:13 -0500
Date: Sat, 19 Dec 2009 08:30:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] drivers/block: drop unnecesary memset
Message-ID: <Pine.LNX.4.64.0912190829470.30546@ask.diku.dk>
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
 drivers/block/cciss.c |    1 -
 1 file changed, 1 deletion(-)

diff -u -p a/drivers/block/cciss.c b/drivers/block/cciss.c
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4379,7 +4379,6 @@ static void cciss_shutdown(struct pci_de
 		return;
 	}
 	/* write all data in the battery backed cache to disk */
-	memset(flush_buf, 0, 4);
 	return_code = sendcmd_withirq(CCISS_CACHE_FLUSH, h->ctlr, flush_buf,
 		4, 0, CTLR_LUNID, TYPE_CMD);
 	kfree(flush_buf);
