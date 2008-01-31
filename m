Return-Path: <linux-kernel-owner+w=401wt.eu-S1764996AbYAaDMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764996AbYAaDMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 22:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932574AbYAaDMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 22:12:30 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:21727 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542AbYAaDM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 22:12:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VIcjw4EqZ4YxGUXBsOw4oT77vaZCiqMg+5T+e1MsR9SfdAOuVK9SQ8607NufpoeuBZIJ4zxoQpeMcMgxaVW0weuiODgNVcVcGapL/6NB3LWIH0aYBMNJBRNuTsawnx40hT5xRzJpiOL0ByK1x348G8itHjriZzjQs/t7ZfkUWkU=
Message-ID: <386072610801301912u696310d1q55e90a0d93f4f16c@mail.gmail.com>
Date: Thu, 31 Jan 2008 11:12:26 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [spi-devel-general] [PATCH 2/6] [Blackfin] SPI driver: Use SPI device name to do gpio peripheral request
Cc: "Bryan Wu" <bryan.wu@analog.com>, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801301348.43275.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201684421-26124-1-git-send-email-bryan.wu@analog.com>
	 <1201684421-26124-3-git-send-email-bryan.wu@analog.com>
	 <200801301348.43275.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 5:48 AM, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 30 January 2008, Bryan Wu wrote:
> > When got some gpio conflict, it is easy to know which SPI device driver not just got "bfin-spi"
> >
> > Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> > ---
> >  drivers/spi/spi_bfin5xx.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> > index 8fd1365..c3f9ed4 100644
> > --- a/drivers/spi/spi_bfin5xx.c
> > +++ b/drivers/spi/spi_bfin5xx.c
> > @@ -1176,7 +1176,7 @@ static int setup(struct spi_device *spi)
> >       if ((chip->chip_select_num > 0)
> >               && (chip->chip_select_num <= spi->master->num_chipselect))
> >               peripheral_request(ssel[spi->master->bus_num]
> > -                     [chip->chip_select_num-1], DRV_NAME);
> > +                     [chip->chip_select_num-1], spi->modalias);
>
> Better:  spi->dev.bus_id (always unique) not spi->modalias (isn't) ...
>

spi->dev.bus_id is just  number, while spi->modalias usually is a
string name which it is more meaningful.
In most time, modalias is easier for us to locate the gpio conflict.

Thanks
-Bryan Wu
