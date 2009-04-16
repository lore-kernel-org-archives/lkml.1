Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbZDPUyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbZDPUyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZDPUxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:53:52 -0400
Received: from n20.bullet.mail.mud.yahoo.com ([68.142.206.147]:24054 "HELO
	n20.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752867AbZDPUxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:53:51 -0400
X-Yahoo-Newman-Id: 334124.62464.bm@omp425.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IAA4Qp+4FtqqPpHcDbBYeETmGs5PrYgTRu8E+ls2aZoQ0TH/U1hELvN4Rm0StyDfOfw6JlKvAgg6eVhqGyxCUDu8qYldgRB9Mf7DFOYy74y/ljMxn116isfmonlONJrTSzeHj9W9XD/uPzbpMqRd62LlFEY4r8MXLOkPsPihyfE=  ;
X-YMail-OSG: S1az9ZwVM1mXrgoWn.QVLtu2_xYD6syFfwC38Z_QgAVKgzl57gum4XlIUb5xBeAEfgNtktwQRscgHnWjI1911STrCyABt_rRGn52h5L_Q5nrnoZSVH8fiYY2piDC10jgX0YI8LTTD_2yHj7PXnD5SegQ8hDumgHBRGE9V1vfiRDGCsKuIuy6I4MrWOyejqX5ltnQ4wNhfcV325v2Cgub.WRPykNOtXPhXk5L4Iha8dZ0zVe67YrNR5cd27KdlISrgNqPVsRY3vv2K9pH7nY3GcsolKWBxayKO62aIKWoxQYS0QbtbfVF
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] make mmci-omap using platform_driver_probe
Date: Thu, 16 Apr 2009 13:53:47 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Grazvydas Ignotas <notasas@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, Tony Lindgren <tony@atomide.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Walmsley <paul@pwsan.com>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200903280927.32786.david-b@pacbell.net> <1238694461-29501-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1238694461-29501-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904161353.48153.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 April 2009, Uwe Kleine-König wrote:
> A pointer to mmc_omap_probe which lives in .init.text is passed to the
> core via platform_driver_register and so the kernel might oops if probe
> is called after the init code is discarded.
> 
> As requested by David Brownell platform_driver_probe is used instead of
> moving the probe function to .devinit.text.  This saves some memory, but
> might have the downside that a device being registered after the call to
> mmc_omap_init but before the init sections are discarded will not be
> bound anymore to the driver.

One of the reasons I said to do it that way is that we *KNOW* it is
safe for thiis driver.  That's a non-issue; no downside.

> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Grazvydas Ignotas <notasas@gmail.com>
> Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
> Cc: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
> Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> ---
>  drivers/mmc/host/omap.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
> index 67d7b7f..004080e 100644
> --- a/drivers/mmc/host/omap.c
> +++ b/drivers/mmc/host/omap.c
> @@ -1601,7 +1601,6 @@ static int mmc_omap_resume(struct platform_device *pdev)
>  #endif
>  
>  static struct platform_driver mmc_omap_driver = {
> -	.probe		= mmc_omap_probe,
>  	.remove		= mmc_omap_remove,
>  	.suspend	= mmc_omap_suspend,
>  	.resume		= mmc_omap_resume,
> @@ -1613,7 +1612,7 @@ static struct platform_driver mmc_omap_driver = {
>  
>  static int __init mmc_omap_init(void)
>  {
> -	return platform_driver_register(&mmc_omap_driver);
> +	return platform_driver_probe(&mmc_omap_driver, mmc_omap_probe);
>  }
>  
>  static void __exit mmc_omap_exit(void)
> -- 
> tg: (5d80f8e..) t/platsection/mmc_omap_driver (depends on: linus/master)
> 
> 



