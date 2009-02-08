Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZBHPzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZBHPzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 10:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZBHPz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 10:55:28 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:21596 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751704AbZBHPz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 10:55:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=khHp1SWU/USW92ruvcgN7qfp4aEqOf0yHlMHEgddtNAtc8sGbkeg1hQyOfrYSXfD2+a3549mQyUULoYAPUWG35J4+4MpzewCU16Ro7g3iUBnBv1YBDm18TVsSlaACgZ5TEMSPRgPpS3UZU7QVYRD0tpYYjmlyErzKMxsg9PjVXo=  ;
X-YMail-OSG: 26DQJQEVM1mFBlwGgCYs_26MCjHyhp6MstlSyZh68nJnqcSQlkhu6D25VYGR9eKemvrGmz._GVYrx.uvbVLcOI6s5RkwTIhr2Yy47eZa7siShuCMM1zSQnVz54SE5XWI237yQrQTBBiMQjru_Ds19Nacf43TU4kx1aGi_QEprGwH9FmWpxUv4wX6kNC0zwsBFQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] spi: limit reaches -1, tested 0
Date: Sun, 8 Feb 2009 07:55:26 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <498EE9C0.3010601@gmail.com>
In-Reply-To: <498EE9C0.3010601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902080755.26241.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009, Roel Kluin wrote:
> With a postfix decrement limit will reach -1 rather than 0,
> so the warning will not be issued.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>



> ---
> diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
> index 269a55e..a4652f1 100644
> --- a/drivers/spi/spi_imx.c
> +++ b/drivers/spi/spi_imx.c
> @@ -779,7 +779,7 @@ static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
>  
>  			/* Read trailing bytes */
>  			limit = loops_per_jiffy << 1;
> -			while ((read(drv_data) == 0) && limit--);
> +			while ((read(drv_data) == 0) && --limit);
>  
>  			if (limit == 0)
>  				dev_err(&drv_data->pdev->dev,
> 
> 


