Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZFERSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZFERSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZFERSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:18:43 -0400
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:28156 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751302AbZFERSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:18:42 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jun 2009 13:18:42 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Yx0OR9BslE7lh7hcgi/CF8vdJo5ja9z6Q1gFDyw+Bwxd7jwRv24QfQ6moTyXWTPISDWcdDSm353q3pv3fEFl636id3UuYwZozpfgxwyoxt+84lckDfOPF50y4U/WUCX44AqIePUG/nZVUmh63qWhY0YBYWD/U77oTVqapICbDAM=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: Mya3sZkVM1m165cKOSbXNHq5dMizpefboCExigYWPLmpw8tjkXcsA2B9PQqaOA5zijQkPOqnSwQky_144Cuznx5fbPDrrcwV0ZD4vcPDBb8mw2uN3Z0KuF6w6Yi0CkQPypm1M8jqhD5fjjOx87i.7WPDoka386SwSRmxSyE6xNAGEY33VCgguXwAX4hoplK_MHhXyGacBivt.1tBbI_4jwj.EEoTTHP4qI6e3zSLHBiVO0osvuszIVbNwZO9XY04scM-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] atmel_usba_udc: change way of specifying bias function
Date: Fri, 5 Jun 2009 10:12:03 -0700
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, patrice.vilchez@atmel.com
References: <1244216776-22760-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1244216776-22760-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906051012.04124.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009, Nicolas Ferre wrote:
> The toggle_bias() function was specified differently for avr32 and at91
> architectures. Now, new at91 have the same behavior as avr32.
> Consequently, we change to a particular chip function definition: only for
> at91sam9rl.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>



> ---
> 
>  drivers/usb/gadget/atmel_usba_udc.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> index 563d572..a31df12 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -326,13 +326,7 @@ static int vbus_is_present(struct usba_udc *udc)
>  	return 1;
>  }
>  
> -#if defined(CONFIG_AVR32)
> -
> -static void toggle_bias(int is_on)
> -{
> -}
> -
> -#elif defined(CONFIG_ARCH_AT91)
> +#if defined(CONFIG_ARCH_AT91SAM9RL)
>  
>  #include <mach/at91_pmc.h>
>  
> @@ -346,7 +340,13 @@ static void toggle_bias(int is_on)
>  		at91_sys_write(AT91_CKGR_UCKR, uckr & ~(AT91_PMC_BIASEN));
>  }
>  
> -#endif /* CONFIG_ARCH_AT91 */
> +#else
> +
> +static void toggle_bias(int is_on)
> +{
> +}
> +
> +#endif /* CONFIG_ARCH_AT91SAM9RL */
>  
>  static void next_fifo_transaction(struct usba_ep *ep, struct usba_request *req)
>  {
> -- 
> 1.5.3.7
> 
> 


