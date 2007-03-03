Return-Path: <linux-kernel-owner+w=401wt.eu-S1751723AbXCCUWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbXCCUWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 15:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbXCCUWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 15:22:32 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42577
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbXCCUWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 15:22:31 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] bcm43xx: do not rebuild when kernel version changes
Date: Sat, 3 Mar 2007 21:21:42 +0100
User-Agent: KMail/1.9.5
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Larry Finger <larry.finger@lwfinger.net>
References: <20070303190328.GA30463@uranus.ravnborg.org>
In-Reply-To: <20070303190328.GA30463@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703032121.43136.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 March 2007 20:03, Sam Ravnborg wrote:
> Replacing use of UTS_RELEASE with utsname()->release
> avoids that this module is rebuild each
> time the kernel version changes.
> 
> Compile tested only.

I vote to get rid of the whole bcm43xx_ethtool.c file, as it's useless.
It will vanish with the advent of d80211, anyway.
Larry?

> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
> diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c b/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
> index c947025..d2df6a0 100644
> --- a/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
> +++ b/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
> @@ -32,7 +32,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/pci.h>
>  #include <linux/string.h>
> -#include <linux/utsrelease.h>
> +#include <linux/utsname.h>
>  
>  
>  static void bcm43xx_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
> @@ -40,7 +40,7 @@ static void bcm43xx_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *
>  	struct bcm43xx_private *bcm = bcm43xx_priv(dev);
>  
>  	strncpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
> -	strncpy(info->version, UTS_RELEASE, sizeof(info->version));
> +	strncpy(info->version, utsname()->release, sizeof(info->version));
>  	strncpy(info->bus_info, pci_name(bcm->pci_dev), ETHTOOL_BUSINFO_LEN);
>  }
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Greetings Michael.
