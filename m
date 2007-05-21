Return-Path: <linux-kernel-owner+w=401wt.eu-S1763206AbXEUK0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763206AbXEUK0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbXEUK0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:26:36 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1193 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961AbXEUK0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:26:35 -0400
Date: Mon, 21 May 2007 12:25:14 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Elimar Riesebieter <riesebie@lxtec.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2 built on ppc (2)
In-Reply-To: <1179741817.6570.44.camel@chaos>
Message-ID: <Pine.LNX.4.64.0705211223350.1817@scrub.home>
References: <20070520110815.GD3253@aragorn.home.lxtec.de> 
 <20070520143752.2f6be87a.akpm@linux-foundation.org> <1179741817.6570.44.camel@chaos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 21 May 2007, Thomas Gleixner wrote:

> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index cb25649..bb1bf86 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -304,10 +304,12 @@ int do_adjtimex(struct timex *txc)
>  			temp64 = time_offset << (SHIFT_NSEC - SHIFT_FLL);
>  			if (time_offset < 0) {
>  			    temp64 = -temp64;
> -			    do_div(temp64, mtemp);
> +			    temp64 = div_long_long_rem_signed(temp64, mtemp,
> +							      &rem);
>  			    freq_adj -= temp64;
>  			} else {
> -			    do_div(temp64, mtemp);
> +			    temp64 = div_long_long_rem_signed(temp64, mtemp,
> +							      &rem);
>  			    freq_adj += temp64;
>  			}
>  		    }

This only returns a long.

bye, Roman
