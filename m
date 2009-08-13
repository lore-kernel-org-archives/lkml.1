Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbZHMLPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbZHMLPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 07:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbZHMLPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 07:15:07 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:51965 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbZHMLPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 07:15:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IjY91A3/AFy1bx4G+Jy4gd0PM2oV4q4m7tFTlKESaHf6kXsY9zuFOjkEcq45xxj8lL
         lBN9eWG/a5fMXIkWT1o+ytZImSuqwcrVTZUFane9QciZ8VdupRTymBtgPy0GJFcwmE5p
         B68Y1ihLV8H+TvvpgEcIqGtaR/2uRqYu3UaaE=
MIME-Version: 1.0
In-Reply-To: <20090729134231.515027738@de.ibm.com>
References: <20090729134125.313191633@de.ibm.com>
	 <20090729134231.515027738@de.ibm.com>
Date: Thu, 13 Aug 2009 13:15:06 +0200
Message-ID: <63386a3d0908130415x76993440ifd38e4bcb6a1d07e@mail.gmail.com>
Subject: Re: [RFC][patch 10/12] move NTP adjusted clock multiplier to struct 
	timekeeper
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Daniel Walker <dwalker@fifo99.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/29 Martin Schwidefsky <schwidefsky@de.ibm.com>:

> Index: linux-2.6/arch/arm/plat-omap/common.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/plat-omap/common.c
> +++ linux-2.6/arch/arm/plat-omap/common.c
> @@ -256,7 +256,7 @@ unsigned long long sched_clock(void)
>        unsigned long long ret;
>
>        ret = (unsigned long long)clocksource_32k.read(&clocksource_32k);
> -       ret = (ret * clocksource_32k.mult_orig) >> clocksource_32k.shift;
> +       ret = (ret * clocksource_32k.mult) >> clocksource_32k.shift;

Doesn't the overall effect of your patch mean that the above can simply be
replaced by

ret = cyc2ns(&clocksource_32k, ret);

Or clocksource_cyc2ns() if that was renamed (I don't have the entire
picture here...)

>        return ret;
>  }

Yours,
Linus Walleij
