Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZGVRiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZGVRiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZGVRiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:38:09 -0400
Received: from n22a.bullet.mail.mud.yahoo.com ([68.142.207.188]:21965 "HELO
	n22a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752404AbZGVRiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:38:08 -0400
X-Yahoo-Newman-Id: 991415.44936.bm@omp410.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Kim0GfnoPBCwnXDwTbBdFWT79Iq5kLyhg6XAEfmC8VxcjgrVVRxcll3HwNuLtaTzfRH6QpuA7qlhGYwM+z3jDu4hexOzXZlFRDuiGWWo3EsSZIoOWMKzMFPnlQcN4pggW48W15m82oABLZvUcgy7ptO7B17UAXv6QV17QMXmGk4=  ;
X-YMail-OSG: pJQI6zsVM1lkx46oALB11NRhXDLGxdKs5iewpdTkp15LongvBy7eBrgWXxko9H4aobj_DReJycpStYsTMhf.QbWvwX10Gf4u17dPMeOU42PUlcfY1E_R6O1xrRNlj..Wiua3AQg58ARbBeo.jYO99PS1lm2KQGnLvYF93iK6xL5a5bhhPpnIC6RJ5oFpG57wnu2p9bMxTxv4RA3VlQfh17iRaNfdXK79uytZRjRvpc_fcy.ee01wxVEcZA6LrTVEDYJuh2CI2rU0xpycyTsRdgVtJUo2qet_FDfgEqIeP_oZxOu5RFtB.v08JobmgWimZBR1.YroXiF1Chw5ZOQtDFwM
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] register mmci-omap-hs using platform_driver_probe
Date: Wed, 22 Jul 2009 10:38:07 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Jean Pihet <jpihet@mvista.com>,
       Tony Lindgren <tony@atomide.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Andy Lowe <alowe@mvista.com>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <200907111529.21165.david-b@pacbell.net> <1248208573-15171-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1248208573-15171-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907221038.08162.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, Uwe Kleine-König wrote:
> omap_mmc_probe lives in .init.text, so using platform_driver_register
> to register it is wrong because binding a device after the init memory
> is discarded (e.g. via sysfs) results in an oops.
> 
> As requested by David Brownell platform_driver_probe is used instead of
> moving the probe function to .devinit.text as proposed initially.
> This saves some memory, but devices registered after the driver is
> probed are not bound (probably there are none) and binding via sysfs
> isn't possible.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Jean Pihet <jpihet@mvista.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Pierre Ossman <drzeus@drzeus.cx>
> Cc: Andy Lowe <alowe@mvista.com>
> Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> Cc: Madhusudhan Chikkature<madhu.cr@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/mmc/host/omap_hsmmc.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 1cf9cfb..40d9830 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -1307,7 +1307,6 @@ clk_en_err:
>  #endif
>  
>  static struct platform_driver omap_mmc_driver = {
> -	.probe		= omap_mmc_probe,
>  	.remove		= omap_mmc_remove,
>  	.suspend	= omap_mmc_suspend,
>  	.resume		= omap_mmc_resume,
> @@ -1320,7 +1319,7 @@ static struct platform_driver omap_mmc_driver = {
>  static int __init omap_mmc_init(void)
>  {
>  	/* Register the MMC driver */
> -	return platform_driver_register(&omap_mmc_driver);
> +	return platform_driver_probe(&omap_mmc_driver, omap_mmc_probe);
>  }
>  
>  static void __exit omap_mmc_cleanup(void)
> -- 
> tg: (4b0a840..) t/platsection/omap_mmc_driver (depends on: linus/master)
> 
> 



