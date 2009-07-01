Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZGAG6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZGAG6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 02:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZGAG6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 02:58:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41314 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbZGAG6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 02:58:13 -0400
Date: Wed, 01 Jul 2009 08:57:50 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] [drivers] [SPI] SPI_GPIO: add support for controllers
 without MISO or MOSI pin
In-reply-to: <200906301839.13764.david-b@pacbell.net>
To: "'David Brownell'" <david-b@pacbell.net>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net, kyungmin.park@samsung.com,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <000101c9fa19$44051540$cc0f3fc0$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 8BIT
Thread-index: Acn57NIk+CNcABZzRiisPDMCPVXqgQAK/IdQ
References: <000a01c9f61f$fd7ff3d0$f87fdb70$%szyprowski@samsung.com>
 <200906301839.13764.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday, July 01, 2009 3:39 AM, David Brownell wrote:

> > --- a/drivers/spi/spi_bitbang.c
> > +++ b/drivers/spi/spi_bitbang.c
> > @@ -392,6 +392,22 @@ int spi_bitbang_transfer(struct spi_device *spi, struct spi_message *m)
> >         unsigned long           flags;
> >         int                     status = 0;
> >
> > +       if (spi->master->flags & SPI_MASTER_NO_RX) {
> > +               struct spi_transfer *xfer;
> > +               list_for_each_entry(xfer, &m->transfers, transfer_list) {
> > +                       if (xfer->rx_buf)
> > +                               return -EINVAL;
> > +               }
> > +       }
> 
> Actually these two loops should merge, and likely move with
> spi_async() into the spi.c core code ... I'll split this
> support into a separate patch.

Ok. 

I created two separate loops because I thought that it will be faster, especially when the check must be done for each transfer
message request.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



