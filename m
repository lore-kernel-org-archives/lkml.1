Return-Path: <linux-kernel-owner+w=401wt.eu-S936039AbYD1SFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936039AbYD1SFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935611AbYD1SFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:05:32 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40186 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935565AbYD1SFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:05:31 -0400
Date: Mon, 28 Apr 2008 21:04:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Message-ID: <20080428180457.GY2813@cs181133002.pp.htv.fi>
References: <20080428162421.GA16566@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080428162421.GA16566@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 06:24:21PM +0200, Ingo Molnar wrote:
> 
> fix build failure found via x86.git randconfig testing:
> 
>  drivers/built-in.o: In function `tda829x_attach':
>  : undefined reference to `tda827x_attach'
>  drivers/built-in.o: In function `tda829x_attach':
>  : undefined reference to `tda18271_attach'
> 
> build failure is due to this nasty dependency:
> 
>   CONFIG_DVB_CORE=m but CONFIG_TUNER_TDA8290=y.
> 
> the solution is to follow the DVB_CORE constraint in the Kconfig. It's 
> not pretty but works.


It might work around the problem in your specific configuration, but 
it's not the correct solution.

Please send your .config .


> Kconfig should be enhanced instead with a new keyword: "depends on 
> instructure ..." that makes it clear that the dependent module can only 
> be of equal or lesser link mode - but not =y while the infrastructure 
> module is =m. But i digress.


What are you smoking?

That's exactly what "depends on" always did and still does.


> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/media/Kconfig |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> Index: linux/drivers/media/Kconfig
> ===================================================================
> --- linux.orig/drivers/media/Kconfig
> +++ linux/drivers/media/Kconfig
> @@ -106,21 +106,21 @@ if VIDEO_TUNER_CUSTOMIZE
>  
>  config TUNER_XC2028
>  	tristate "XCeive xc2028/xc3028 tuners"
> -	depends on I2C && FW_LOADER
> +	depends on I2C && FW_LOADER && ((DVB_CORE = m && m) || (DVB_CORE = y))
>...


Your funny additions are equivalent to "&& DVB_CORE".


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

