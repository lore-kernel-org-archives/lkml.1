Return-Path: <linux-kernel-owner+w=401wt.eu-S1751543AbZL0V1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbZL0V1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZL0V1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:27:50 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:47760 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbZL0V1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:27:46 -0500
Date: Sun, 27 Dec 2009 22:27:44 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Urs Thuermann <urs.thuermann@volkswagen.de>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/5] drivers/net/can: Correct NULL test
Message-ID: <Pine.LNX.4.64.0912272227290.20548@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Test the just-allocated value for NULL rather than some other value.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,y;
statement S;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
(
if ((x) == NULL) S
|
if (
-   y
+   x
       == NULL)
 S
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/can/mcp251x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/net/can/mcp251x.c b/drivers/net/can/mcp251x.c
--- a/drivers/net/can/mcp251x.c
+++ b/drivers/net/can/mcp251x.c
@@ -990,7 +990,7 @@ static int __devinit mcp251x_can_probe(s
 			goto error_tx_buf;
 		}
 		priv->spi_rx_buf = kmalloc(SPI_TRANSFER_BUF_LEN, GFP_KERNEL);
-		if (!priv->spi_tx_buf) {
+		if (!priv->spi_rx_buf) {
 			ret = -ENOMEM;
 			goto error_rx_buf;
 		}
