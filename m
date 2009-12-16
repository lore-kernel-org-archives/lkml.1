Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbZLPRYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbZLPRYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762356AbZLPRYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:24:09 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35603 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762314AbZLPRYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:24:07 -0500
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: omap3_pm_get_suspend_state() error ignored in pwrdm_suspend_get()
References: <4B29092C.4040600@gmail.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Wed, 16 Dec 2009 09:23:59 -0800
In-Reply-To: <4B29092C.4040600@gmail.com> (Roel Kluin's message of "Wed\, 16 Dec 2009 17\:22\:04 +0100")
Message-ID: <87hbrqbzo0.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin <roel.kluin@gmail.com> writes:

> val is an u64 pointer, we need an int to check the error.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Thanks, will queue this in my PM fixes queue for .33-rc series.

Kevin

> ---
> Found using coccinelle: http://coccinelle.lip6.fr/
>
> diff --git a/arch/arm/mach-omap2/pm-debug.c b/arch/arm/mach-omap2/pm-debug.c
> index 860b755..081ca85 100644
> --- a/arch/arm/mach-omap2/pm-debug.c
> +++ b/arch/arm/mach-omap2/pm-debug.c
> @@ -488,9 +488,11 @@ int pm_dbg_regset_init(int reg_set)
>  
>  static int pwrdm_suspend_get(void *data, u64 *val)
>  {
> -	*val = omap3_pm_get_suspend_state((struct powerdomain *)data);
> +	int ret;
> +	ret = omap3_pm_get_suspend_state((struct powerdomain *)data);
> +	*val = ret;
>  
> -	if (*val >= 0)
> +	if (ret >= 0)
>  		return 0;
>  	return *val;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
