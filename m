Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbZCWOP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbZCWOP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbZCWOPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:15:45 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45513 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044AbZCWOPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:15:43 -0400
Date: Mon, 23 Mar 2009 10:14:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: Michael Buesch <mb@bu3sch.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] p54: fix SoftLED compile dependencies
Message-ID: <20090323141449.GD3285@tuxdriver.com>
References: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au> <49C293CC.6020009@oracle.com> <200903191955.00718.mb@bu3sch.de> <200903210057.47067.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903210057.47067.chunkeey@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 12:57:46AM +0100, Christian Lamparter wrote:
> This patch fixes a compile problem when the MAC80211_LEDS
> triggers are enabled but not LED class itself. 
> (which is sort of pointless, but anyway...)
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> mb, thank you for the tips!
> 
> Randy Dunlap can you please give this patch a try?
> 
> John, do you know where the patch form 
> Geert Uytterhoeven <geert@linux-m68k.org> went?
> ---
> diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
> index 0e344ac..ee1aaca 100644
> --- a/drivers/net/wireless/p54/Kconfig
> +++ b/drivers/net/wireless/p54/Kconfig
> @@ -1,9 +1,10 @@
>  config P54_COMMON
>  	tristate "Softmac Prism54 support"
> -	depends on MAC80211 && WLAN_80211 && FW_LOADER && EXPERIMENTAL
> +	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
> +	select FW_LOADER
>  	---help---
> -	  This is common code for isl38xx based cards.
> -	  This module does nothing by itself - the USB/PCI frontends
> +	  This is common code for isl38xx/stlc45xx based modules.
> +	  This module does nothing by itself - the USB/PCI/SPI frontends
>  	  also need to be enabled in order to support any devices.
>  
>  	  These devices require softmac firmware which can be found at

This hunk looks unrelated to the changelog as well...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
