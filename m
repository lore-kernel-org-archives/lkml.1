Return-Path: <linux-kernel-owner+w=401wt.eu-S1765675AbYDYST5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765675AbYDYST5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762519AbYDYSTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:19:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:43545 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762184AbYDYSTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:19:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=NuSYwEHH8N1z4NHf3OmO5/f3TtINaPFvmruaEdSAIu22pE81d8PgEP8Kkb9O0U8ZqCota1/3/d78vXFU3yq1ksCVHX2TNy8dtRI8uTVROKOHfQciPF9DC9TF3TCI5ioj3++ozss98L69YCyqoqYFz+FE+4VTxqW/Enf7WXiSjTU=
To: David Miller <davem@davemloft.net>
Subject: Re: latest git (linux-2.6.25-git6) compile error
Date: Fri, 25 Apr 2008 20:20:50 +0200
User-Agent: KMail/1.9.9
Cc: plamen.petrov@fs.ru.acad.bg, linux-kernel@vger.kernel.org
References: <200804250028.24913.pvp@fs.ru.acad.bg> <481173E7.3050903@fs.ru.acad.bg> <20080424.233521.111619900.davem@davemloft.net>
In-Reply-To: <20080424.233521.111619900.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804252020.50178.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 April 2008, David Miller wrote:
> From: Plamen Petrov <plamen.petrov@fs.ru.acad.bg>
> Date: Fri, 25 Apr 2008 09:02:15 +0300
> 
> > Ivo van Doorn wrote:
> > > Can you confirm that this error goes away when enabling CONFIG_NEW_LEDS ?
> > >
> > > Ivo
> > >   
> > Will try and report later - now I'm at work, away from the machine.
> 
> This should have been fixed by the patch below.
> 
> Or is it the problem that simply selecting LEDS_CLASS doesn't take
> care of LEDS_CLASS's dependencies such as NEW_LEDS?  Ugh, if so...

The config file from Plamen contains:
# CONFIG_NEW_LEDS is not set
CONFIG_LEDS_CLASS=y

So this is a dependency problem, I guess the functions:
led_classdev_resume
led_classdev_suspend
led_classdev_register
led_classdev_unregister
are only compiled in when NED_LEDS is selected. :S

Ivo

> commit 201410ce85d80b7b893cdc72e944a1341dd393f1
> Author: David S. Miller <davem@davemloft.net>
> Date:   Wed Apr 23 03:34:50 2008 -0700
> 
>     rt2x00: Select LEDS_CLASS.
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index a1e3938..ab1029e 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -60,7 +60,8 @@ config RT2400PCI_RFKILL
>  
>  config RT2400PCI_LEDS
>  	bool "RT2400 leds support"
> -	depends on RT2400PCI && LEDS_CLASS
> +	depends on RT2400PCI
> +	select LEDS_CLASS
>  	select RT2X00_LIB_LEDS
>  	---help---
>  	  This adds support for led triggers provided my mac80211.
> @@ -86,7 +87,8 @@ config RT2500PCI_RFKILL
>  
>  config RT2500PCI_LEDS
>  	bool "RT2500 leds support"
> -	depends on RT2500PCI && LEDS_CLASS
> +	depends on RT2500PCI
> +	select LEDS_CLASS
>  	select RT2X00_LIB_LEDS
>  	---help---
>  	  This adds support for led triggers provided my mac80211.
> @@ -114,7 +116,8 @@ config RT61PCI_RFKILL
>  
>  config RT61PCI_LEDS
>  	bool "RT61 leds support"
> -	depends on RT61PCI && LEDS_CLASS
> +	depends on RT61PCI
> +	select LEDS_CLASS
>  	select RT2X00_LIB_LEDS
>  	---help---
>  	  This adds support for led triggers provided my mac80211.
> @@ -130,7 +133,8 @@ config RT2500USB
>  
>  config RT2500USB_LEDS
>  	bool "RT2500 leds support"
> -	depends on RT2500USB && LEDS_CLASS
> +	depends on RT2500USB
> +	select LEDS_CLASS
>  	select RT2X00_LIB_LEDS
>  	---help---
>  	  This adds support for led triggers provided my mac80211.
> @@ -148,7 +152,8 @@ config RT73USB
>  
>  config RT73USB_LEDS
>  	bool "RT73 leds support"
> -	depends on RT73USB && LEDS_CLASS
> +	depends on RT73USB
> +	select LEDS_CLASS
>  	select RT2X00_LIB_LEDS
>  	---help---
>  	  This adds support for led triggers provided my mac80211.
> 


