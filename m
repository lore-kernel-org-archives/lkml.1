Return-Path: <linux-kernel-owner+w=401wt.eu-S937054AbYD1TtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937054AbYD1TtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932120AbYD1Tsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:48:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765346AbYD1Tsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:48:52 -0400
Date: Mon, 28 Apr 2008 16:47:30 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Message-ID: <20080428164730.43349c3d@gaivota>
In-Reply-To: <20080428162421.GA16566@elte.hu>
References: <20080428162421.GA16566@elte.hu>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 18:24:21 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> fix build failure found via x86.git randconfig testing:
> 
>  drivers/built-in.o: In function `tda829x_attach':
>  : undefined reference to `tda827x_attach'
>  drivers/built-in.o: In function `tda829x_attach':
>  : undefined reference to `tda18271_attach'

>  config TUNER_XC2028
>  config TUNER_MT20XX
>  config TUNER_TEA5761
>  config TUNER_TEA5767
>  config TUNER_SIMPLE
>  config TUNER_TDA9887

Hmm... if the issues are with tda827x and tda18271, why have you touched on the above drivers?
I can't see why the above tuners would need DVB.

>  config TUNER_TDA8290
>  	tristate "TDA 8290/8295 + 8275(a)/18271 tuner combo"
> -	depends on I2C
> +	depends on I2C && ((DVB_CORE = m && m) || (DVB_CORE = y))
>  	select DVB_TDA827X
>  	select DVB_TDA18271
>  	default m if VIDEO_TUNER_CUSTOMIZE

Ok, this one may be broken.

I'm working on some changes that will hopefully fix this issue at the proper way.

Cheers,
Mauro
