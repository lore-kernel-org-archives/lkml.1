Return-Path: <linux-kernel-owner+w=401wt.eu-S1764820AbYD3TEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764820AbYD3TEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762872AbYD3TEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:04:33 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:14908 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764679AbYD3TEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=SkSGH9XNc5z4Kd73vDGNG/uS2HyKtPhrAhcgQJ3scd73BswjI/719EGDdmQvCS1fK3v06En+oFhKFQLkragHgEYp9zpYrDH/jo6uheKY5A2mIWVWpIA1aP76eB0Tr8UF+BL14wsW3vs2GrbYyDX2Nv0+NsbBYXkMbfccmJyr33c=
Date: Wed, 30 Apr 2008 15:04:24 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch, -git] input: CONFIG_INPUT_APANEL build fix
Message-ID: <20080430150021.ZZRA012@mailhub.coreip.homeip.net>
References: <20080430185345.GA27224@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430185345.GA27224@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 08:54:16PM +0200, Ingo Molnar wrote:
> 
> x86.git testing found this build failure in upstream -git:
> 
>  drivers/built-in.o: In function `apanel_detach_client':
>  apanel.c:(.text+0x3027af): undefined reference to `led_classdev_unregister'
>  drivers/built-in.o: In function `apanel_probe':
>  apanel.c:(.text+0x302ac9): undefined reference to `led_classdev_register'
> 
> with this config:
> 
>  http://redhat.com/~mingo/misc/config-Wed_Apr_30_20_22_20_CEST_2008.bad
> 
> this driver has a missing CONFIG_NEW_LEDS dependency.

Thank you Ingo. Isn't this a Kconfig issue though? I know that Roman
is not willing to fix SELECT to evaluate the whole dependency chain,
but in this case it is "depens on" that does not evaluate properly...

> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/input/misc/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/input/misc/Kconfig
> ===================================================================
> --- linux.orig/drivers/input/misc/Kconfig
> +++ linux/drivers/input/misc/Kconfig
> @@ -43,7 +43,7 @@ config INPUT_M68K_BEEP
>  
>  config INPUT_APANEL
>  	tristate "Fujitsu Lifebook Application Panel buttons"
> -	depends on X86 && I2C && LEDS_CLASS
> +	depends on X86 && I2C && LEDS_CLASS && NEW_LEDS
>  	select INPUT_POLLDEV
>  	select CHECK_SIGNATURE
>  	help
> 

-- 
Dmitry
