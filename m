Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZLMPrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZLMPrK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 10:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZLMPrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 10:47:09 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60531 "HELO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752025AbZLMPrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 10:47:07 -0500
Date: Sun, 13 Dec 2009 16:47:04 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Petko Manolov <petkan@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/net/usb: Correct code taking the size of a pointer
Message-ID: <Pine.LNX.4.64.0912131646400.27767@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

sizeof(dev->dev_addr) is the size of a pointer.  A few lines above, the
size of this field is obtained using netdev->addr_len for a call to memcpy,
so do the same here.

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
 drivers/net/usb/rtl8150.c           |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index b091e20..f14d225 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -324,7 +324,7 @@ static int rtl8150_set_mac_address(struct net_device *netdev, void *p)
 		dbg("%02X:", netdev->dev_addr[i]);
 	dbg("%02X\n", netdev->dev_addr[i]);
 	/* Set the IDR registers. */
-	set_registers(dev, IDR, sizeof(netdev->dev_addr), netdev->dev_addr);
+	set_registers(dev, IDR, netdev->addr_len, netdev->dev_addr);
 #ifdef EEPROM_WRITE
 	{
 	u8 cr;
