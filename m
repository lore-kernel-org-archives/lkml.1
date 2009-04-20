Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbZDTFyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbZDTFyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 01:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZDTFye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 01:54:34 -0400
Received: from relay.atmel.no ([80.232.32.139]:53521 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbZDTFyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 01:54:33 -0400
Date: Mon, 20 Apr 2009 07:54:01 +0200
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Ben Nizette <ben@niasdigital.com>
Cc: "haavard.skinnemoen" <haavard.skinnemoen@atmel.com>,
       kernel <kernel@avr32linux.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] favr32: improve touchscreen response
Message-ID: <20090420075401.62d6d782@hcegtvedt>
In-Reply-To: <1240195013.24329.38.camel@linux-51e8.site>
References: <1240195013.24329.38.camel@linux-51e8.site>
Organization: Atmel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 12:36:53 +1000
Ben Nizette <ben@niasdigital.com> wrote:

> The ezLCD+101 board (to which an favr-32 is fitted) has a long,
> unshielded, nasty lead between the touch panel and the ads7843 touch
> controller.  In order to get satisfactory response then, we need to
> employ every noise-reduction trick in the driver's arsenal.  After
> extensive fiddling I've found some good settings:
> 
> 1) We keep vref on all the time to dramatically reduce settling times
> (at the cost of a tiny increase in power consumption).
> 
> 2) Despite 1 the settling time is still non-zero.  500uS is plenty of
> time for the signals to settle
> 
> 3) Despite 1 and 2 there's still a little bit of noise around.  By
> setting a pen recheck delay we make the panel feel less touchy and
> twitchy.
> 
> Someone with more time and patience myself might be able to tune this
> numbers further but these settings are now perfectly acceptable for
> normal use.
> 
> Tested on ezLCD+101 though should only improve response on other
> ezLCD+/ favr-32 boards too.
> 
> Signed-off-by: Ben Nizette <bn@niasdigital.com>
> 

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

> ---
>  arch/avr32/boards/favr-32/setup.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/avr32/boards/favr-32/setup.c
> b/arch/avr32/boards/favr-32/setup.c index 58203d1..f1152fa 100644
> --- a/arch/avr32/boards/favr-32/setup.c
> +++ b/arch/avr32/boards/favr-32/setup.c
> @@ -72,6 +72,10 @@ static struct ads7846_platform_data ads7843_data =
> { .debounce_max		= 20,
>  	.debounce_rep		= 4,
>  	.debounce_tol		= 5,
> +	
> +	.keep_vref_on		= true,
> +	.settle_delay_usecs	= 500,
> +	.penirq_recheck_delay_usecs = 100,
>  
>  	/* The ads7843 pendown irq is just connected to regular
>  	 * gpio and therefore can only trigger interrupts on

-- 
Best regards,
Hans-Christian Egtvedt
