Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbXHTCCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbXHTCCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 22:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXHTCCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 22:02:09 -0400
Received: from smtp104.sbc.mail.re2.yahoo.com ([68.142.229.101]:45660 "HELO
	smtp104.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751365AbXHTCCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 22:02:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HFnCLa6HImrXrzwHH+8lRbIRDroTzfSJgMbIYE6h+/g8AlPyPGzH3WcfYx/zQEygWRoccZ1dn48s/swPq80zZoGTTHoKl0DFlwAqwTCArdjMWca509hMuAFUDTgeOf2pcBkvtPp+2sirryFGVmQEKwn+Hdu6KNRGhk7UHzTBQx8=  ;
X-YMail-OSG: s306MVcVM1nMiN5r66msaIFi6AgvnOF_NEAVqpG0qUVJhR5YtIDdezrWvV638lcM1RoAPS27hA--
From: David Brownell <david-b@pacbell.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] rtc: Make rtc-rs5c348 driver hotplug-aware (take 2)
Date: Sun, 19 Aug 2007 18:49:16 -0700
User-Agent: KMail/1.9.6
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, ralf@linux-mips.org
References: <20070819.223210.21590535.anemo@mba.ocn.ne.jp>
In-Reply-To: <20070819.223210.21590535.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708191849.16648.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2007, Atsushi Nemoto wrote:
> The rtc-rs5c348 SPI driver name doesn't match its module name, which
> prevents it from properly hotplugging.  There is only one in-tree user
> of its driver, which is fixed by this patch too.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

ACK.

> ---
>  arch/mips/tx4938/toshiba_rbtx4938/setup.c |    2 +-
>  drivers/rtc/rtc-rs5c348.c                 |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/mips/tx4938/toshiba_rbtx4938/setup.c b/arch/mips/tx4938/toshiba_rbtx4938/setup.c
> index 57f3c70..84ebff7 100644
> --- a/arch/mips/tx4938/toshiba_rbtx4938/setup.c
> +++ b/arch/mips/tx4938/toshiba_rbtx4938/setup.c
> @@ -1115,7 +1115,7 @@ static void __init txx9_spi_init(unsigned long base, int irq)
>  static int __init rbtx4938_spi_init(void)
>  {
>  	struct spi_board_info srtc_info = {
> -		.modalias = "rs5c348",
> +		.modalias = "rtc-rs5c348",
>  		.max_speed_hz = 1000000, /* 1.0Mbps @ Vdd 2.0V */
>  		.bus_num = 0,
>  		.chip_select = 16 + SRTC_CS,
> diff --git a/drivers/rtc/rtc-rs5c348.c b/drivers/rtc/rtc-rs5c348.c
> index f50f3fc..8394626 100644
> --- a/drivers/rtc/rtc-rs5c348.c
> +++ b/drivers/rtc/rtc-rs5c348.c
> @@ -226,7 +226,7 @@ static int __devexit rs5c348_remove(struct spi_device *spi)
>  
>  static struct spi_driver rs5c348_driver = {
>  	.driver = {
> -		.name	= "rs5c348",
> +		.name	= "rtc-rs5c348",
>  		.bus	= &spi_bus_type,
>  		.owner	= THIS_MODULE,
>  	},
> 


