Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbZDVTGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbZDVTGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbZDVTGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:06:03 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:24051 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724AbZDVTGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:06:00 -0400
Message-ID: <49EF6AB9.3000900@oracle.com>
Date: Wed, 22 Apr 2009 12:06:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       jussi.kivilinna@mbnet.fi
Subject: Re: linux-next: Tree for April 22 (rndis_wlan)
References: <20090422154247.dbffd285.sfr@canb.auug.org.au> <49EF4B73.2050702@oracle.com> <20090422172804.GE3288@tuxdriver.com>
In-Reply-To: <20090422172804.GE3288@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.49EF6A82.00E1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John W. Linville wrote:
> On Wed, Apr 22, 2009 at 09:53:07AM -0700, Randy Dunlap wrote:
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20090421:
>>>
>>> For those who care about the order of trees, I have moved the merging of
>>> all the fs trees together and nearer the start of the process.
>>>
>>> This tree will not build a powerpc allyesconfig.
>>>
>>> The net tree lost its conflict.
>>>
>>> The wireless tree gained a conflict against eahc of the v4l-dvb and
>>> wireless-current trees and a build failure due to an interaction with the
>>> acpi tree for which I reverted a commit.
>> ERROR: "wiphy_free" [drivers/net/wireless/rndis_wlan.ko] undefined!
>> ERROR: "cfg80211_wext_siwscan" [drivers/net/wireless/rndis_wlan.ko] undefined!
>> ERROR: "cfg80211_wext_siwmode" [drivers/net/wireless/rndis_wlan.ko] undefined!
>> ERROR: "__ieee80211_get_channel" [drivers/net/wireless/rndis_wlan.ko] undefined!
>> ERROR: "wiphy_unregister" [drivers/net/wireless/rndis_wlan.ko] undefined!
>> ERROR: "cfg80211_inform_bss" [drivers/net/wireless/rndis_wlan.ko] undefined!
>> ERROR: "wiphy_new" [drivers/net/wireless/rndis_wlan.ko] undefined!
>> ERROR: "wiphy_register" [drivers/net/wireless/rndis_wlan.ko] undefined!
>> ERROR: "cfg80211_wext_giwrange" [drivers/net/wireless/rndis_wlan.ko] undefined!
>> ERROR: "cfg80211_wext_giwmode" [drivers/net/wireless/rndis_wlan.ko] undefined!
>> ERROR: "cfg80211_wext_giwname" [drivers/net/wireless/rndis_wlan.ko] undefined!
>> ERROR: "cfg80211_wext_giwscan" [drivers/net/wireless/rndis_wlan.ko] undefined!
>> ERROR: "cfg80211_scan_done" [drivers/net/wireless/rndis_wlan.ko] undefined!
> 
>> # CONFIG_CFG80211 is not set
> 
> No doubt this is the problem...

Yes, that builds.  Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
> 
> From bce85c97aeeb9c34098951e9ef3de425c6830b63 Mon Sep 17 00:00:00 2001
> From: John W. Linville <linville@tuxdriver.com>
> Date: Wed, 22 Apr 2009 13:27:08 -0400
> Subject: [PATCH] rndis_wlan: select CFG80211 in Kconfig
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index 11c2481..2d8434f 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -337,6 +337,7 @@ config USB_NET_RNDIS_WLAN
>  	select USB_NET_CDCETHER
>  	select USB_NET_RNDIS_HOST
>  	select WIRELESS_EXT
> +	select CFG80211
>  	---help---
>  	  This is a driver for wireless RNDIS devices.
>  	  These are USB based adapters found in devices such as:


-- 
~Randy
