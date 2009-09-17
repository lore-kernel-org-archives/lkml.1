Return-Path: <linux-kernel-owner+w=401wt.eu-S1752208AbZIQH6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbZIQH6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbZIQH6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:58:22 -0400
Received: from bamako.nerim.net ([62.4.17.28]:57174 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZIQH6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:58:21 -0400
Date: Thu, 17 Sep 2009 09:58:23 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [patch 44/45] PCI: Unhide the SMBus on the Compaq Evo D510 USDT
Message-ID: <20090917095823.12682531@hyperion.delvare>
In-Reply-To: <20090916223719.861500408@mini.kroah.org>
References: <20090916223613.597295240@mini.kroah.org>
	<20090916223719.861500408@mini.kroah.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, 16 Sep 2009 15:36:57 -0700, Greg KH wrote:
> 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Jean Delvare <khali@linux-fr.org>
> 
> commit 6b5096e4d4496e185cd1ada5d1b8e1d941c805ed upstream.
> 
> One more form factor for Compaq Evo D510, which needs the same quirk
> as the other form factors. Apparently there's no hardware monitoring
> chip on that one, but SPD EEPROMs, so it's still worth unhiding the
> SMBus.

FWIW, this one doesn't strike me as being needed in -stable. While it
should be safe (otherwise it wouldn't have gone upstream in the first
place), it hardly fulfills -stable's requirement that "it must fix a
real bug that bothers people". There's no hardware monitoring chip on
the SMBus on this machine, and people can easily live without detailed
memory module information.

So it's up to you, but I won't cry if you drop this patch from -stable.

> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Tested-by: Nuzhna Pomoshch <nuzhna_pomoshch@yahoo.com>
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/pci/quirks.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1201,6 +1201,7 @@ static void __init asus_hides_smbus_host
>  			switch(dev->subsystem_device) {
>  			case 0x00b8: /* Compaq Evo D510 CMT */
>  			case 0x00b9: /* Compaq Evo D510 SFF */
> +			case 0x00ba: /* Compaq Evo D510 USDT */
>  				/* Motherboard doesn't have Host bridge
>  				 * subvendor/subdevice IDs and on-board VGA
>  				 * controller is disabled if an AGP card is
> 
> 


-- 
Jean Delvare
