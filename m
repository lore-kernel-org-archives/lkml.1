Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbYEFNQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbYEFNQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbYEFNP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:15:58 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:59221 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbYEFNP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:15:58 -0400
Date: Tue, 6 May 2008 10:13:08 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com
Subject: Re: x86: Clean up computation of HPET .mult variables
Message-ID: <20080506131308.GA26767@beyonder.ift.unesp.br>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, venkatesh.pallipadi@intel.com
References: <20080505231016.GA29072@beyonder.ift.unesp.br> <20080506124348.GR32591@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506124348.GR32591@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> since you seem to be interested in HPET topics, what do you think about 
> the patch below from akpm? It had a build failure with this config:
> 
>   http://redhat.com/~mingo/misc/config-Sun_May__4_09_41_21_CEST_2008.bad
> 
> but the general cleanliness point Andrew raises is valid i think.

Heh, thanks! I will try hard to understand what is going on with
Andrew's patch and get back to you later if I succeed.


> 	Ingo
> 
> ------------->
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Should already be available via the hpet.h inclusion.
> 
> Could go further, by defining the do-nothing stub in hpet.h as well, perhaps.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/char/rtc.c     |    2 --
>  drivers/rtc/rtc-cmos.c |    1 -
>  2 files changed, 3 deletions(-)
> 
> diff -puN drivers/char/rtc.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt drivers/char/rtc.c
> --- a/drivers/char/rtc.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt
> +++ a/drivers/char/rtc.c
> @@ -119,8 +119,6 @@ static irqreturn_t hpet_rtc_interrupt(in
>  	return 0;
>  }
>  #endif
> -#else
> -extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
>  #endif
>  
>  /*
> diff -puN drivers/rtc/rtc-cmos.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt drivers/rtc/rtc-cmos.c
> --- a/drivers/rtc/rtc-cmos.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt
> +++ a/drivers/rtc/rtc-cmos.c
> @@ -52,7 +52,6 @@
>  #define hpet_rtc_timer_init() 			do { } while (0)
>  #define hpet_register_irq_handler(h) 		0
>  #define hpet_unregister_irq_handler(h)		do { } while (0)
> -extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
>  #endif
>  
>  struct cmos_rtc {
> _

