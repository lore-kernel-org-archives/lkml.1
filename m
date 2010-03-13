Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934806Ab0CMBYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:24:06 -0500
Received: from kroah.org ([198.145.64.141]:60747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934927Ab0CMAUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:16 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:10 2010
Message-Id: <20100313001510.253632683@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Luotao Fu <l.fu@pengutronix.de>, Jean Delvare <khali@linux-fr.org>
Subject: [patch 058/123] USB: fix I2C API usage in ohci-pnx4008.
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Luotao Fu <l.fu@pengutronix.de>

commit 8740cc7d0c532e098cc428251c08befd14f087d8 upstream.

i2c_board_info doesn't contain a member called name. i2c_register_client
call does not exist.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ohci-pnx4008.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/ohci-pnx4008.c
+++ b/drivers/usb/host/ohci-pnx4008.c
@@ -327,7 +327,7 @@ static int __devinit usb_hcd_pnx4008_pro
 	}
 	i2c_adap = i2c_get_adapter(2);
 	memset(&i2c_info, 0, sizeof(struct i2c_board_info));
-	strlcpy(i2c_info.name, "isp1301_pnx", I2C_NAME_SIZE);
+	strlcpy(i2c_info.type, "isp1301_pnx", I2C_NAME_SIZE);
 	isp1301_i2c_client = i2c_new_probed_device(i2c_adap, &i2c_info,
 						   normal_i2c);
 	i2c_put_adapter(i2c_adap);
@@ -411,7 +411,7 @@ out3:
 out2:
 	clk_put(usb_clk);
 out1:
-	i2c_unregister_client(isp1301_i2c_client);
+	i2c_unregister_device(isp1301_i2c_client);
 	isp1301_i2c_client = NULL;
 out_i2c_driver:
 	i2c_del_driver(&isp1301_driver);
@@ -430,7 +430,7 @@ static int usb_hcd_pnx4008_remove(struct
 	pnx4008_unset_usb_bits();
 	clk_disable(usb_clk);
 	clk_put(usb_clk);
-	i2c_unregister_client(isp1301_i2c_client);
+	i2c_unregister_device(isp1301_i2c_client);
 	isp1301_i2c_client = NULL;
 	i2c_del_driver(&isp1301_driver);
 


