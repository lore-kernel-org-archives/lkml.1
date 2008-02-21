Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbYBUONN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYBUONN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 09:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYBUOM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 09:12:59 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:64238 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752464AbYBUOM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 09:12:58 -0500
Date: Thu, 21 Feb 2008 15:12:46 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] macb: Fix speed setting
Message-ID: <20080221151246.6f2044b9@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080221.225054.61509660.anemo@mba.ocn.ne.jp>
References: <20080221.225054.61509660.anemo@mba.ocn.ne.jp>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 22:50:54 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> Fix NCFGR.SPD setting on 10Mbps.  This bug was introduced by
> conversion to generic PHY layer in kernel 2.6.23.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
> diff --git a/drivers/net/macb.c b/drivers/net/macb.c
> index 81bf005..1d210ed 100644
> --- a/drivers/net/macb.c
> +++ b/drivers/net/macb.c
> @@ -148,7 +148,7 @@ static void macb_handle_link_change(struct net_device *dev)
>  
>  			if (phydev->duplex)
>  				reg |= MACB_BIT(FD);
> -			if (phydev->speed)
> +			if (phydev->speed == SPEED_100)

I have to admit that even after looking through include/linux/phy.h and
include/linux/mii.h, I don't have the faintest idea what values we can
expect to find in the "speed" field of phydev. The comment above struct
phy_device says that it is used "like in mii_if_info", but struct
mii_if_info doesn't have a "speed" field...

I'm willing to take your word for it, but some documentation would be
really nice...

Haavard
