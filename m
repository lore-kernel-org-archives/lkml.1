Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbZGUW05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbZGUW05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbZGUW05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:26:57 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:33240 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbZGUW04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:26:56 -0400
X-ASG-Debug-ID: 1248215216-776701ad0000-xx1T2L
X-Barracuda-URL: http://10.68.76.222:80/cgi-bin/mark.cgi
Date: Tue, 21 Jul 2009 18:26:50 -0400 (EDT)
From: Nicolas Pitre <nico@marvell.com>
X-X-Sender: nico@xanadu.home
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Lennert Buijtenhek <buytenh@marvell.com>,
       Saeed Bishara <saeed@marvell.com>,
       =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Woodhouse <dwmw2@infradead.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
X-ASG-Orig-Subj: Re: [PATCH] register orion_nand using platform_driver_probe
Subject: Re: [PATCH] register orion_nand using platform_driver_probe
In-Reply-To: <1248209196-15705-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LFD.2.00.0907211822330.30629@xanadu.home>
References: <alpine.LFD.2.00.0907141211260.3138@xanadu.home> <1248209196-15705-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811582-1355685401-1248215215=:30629"
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1248215216
X-Barracuda-Virus-Scanned: by dakia2.marvell.com at marvell.com
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811582-1355685401-1248215215=:30629
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 21 Jul 2009, Uwe Kleine-König wrote:

> orion_nand_probe lives in .init.text, so using platform_driver_register
> to register it is wrong because binding a device after the init memory
> is discarded (e.g. via sysfs) results in an oops.
> 
> As requested by Nicolas Pitre platform_driver_probe is used instead of
> moving the probe function to .devinit.text as proposed initially.
> This saves some memory, but devices registered after the driver is
> probed are not bound (probably there are none) and binding via sysfs
> isn't possible.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Lennert Buytenhek <buytenh@marvell.com>
> Cc: Saeed Bishara <saeed@marvell.com>
> Cc: Jörn Engel <joern@logfs.org>
> Cc: Nicolas Pitre <nico@marvell.com>
> Cc: Tzachi Perelstein <tzachi@marvell.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: linux-mtd@lists.infradead.org

Acked-by: Nicolas Pitre <nico@marvell.com>

Thanks.  BTW Tzachi's email address is no longer valid.

> ---
>  drivers/mtd/nand/orion_nand.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
> index 7ad9722..cb9d13b 100644
> --- a/drivers/mtd/nand/orion_nand.c
> +++ b/drivers/mtd/nand/orion_nand.c
> @@ -171,7 +171,6 @@ static int __devexit orion_nand_remove(struct platform_device *pdev)
>  }
>  
>  static struct platform_driver orion_nand_driver = {
> -	.probe		= orion_nand_probe,
>  	.remove		= __devexit_p(orion_nand_remove),
>  	.driver		= {
>  		.name	= "orion_nand",
> @@ -181,7 +180,7 @@ static struct platform_driver orion_nand_driver = {
>  
>  static int __init orion_nand_init(void)
>  {
> -	return platform_driver_register(&orion_nand_driver);
> +	return platform_driver_probe(&orion_nand_driver, orion_nand_probe);
>  }
>  
>  static void __exit orion_nand_exit(void)
> -- 
> tg: (4b0a840..) t/platsection/orion_nand_driver (depends on: linus/master)
> 
---1463811582-1355685401-1248215215=:30629--
