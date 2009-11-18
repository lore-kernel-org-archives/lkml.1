Return-Path: <linux-kernel-owner+w=401wt.eu-S932245AbZKRSWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbZKRSWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932176AbZKRSWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:22:03 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:45470 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161AbZKRSWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:22:01 -0500
Date: Wed, 18 Nov 2009 19:22:05 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Samuel Ortiz <samuel@sortiz.org>, netdev@vger.kernel.org, arnd@arndb.de,
       joe@perches.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/16] drivers/net/irda: remove exceptional & on function name
Message-ID: <Pine.LNX.4.64.0911181921450.20943@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In this file, function names are otherwise used as pointers without &.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier f;
@@

f(...) { ... }

@@
identifier r.f;
@@

- &f
+ f
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/irda/irda-usb.c         |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/irda/irda-usb.c b/drivers/net/irda/irda-usb.c
index 5e462b9..e591b36 100644
--- a/drivers/net/irda/irda-usb.c
+++ b/drivers/net/irda/irda-usb.c
@@ -852,7 +852,7 @@ static void irda_usb_receive(struct urb *urb)
 		 * hot unplug of the dongle...
 		 * Lowest effective timer is 10ms...
 		 * Jean II */
-		self->rx_defer_timer.function = &irda_usb_rx_defer_expired;
+		self->rx_defer_timer.function = irda_usb_rx_defer_expired;
 		self->rx_defer_timer.data = (unsigned long) urb;
 		mod_timer(&self->rx_defer_timer, jiffies + (10 * HZ / 1000));
 		return;
