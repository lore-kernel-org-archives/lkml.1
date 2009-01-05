Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbZAEWqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbZAEWqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZAEWqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:46:12 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:43436 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751305AbZAEWqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:46:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cVUYojF8i5TJRgGOHqsdEVhaB6FyPUg1m8bSNpdzv2DMxN7ocUG+7tgVC7l4s7gvq7E8k5n4DRo67wA+F4QSyQ9eDE6p5dj1LugCKIPXQnaX2h7S/EpDCeF9c8AE9sXlUOklQm1Uo0RR0raVW4eto10n0/LNLzQtZQTcZH5BT5o=  ;
X-YMail-OSG: UCPKqsgVM1kLAC4gvumX.OTxqIZhp3x9sa_UmjW_3kmuO1ZDE8QvyAkXWObXJLc2n6dfKR6XqhON6r0Y9a_wxEPsZ61Z0cQLpkCfM.H7f8VnFM56haBZGCoyUbg_7rhi4P5zohgBunZ_uvrd7mLCxlM3Wk8kU59uRDHXr2Sl5UvEgQkAEJLc6q8MwIggQV74pLMN43xp5JCMUckT5_sZnFDh.96E7UM2BdiSKg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: sangsu <sangsu@gmail.com>
Subject: Re: [PATCH]USB:Fix goku_udc usb speed handling
Date: Mon, 5 Jan 2009 14:46:08 -0800
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org
References: <20090101161114.GA7977@sangsu-desktop>
In-Reply-To: <20090101161114.GA7977@sangsu-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051446.09047.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 January 2009, sangsu wrote:
> The usb gadget framework revealed weakness in the godu_udc
> gadget driver register function. Instead of checking if 
> speed asked for was USB_LOW_SPEED upon usb_gadget_register()
> to deny service, it checked only for USB_FULL_SPEED, thus
> denying service to usb high speed capable gadgets.
> 
> Signed-off-by: SangSu Park<sangsu@gmail.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


Good to know this USB peripheral driver is getting some use.  :)


> ---
> drivers/usb/gadget/goku_udc.c |2+-
> 1 files changed, 1 insertion(+), 1 deletions(-)
> 
> 
> --- a/drivers/usb/gadget/goku_udc.c	2008-12-30 23:24:02.000000000 +0900
> +++ b/drivers/usb/gadget/goku_udc.c	2009-01-02 00:49:15.000000000 +0900
> @@ -1349,7 +1349,7 @@
>  	int			retval;
>  
>  	if (!driver
> -			|| driver->speed != USB_SPEED_FULL
> +			|| driver->speed < USB_SPEED_FULL
>  			|| !driver->bind
>  			|| !driver->disconnect
>  			|| !driver->setup)
> 
> 


