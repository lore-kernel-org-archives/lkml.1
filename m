Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638Ab0AEUPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab0AEUPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109Ab0AEUP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:15:27 -0500
Received: from kroah.org ([198.145.64.141]:49944 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434Ab0AEUGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:04 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:02:59 2010
Message-Id: <20100105200259.732400414@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Julia Lawall <julia@diku.dk>, "David S. Miller" <davem@davemloft.net>
Subject: [06/39] drivers/net/usb: Correct code taking the size of a pointer
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Julia Lawall <julia@diku.dk>

commit 6057912d7baad31be9819518674ffad349a065b1 upstream.

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/rtl8150.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -324,7 +324,7 @@ static int rtl8150_set_mac_address(struc
 		dbg("%02X:", netdev->dev_addr[i]);
 	dbg("%02X\n", netdev->dev_addr[i]);
 	/* Set the IDR registers. */
-	set_registers(dev, IDR, sizeof(netdev->dev_addr), netdev->dev_addr);
+	set_registers(dev, IDR, netdev->addr_len, netdev->dev_addr);
 #ifdef EEPROM_WRITE
 	{
 	u8 cr;


