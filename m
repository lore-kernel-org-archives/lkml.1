Return-Path: <linux-kernel-owner+w=401wt.eu-S1763108AbZGABjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763108AbZGABjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758386AbZGABjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:39:35 -0400
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:40858 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757146AbZGABje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:39:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NewaKD4dMIGemBF+yWAWxTRSu5RJmbBeg8QCuJNDEUqEIm56t2G/XcVr9klt+g+eRRBJfUrnzHWbFhSm3tM8FrsyX1dKxQPPu5GA3w9E6xgG5eQHgZ4Z/3WTpicLbq0dTEH6U3LUXBqiSVOWS0WhUIWVqPua7lTYFCv2YiAL7Xo=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: lRl_G8MVM1lr_lb0AhEI64ERDxSpSAbfNwFr0CH5z9cNvU6U_rYeHt3tLYjJiG1frmo9fsWBKepm7tzEWmny56NdaNXTQAjsgbtdX35oaT30j5VDiJ46of5IXSAWPE9zmOJ5wuu9SG0dA1F1tCJyZu95V3Aa3n6nj.0R4rj4Kj4i.gVouPAbC1Ec0V7QTOBPiYxNfM.2AL1MStorqDu0Bpfemwj6PWsMy8U8zkfD8cz4v6Mk2ZNGVI53VVqEaz43vP8B41R.5CrRrhH.6MKhs8nFb3j86knIcV9X3MadnRSuJbc-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] [drivers] [SPI] SPI_GPIO: add support for controllers without MISO or MOSI pin
Date: Tue, 30 Jun 2009 18:39:13 -0700
User-Agent: KMail/1.9.10
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net, kyungmin.park@samsung.com
References: <000a01c9f61f$fd7ff3d0$f87fdb70$%szyprowski@samsung.com>
In-Reply-To: <000a01c9f61f$fd7ff3d0$f87fdb70$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906301839.13764.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 June 2009, Marek Szyprowski wrote:
> --- a/drivers/spi/spi_bitbang.c
> +++ b/drivers/spi/spi_bitbang.c
> @@ -392,6 +392,22 @@ int spi_bitbang_transfer(struct spi_device *spi, struct spi_message *m)
>         unsigned long           flags;
>         int                     status = 0;
>  
> +       if (spi->master->flags & SPI_MASTER_NO_RX) {
> +               struct spi_transfer *xfer;
> +               list_for_each_entry(xfer, &m->transfers, transfer_list) {
> +                       if (xfer->rx_buf)
> +                               return -EINVAL;
> +               }
> +       }

Actually these two loops should merge, and likely move with
spi_async() into the spi.c core code ... I'll split this
support into a separate patch.

> +
> +       if (spi->master->flags & SPI_MASTER_NO_TX) {
> +               struct spi_transfer *xfer;
> +               list_for_each_entry(xfer, &m->transfers, transfer_list) {
> +                       if (xfer->tx_buf)
> +                               return -EINVAL;
> +               }
> +       }
> +
>         m->actual_length = 0;
>         m->status = -EINPROGRESS;
>  


