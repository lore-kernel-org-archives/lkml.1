Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab0BSOmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 09:42:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42563 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0BSOmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 09:42:21 -0500
From: Luotao Fu <l.fu@pengutronix.de>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH] USB: fix I2C API usage in ohci-pnx4008.
Date: Fri, 19 Feb 2010 15:42:00 +0100
Message-Id: <1266590520-8607-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.6.6.2
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_board_info doesn't contain a member called name. i2c_register_client call
does not exist.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/usb/host/ohci-pnx4008.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ohci-pnx4008.c b/drivers/usb/host/ohci-pnx4008.c
index 2769326..cd74bbd 100644
--- a/drivers/usb/host/ohci-pnx4008.c
+++ b/drivers/usb/host/ohci-pnx4008.c
@@ -327,7 +327,7 @@ static int __devinit usb_hcd_pnx4008_probe(struct platform_device *pdev)
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
@@ -430,7 +430,7 @@ static int usb_hcd_pnx4008_remove(struct platform_device *pdev)
 	pnx4008_unset_usb_bits();
 	clk_disable(usb_clk);
 	clk_put(usb_clk);
-	i2c_unregister_client(isp1301_i2c_client);
+	i2c_unregister_device(isp1301_i2c_client);
 	isp1301_i2c_client = NULL;
 	i2c_del_driver(&isp1301_driver);
 
-- 
1.6.6.2

