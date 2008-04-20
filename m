Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbYDTJZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbYDTJZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 05:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYDTJYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 05:24:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:64368 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbYDTJYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 05:24:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=EITPKD9tKmVexPWceJlTxQwRBkuFFurmi4H7ABbqKMd5qPki9Udgq5fLAZShD2hPfmY9WduGaEGdm286lUEK5y8Jt/Em13KGOuUPzkKqQLtVMwA2/DsfIQTkErQQZKmaui2R4ew6r6HIh2pS/rQCEZq3HV99xdodQwfqKrs8CRA=
To: David Miller <davem@davemloft.net>
Subject: Re: [build bug] drivers/built-in.o: In function `rt2x00leds_resume': : undefined reference to `led_classdev_resume'
Date: Sun, 20 Apr 2008 11:31:00 +0200
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, linville@tuxdriver.com, tomas.winkler@intel.com,
       linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       mabbas@linux.intel.com, ischram@telenet.be, rjw@sisk.pl
References: <20080420081302.GA11954@elte.hu> <20080420.020557.231970202.davem@davemloft.net>
In-Reply-To: <20080420.020557.231970202.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804201131.01504.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 April 2008, David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun, 20 Apr 2008 10:13:02 +0200
> 
> >   drivers/built-in.o: In function `rt2x00leds_resume':
> >   : undefined reference to `led_classdev_resume'
> >   drivers/built-in.o: In function `rt2x00leds_resume':
> >   : undefined reference to `led_classdev_resume'
> >   [...]
> > 
> > config:
> > 
> >   http://redhat.com/~mingo/misc/config-Sun_Apr_20_09_43_01_CEST_2008.bad
> 
> Thanks for your report.
> 
> This is a similar case to the iwlwifi build failure you reported
> earlier today (where the leds infrastructure knob is modular but the
> driver using the interfaces is built-in).  Therefore, it likely should
> use select too.
> 
> This should fix it:
> 
> rt2x00: Select LEDS_CLASS instead of using 'depends'.
> 
> Based upon a build failure reported by Ingo Molnar.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
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

Not sure about it, but doesn't LEDS_CLASS depend on NEW_LEDS ?
Which would make selecting LEDS_CLASS broken when NEW_LEDS isn't enabled?

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

Ivo
