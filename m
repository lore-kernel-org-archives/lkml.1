Return-Path: <linux-kernel-owner+w=401wt.eu-S2992856AbXCCBXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992856AbXCCBXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992830AbXCCBXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:23:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55620 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992829AbXCCBXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:23:12 -0500
Message-ID: <45E8CDFA.7020609@garzik.org>
Date: Fri, 02 Mar 2007 20:23:06 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Shan Lu <shanlu@cs.uiuc.edu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, shanlu@uiuc.edu
Subject: Re: [patch 1/1] network: add the missing phy_device speed information
 to phy_mii_ioctl
References: <9FD2C54661D3494AB6F269E0D4A74E83019775E1@DSBEXCLUSTER.ad.uiuc.edu>
In-Reply-To: <9FD2C54661D3494AB6F269E0D4A74E83019775E1@DSBEXCLUSTER.ad.uiuc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shan Lu wrote:
> Changelog:
> Function `phy_mii_ioctl' returns physical device's information based on
> user requests. When requested to return the basic mode control register
> information (BMCR), the original implementation only returns the
> physical device's duplex information and forgets to return speed
> information, which should not be because BMCR register is used to hold
> both duplex and speed information.
> 
> The patch checks the BMCR value against speed-related flags and fills
> the return structure's speed field accordingly. 
> 
> Signed-off-by: Shan<shanlu@cs.uiuc.edu>
> 
> ---
> --- drivers/net/phy/phy.c   2007-03-02 10:40:26.000000000 -0600  2.6.20
> +++ drivers/net/phy/phy.c   2007-03-02 10:41:39.000000000 -0600
> @@ -337,6 +337,10 @@ int phy_mii_ioctl(struct phy_device *phy
>                                         phydev->duplex = DUPLEX_FULL;
>                                 else
>                                         phydev->duplex = DUPLEX_HALF;
> +                               if ((!phydev->autoneg) && (val
> &BMCR_SPEED1000))
> +                                       phydev->speed = SPEED_1000;
> +                               else if ((!phydev->autoneg) && (val &
> BMCR_SPEED100))
> +                                       phydev->speed = SPEED_100;

patch is word-wrapped


