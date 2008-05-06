Return-Path: <linux-kernel-owner+w=401wt.eu-S1763938AbYEFWvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763938AbYEFWvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbYEFWuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:50:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:49083 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbYEFWux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:50:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=D3Shwt/e4aGc3gmZ/qaSGPJ9/0yiaivVr5QNuydX4xjNVh7RAEsEckygmUUAc1P6pR5YnWIrm43ndh5dFdqVz2Ic1/FtlyFMDIrfIi4Gg54GTS+Ip/XqK6mO1IjmS4bauayQGTO6bK3DiA6wrSMMJ0NqBGpyOtgn5DcHAHuJvBQ=
Message-ID: <4820E0C6.10309@gmail.com>
Date: Wed, 07 May 2008 02:50:46 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080502)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RTC: rtc_time_to_tm: use unsigned arithmetic
References: <Pine.LNX.4.55.0805062315530.16173@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0805062315530.16173@cliff.in.clinika.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki пишет:
>  The input argument to rtc_time_to_tm() is unsigned as well as are members
> of the output structure.  However signed arithmetic is used within for
> calculations leading to incorrect results for input values outside the
> signed positive range.  If this happens the time of day returned is out of
> range.
> 
>  Found the problem when fiddling with the RTC and the driver where year
> was set to an unexpectedly large value like 2070, e.g.:
> 
> rtc0: setting system clock to 2070-01-01 1193046:71582832:26 UTC (3155760954)
> 
> while it should be:
> 
> rtc0: setting system clock to 2070-01-01 00:15:54 UTC (3155760954)
> 
> Changing types to unsigned fixes the problem.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  Tested on 64-bit MIPS.  Please apply.
> 
>   Maciej
> 
> patch-2.6.26-rc1-20080505-rtc-time-unsigned-11
> diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-lib.c linux-2.6.26-rc1-20080505/drivers/rtc/rtc-lib.c
> --- linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-lib.c	2007-07-10 04:56:26.000000000 +0000
> +++ linux-2.6.26-rc1-20080505/drivers/rtc/rtc-lib.c	2008-05-05 02:37:38.000000000 +0000
> @@ -51,7 +51,7 @@ EXPORT_SYMBOL(rtc_year_days);
>   */
>  void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
>  {
> -	register int days, month, year;
> +	register unsigned int days, month, year;

Does it make any sense to use the `register' keyword nowadays?

Dmitri
