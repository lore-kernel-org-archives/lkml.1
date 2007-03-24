Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbXCXFVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbXCXFVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 01:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbXCXFVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 01:21:39 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:49473 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbXCXFVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 01:21:39 -0400
Date: Sat, 24 Mar 2007 06:20:45 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid time_offset overflows
In-Reply-To: <1174696834.5690.14.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703240153220.14457@scrub.home>
References: <1174696834.5690.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 23 Mar 2007, john stultz wrote:

> @@ -314,8 +314,8 @@ #endif
>  		    freq_adj += time_freq;
>  		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
>  		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
> -		    time_offset = (time_offset / NTP_INTERVAL_FREQ)
> -		    			<< SHIFT_UPDATE;
> +		    do_div(time_offset, NTP_INTERVAL_FREQ);
> +		    time_offset <<= SHIFT_UPDATE;
>  		} /* STA_PLL */
>  	    } /* txc->modes & ADJ_OFFSET */
>  	    if (txc->modes & ADJ_TICK)

This is wrong, time_offset is signed and do_div is unsigned.
In general I planned to do the same change, but the do_div API could use a 
little cleanup to provide some clear function for signed/unsigned divide 
(hopefully with a better name than div_long_long_rem_signed or 
do_div_llr).

bye, Roman
