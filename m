Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbXJ2WUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbXJ2WUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXJ2WUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:20:43 -0400
Received: from www.tglx.de ([62.245.132.106]:51870 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbXJ2WUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:20:43 -0400
Date: Mon, 29 Oct 2007 23:17:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, --cc@redhat.com,
       Ingo Molnar <mingo@elte.hu>, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net, John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] raise tsc clocksource rating
In-Reply-To: <11936994092607-git-send-email-gcosta@redhat.com>
Message-ID: <alpine.LFD.0.9999.0710292315280.3186@localhost.localdomain>
References: <11936994092607-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Glauber de Oliveira Costa wrote:

CC'ed John and removed glauber@t60.localdomain :)

> From: Glauber de Oliveira Costa <glauber@t60.localdomain>
> 
> tsc is very good time source (when it does not have drifts, does not
> change it's frequency, i.e. when it works), so it should have its rating
> raised to a value greater than, or equal 400.
> 
> Since it's being a tendency among paravirt clocksources to use values
> around 400, we should declare tsc as even better: So we use 500.
> 
> This patch also touches the comments on clocksource.h, which suggests
> that 499 would be a limit on the rating values.
> 
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
>  arch/x86/kernel/tsc_32.c    |    2 +-
>  arch/x86/kernel/tsc_64.c    |    2 +-
>  include/linux/clocksource.h |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
> index 9ebc0da..4d91e59 100644
> --- a/arch/x86/kernel/tsc_32.c
> +++ b/arch/x86/kernel/tsc_32.c
> @@ -280,7 +280,7 @@ static cycle_t read_tsc(void)
>  
>  static struct clocksource clocksource_tsc = {
>  	.name			= "tsc",
> -	.rating			= 300,
> +	.rating			= 500,
>  	.read			= read_tsc,
>  	.mask			= CLOCKSOURCE_MASK(64),
>  	.mult			= 0, /* to be set */
> diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
> index 9c70af4..4fd5b1b 100644
> --- a/arch/x86/kernel/tsc_64.c
> +++ b/arch/x86/kernel/tsc_64.c
> @@ -262,7 +262,7 @@ static cycle_t __vsyscall_fn vread_tsc(void)
>  
>  static struct clocksource clocksource_tsc = {
>  	.name			= "tsc",
> -	.rating			= 300,
> +	.rating			= 500,
>  	.read			= read_tsc,
>  	.mask			= CLOCKSOURCE_MASK(64),
>  	.shift			= 22,
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index 107787a..5b0aadd 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -39,7 +39,7 @@ struct clocksource;
>   *				A correct and usable clocksource.
>   *			300-399: Desired.
>   *				A reasonably fast and accurate clocksource.
> - *			400-499: Perfect
> + *			>= 400 : Perfect
>   *				The ideal clocksource. A must-use where
>   *				available.
>   * @read:		returns a cycle value
> -- 
> 1.5.0.6
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
