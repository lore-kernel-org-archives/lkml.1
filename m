Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbZLITW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbZLITW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbZLITWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:22:22 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:52683 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbZLITWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:22:21 -0500
Date: Wed, 9 Dec 2009 20:22:26 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Sascha Hauer <kernel@pengutronix.de>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/12] arch/arm: Correct size given to memset
Message-ID: <Pine.LNX.4.64.0912092022040.1870@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Memset should be given the size of the structure, not the size of the pointer.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *x;
expression E;
@@

memset(x, E, sizeof(
+ *
 x))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/plat-mxc/dma-mx1-mx2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/arch/arm/plat-mxc/dma-mx1-mx2.c b/arch/arm/plat-mxc/dma-mx1-mx2.c
--- a/arch/arm/plat-mxc/dma-mx1-mx2.c
+++ b/arch/arm/plat-mxc/dma-mx1-mx2.c
@@ -694,7 +694,7 @@ int imx_dma_request(int channel, const c
 		local_irq_restore(flags);
 		return -EBUSY;
 	}
-	memset(imxdma, 0, sizeof(imxdma));
+	memset(imxdma, 0, sizeof(*imxdma));
 	imxdma->name = name;
 	local_irq_restore(flags); /* request_irq() can block */
 
