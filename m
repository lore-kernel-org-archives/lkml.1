Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbYIUSEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbYIUSEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 14:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbYIUSEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 14:04:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:60474 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYIUSEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 14:04:23 -0400
Date: Sun, 21 Sep 2008 11:04:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       ipw2100-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       yi.zhu@intel.com, reinette.chatre@intel.com, jgarzik@pobox.com,
       linville@tuxdriver.com, davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware
 restart.
Message-ID: <20080921110422.1d010b96@infradead.org>
In-Reply-To: <20080921172316.GA6306@2ka.mipt.ru>
References: <20080921172316.GA6306@2ka.mipt.ru>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Sep 2008 21:23:17 +0400
Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> Hi.
> 
> Following bug exists in the ipw2100 driver/firmware for years and
> Intel folks never responded to zillions bugzilla entries and forum
> notices in the internet with some patch or firmware update (although
> did request dmesg and debug info, and received them).
> 
> ipw2100: Fatal interrupt. Scheduling firmware restart.
> 
> I believe it is a firmware bug because after driver is unloaded and
> loaded back again wireless adapter usually starts working (for small
> amount of time though). 
\
> diff --git a/drivers/net/wireless/Kconfig
> b/drivers/net/wireless/Kconfig index 9931b5a..c24fc6a 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -125,7 +125,7 @@ config PCMCIA_RAYCS
>  
>  config IPW2100
>  	tristate "Intel PRO/Wireless 2100 Network Connection"
> -	depends on PCI && WLAN_80211
> +	depends on PCI && WLAN_80211 && BROKEN
>  	select WIRELESS_EXT
>  	select FW_LOADER
>  	select IEEE80211
> 

so now you go from an occasional burp to having nothing at all.
How about you run with this patch on your own machine only?

or.. since you say a reload of the driver fixes it.. why don't you make
a patch for the driver that does basically the actions of a reload
automatically when the driver detects the issue?
(and stick a WARN_ON in for good measure so that kerneloops.org can
start tracking these burps)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
