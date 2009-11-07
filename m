Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbZKGXpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbZKGXpM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 18:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZKGXpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 18:45:10 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48349 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbZKGXpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 18:45:08 -0500
Date: Sat, 7 Nov 2009 18:32:05 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH -next] staging/wireless: don't build when NET etc. are
	not enabled
Message-ID: <20091107233204.GA26871@tuxdriver.com>
References: <20091106181330.80bca052.sfr@canb.auug.org.au> <4AF4B2B3.8020109@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF4B2B3.8020109@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd better take this one...

Thanks, Randy!

John

On Fri, Nov 06, 2009 at 03:35:15PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> These wireless drivers in staging could be built when
> CONFIG_NET=n, CONFIG_NETDEVICES=n, causing this build error:
> 
> net/wireless/wext-priv.c: In function 'ioctl_private_call':
> net/wireless/wext-priv.c:206: error: implicit declaration of function 'call_commit_handler'
> 
> due to faulty selects.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/staging/arlan/Kconfig   |    2 +-
>  drivers/staging/netwave/Kconfig |    2 +-
>  drivers/staging/wavelan/Kconfig |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> --- linux-next-20091106.orig/drivers/staging/arlan/Kconfig
> +++ linux-next-20091106/drivers/staging/arlan/Kconfig
> @@ -1,6 +1,6 @@
>  config ARLAN
>  	tristate "Aironet Arlan 655 & IC2200 DS support"
> -	depends on ISA && !64BIT
> +	depends on ISA && !64BIT && WLAN
>  	select WIRELESS_EXT
>  	---help---
>  	  Aironet makes Arlan, a class of wireless LAN adapters. These use the
> --- linux-next-20091106.orig/drivers/staging/netwave/Kconfig
> +++ linux-next-20091106/drivers/staging/netwave/Kconfig
> @@ -1,6 +1,6 @@
>  config PCMCIA_NETWAVE
>  	tristate "Xircom Netwave AirSurfer Pcmcia wireless support"
> -	depends on PCMCIA
> +	depends on PCMCIA && WLAN
>  	select WIRELESS_EXT
>  	select WEXT_PRIV
>  	help
> --- linux-next-20091106.orig/drivers/staging/wavelan/Kconfig
> +++ linux-next-20091106/drivers/staging/wavelan/Kconfig
> @@ -1,6 +1,6 @@
>  config WAVELAN
>  	tristate "AT&T/Lucent old WaveLAN & DEC RoamAbout DS ISA support"
> -	depends on ISA
> +	depends on ISA && WLAN
>  	select WIRELESS_EXT
>  	select WEXT_SPY
>  	select WEXT_PRIV
> @@ -25,7 +25,7 @@ config WAVELAN
>  
>  config PCMCIA_WAVELAN
>  	tristate "AT&T/Lucent old WaveLAN Pcmcia wireless support"
> -	depends on PCMCIA
> +	depends on PCMCIA && WLAN
>  	select WIRELESS_EXT
>  	select WEXT_SPY
>  	select WEXT_PRIV
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
