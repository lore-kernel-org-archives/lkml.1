Return-Path: <linux-kernel-owner+w=401wt.eu-S2992686AbXCBRsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992686AbXCBRsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992684AbXCBRsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:48:55 -0500
Received: from dsbex1.ad.uiuc.edu ([128.174.68.231]:40202 "EHLO
	dsbexcluster.ad.uiuc.edu" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992683AbXCBRsy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:48:54 -0500
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2007 12:48:54 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [patch 1/1] network: add the missing phy_device speed information to phy_mii_ioctl
Date: Fri, 2 Mar 2007 11:42:48 -0600
Message-ID: <9FD2C54661D3494AB6F269E0D4A74E83019775E1@DSBEXCLUSTER.ad.uiuc.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 1/1] network: add the missing phy_device speed information to phy_mii_ioctl
Thread-Index: AcdbxIloYXtoQCn+THmDOyC+FdL5AABLMgVAAAATbDAAAAmQ8A==
From: "Shan Lu" <shanlu@cs.uiuc.edu>
To: <jeff@garzik.org>, <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: <shanlu@uiuc.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
Function `phy_mii_ioctl' returns physical device's information based on
user requests. When requested to return the basic mode control register
information (BMCR), the original implementation only returns the
physical device's duplex information and forgets to return speed
information, which should not be because BMCR register is used to hold
both duplex and speed information.

The patch checks the BMCR value against speed-related flags and fills
the return structure's speed field accordingly. 

Signed-off-by: Shan<shanlu@cs.uiuc.edu>

---
--- drivers/net/phy/phy.c   2007-03-02 10:40:26.000000000 -0600  2.6.20
+++ drivers/net/phy/phy.c   2007-03-02 10:41:39.000000000 -0600
@@ -337,6 +337,10 @@ int phy_mii_ioctl(struct phy_device *phy
                                        phydev->duplex = DUPLEX_FULL;
                                else
                                        phydev->duplex = DUPLEX_HALF;
+                               if ((!phydev->autoneg) && (val
&BMCR_SPEED1000))
+                                       phydev->speed = SPEED_1000;
+                               else if ((!phydev->autoneg) && (val &
BMCR_SPEED100))
+                                       phydev->speed = SPEED_100;
                                break;
                        case MII_ADVERTISE:
                                phydev->advertising = val;
