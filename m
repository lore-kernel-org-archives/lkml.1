Return-Path: <linux-kernel-owner+w=401wt.eu-S1765054AbYBWIGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765054AbYBWIGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762838AbYBWIEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:04:06 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:32773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762754AbYBWIEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:04:04 -0500
Date: Sat, 23 Feb 2008 00:03:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] macb: Fix speed setting
Message-Id: <20080223000323.ac3eafa4.akpm@linux-foundation.org>
In-Reply-To: <1203612065-18192-1-git-send-email-hskinnemoen@atmel.com>
References: <20080221.225054.61509660.anemo@mba.ocn.ne.jp>
	<1203612065-18192-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 17:41:05 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> 
> Fix NCFGR.SPD setting on 10Mbps.  This bug was introduced by
> conversion to generic PHY layer in kernel 2.6.23.

So..  shouldn't we fix it in 2.6.23.x and 2.6.24.x?

> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
>  drivers/net/macb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
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
>  				reg |= MACB_BIT(SPD);
>  
>  			macb_writel(bp, NCFGR, reg);

