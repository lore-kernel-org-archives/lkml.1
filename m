Return-Path: <linux-kernel-owner+w=401wt.eu-S934343AbZHENXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343AbZHENXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934325AbZHENXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:23:52 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51800 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934324AbZHENXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:23:51 -0400
Date: Wed, 5 Aug 2009 15:23:48 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/4] drivers/serial/atmel_serial.c: Use UPIO_MEM rather than
 SERIAL_IO_MEM
Message-ID: <Pine.LNX.4.64.0908051523080.20453@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

As in the commit 9b4a1617772d6d5ab5eeda0cd95302fae119e359, use UPIO_MEM
rather than SERIAL_IO_MEM.  Both have the same value.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@has_sc@
@@

#include <linux/serial_core.h>

@depends on has_sc@
@@

- SERIAL_IO_MEM
+ UPIO_MEM
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/serial/atmel_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1200,7 +1200,7 @@ static int atmel_verify_port(struct uart
 		ret = -EINVAL;
 	if (port->irq != ser->irq)
 		ret = -EINVAL;
-	if (ser->io_type != SERIAL_IO_MEM)
+	if (ser->io_type != UPIO_MEM)
 		ret = -EINVAL;
 	if (port->uartclk / 16 != ser->baud_base)
 		ret = -EINVAL;
