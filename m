Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbXLKPUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbXLKPUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXLKPUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:20:44 -0500
Received: from smtp3.euronet.nl ([194.134.35.173]:54915 "EHLO smtp3.euronet.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbXLKPUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:20:43 -0500
X-Greylist: delayed 1055 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2007 10:20:43 EST
Message-ID: <014901c83c06$da9223e0$2b00a8c0@ARV127>
From: "Rini van Zetten" <rini@arvoo.nl>
To: <afleming@freescale.com>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH]drivers/net/phy/: default return value in ioctl phy.c
Date: Tue, 11 Dec 2007 16:02:31 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-ARVOO-MailScanner-Information: Please contact the ISP for more information
X-ARVOO-MailScanner: Found to be clean
X-ARVOO-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-5.708, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	AWL 0.09, BAYES_00 -4.00, DKIM_POLICY_SIGNSOME 0.00,
	STOX_REPLY_TYPE 0.00)
X-ARVOO-MailScanner-From: rini@arvoo.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andy,

This patch (to 2.6.23.9) add a default return value EOPNOTSUPP to the ioctl 
function. The problem with the always 0 return value is that the iwconfig 
(wireless) tool found a valid device when an ethernet device uses the phy 
abstraction layer.
I 've tetsted this with the macb driver.


Signed-off-by: Rini van Zetten <rini@arvoo.nl>

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index cb230f4..c07460d 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -405,6 +405,8 @@ int phy_mii_ioctl(struct phy_device *phydev,
                                && phydev->drv->config_init)
                        phydev->drv->config_init(phydev);
                break;
+       default:
+               return -EOPNOTSUPP;
        }

        return 0;

