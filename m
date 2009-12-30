Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbZL3QkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbZL3QkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 11:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZL3Qj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 11:39:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:4825 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZL3Qj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 11:39:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=aSfZVvWMvxQrbM8cXlWHFcGZ2snZguwCs6iYMqvLjRs+yO25XwZZKqw3OR+MQDHWP8
         ysAak/danI3J4dWSa+l/umMYBIfvDUCXWRlPFMju8Nt81kPxtTvDvZQWVqbfMwrM58QQ
         rMKSHLoMBi0xrUI2cZYsVTWAlnNRRx8myuv9Y=
Message-ID: <4B3B831A.507@gmail.com>
Date: Wed, 30 Dec 2009 17:43:06 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mcarlson@broadcom.com,
       davem@davemloft.net
Subject: [PATCH] broadcom: Fix &&/|| confusion in bcm54xx_adjust_rxrefclk()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This always evaluates to true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/phy/broadcom.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index c13cf64..33c4b12 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -331,8 +331,8 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
 	bool clk125en = true;
 
 	/* Abort if we are using an untested phy. */
-	if (BRCM_PHY_MODEL(phydev) != PHY_ID_BCM57780 ||
-	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610 ||
+	if (BRCM_PHY_MODEL(phydev) != PHY_ID_BCM57780 &&
+	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610 &&
 	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610M)
 		return;
 
