Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYECNOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYECNOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 09:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYECNOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 09:14:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:36852 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbYECNOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 09:14:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=OAJsaJVMrcRlTn6JQrC47UERvzkqnl59BFxsIHxQTpP6PsG9LPhY1hwP0de0wkEMpso1lfmqgKMPYdAE0LFTsnHL3wCZFj0/q0mmf8aYZK/+VtkT8yV8tAs09HOZ1KFaIH2hwXAMRAA03qkF4SAWTjyawmuy2v0VJtIFwcK4cHE=
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch/bugreport] rt2x00: build fix
Date: Sat, 3 May 2008 15:19:32 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
References: <20080503124711.GA18244@elte.hu>
In-Reply-To: <20080503124711.GA18244@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805031519.33107.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 May 2008, Ingo Molnar wrote:
> 
> x86.git testing found the following build failure on latest -git:
> 
>    Building modules, stage 2.
>    MODPOST 332 modules
>  ERROR: "led_classdev_unregister" [drivers/net/wireless/rt2x00/rt2x00lib.ko] undefined!
>  ERROR: "led_classdev_resume" [drivers/net/wireless/rt2x00/rt2x00lib.ko] undefined!
>  ERROR: "led_classdev_register" [drivers/net/wireless/rt2x00/rt2x00lib.ko] undefined!
>  ERROR: "led_classdev_suspend" [drivers/net/wireless/rt2x00/rt2x00lib.ko] undefined!
>  make[1]: *** [__modpost] Error 1
>  make: *** [modules] Error 2
> 
> config can be found at:
> 
>   http://redhat.com/~mingo/misc/config-Sat_May__3_13_24_19_CEST_2008.bad
> 
> the patch here is just a quick workaround for now for my test-setup, it 
> makes the leds features in this driver depend on NEW_LEDS. Have not 
> checked how far away this is from the real fix. Hm, and i think think i 
> sent another patch for a similar build failure a week ago already - did 
> i miss some patch to try?

Well there seems to be a big dependency mess with the LED class handlers,
selecting the required options fail due to dependencies in the LED class handler,
but depending on the options fail because of "compiled in" vs "compiled as module"
problems...

> 	Ingo
> 
> ---
>  drivers/net/wireless/rt2x00/Kconfig |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: linux/drivers/net/wireless/rt2x00/Kconfig
> ===================================================================
> --- linux.orig/drivers/net/wireless/rt2x00/Kconfig
> +++ linux/drivers/net/wireless/rt2x00/Kconfig
> @@ -61,6 +61,7 @@ config RT2400PCI_RFKILL
>  config RT2400PCI_LEDS
>  	bool "RT2400 leds support"
>  	depends on RT2400PCI
> +	depends on NEW_LEDS
>  	select LEDS_CLASS
>  	select RT2X00_LIB_LEDS
>  	---help---
> @@ -88,6 +89,7 @@ config RT2500PCI_RFKILL
>  config RT2500PCI_LEDS
>  	bool "RT2500 leds support"
>  	depends on RT2500PCI
> +	depends on NEW_LEDS
>  	select LEDS_CLASS
>  	select RT2X00_LIB_LEDS
>  	---help---
> @@ -117,6 +119,7 @@ config RT61PCI_RFKILL
>  config RT61PCI_LEDS
>  	bool "RT61 leds support"
>  	depends on RT61PCI
> +	depends on NEW_LEDS
>  	select LEDS_CLASS
>  	select RT2X00_LIB_LEDS
>  	---help---
> @@ -134,6 +137,7 @@ config RT2500USB
>  config RT2500USB_LEDS
>  	bool "RT2500 leds support"
>  	depends on RT2500USB
> +	depends on NEW_LEDS
>  	select LEDS_CLASS
>  	select RT2X00_LIB_LEDS
>  	---help---
> @@ -153,6 +157,7 @@ config RT73USB
>  config RT73USB_LEDS
>  	bool "RT73 leds support"
>  	depends on RT73USB
> +	depends on NEW_LEDS
>  	select LEDS_CLASS
>  	select RT2X00_LIB_LEDS
>  	---help---
> 


