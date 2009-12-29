Return-Path: <linux-kernel-owner+w=401wt.eu-S1751810AbZL2NtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbZL2NtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 08:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZL2NtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 08:49:07 -0500
Received: from lan.nucleusys.com ([78.83.248.164]:44996 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751612AbZL2NtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 08:49:06 -0500
X-Greylist: delayed 2124 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Dec 2009 08:49:05 EST
Date: Tue, 29 Dec 2009 15:13:28 +0200 (EET)
From: Petko Manolov <petkan@nucleusys.com>
To: Roel Kluin <roel.kluin@gmail.com>
cc: Petko Manolov <petkan@users.sourceforge.net>, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbnet: test off by one
In-Reply-To: <4B37D000.6070009@gmail.com>
Message-ID: <alpine.DEB.2.00.0912291504520.2335@fry.nucleusys.com>
References: <4B37D000.6070009@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 	Hey Roel,

MII_TIMEOUT is a number i made up myself, reasonably small so the driver 
won't sit there forever, but higher than 2.  While testing the gadget i 
discovered that reading MII registers sometimes require more than one 
attempt.

Technically you're right.  In practice it doesn't matter much.  Hitting 
the boundary condition mean things are already out of hand.


 		Petko



On Sun, 27 Dec 2009, Roel Kluin wrote:

> With `while (i++ < MII_TIMEOUT)' i reaches MII_TIMEOUT + 1 after the loop
> This is probably unlikely a problem in practice.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> drivers/net/usb/rtl8150.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> index f14d225..fd19db0 100644
> --- a/drivers/net/usb/rtl8150.c
> +++ b/drivers/net/usb/rtl8150.c
> @@ -270,7 +270,7 @@ static int read_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 * reg)
> 		get_registers(dev, PHYCNT, 1, data);
> 	} while ((data[0] & PHY_GO) && (i++ < MII_TIMEOUT));
>
> -	if (i < MII_TIMEOUT) {
> +	if (i <= MII_TIMEOUT) {
> 		get_registers(dev, PHYDAT, 2, data);
> 		*reg = data[0] | (data[1] << 8);
> 		return 0;
> @@ -295,7 +295,7 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
> 		get_registers(dev, PHYCNT, 1, data);
> 	} while ((data[0] & PHY_GO) && (i++ < MII_TIMEOUT));
>
> -	if (i < MII_TIMEOUT)
> +	if (i <= MII_TIMEOUT)
> 		return 0;
> 	else
> 		return 1;
>
