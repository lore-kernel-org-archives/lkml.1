Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbYEXCft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbYEXCft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 22:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbYEXCfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 22:35:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50665 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757288AbYEXCfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 22:35:39 -0400
Date: Sat, 24 May 2008 12:35:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
       Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] mmc: add OpenFirmware bindings for the mmc_spi
 driver
Message-Id: <20080524123527.04794974.sfr@canb.auug.org.au>
In-Reply-To: <20080523182842.GB469@polina.dev.rtsoft.ru>
References: <20080523182754.GA26891@polina.dev.rtsoft.ru>
	<20080523182842.GB469@polina.dev.rtsoft.ru>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__24_May_2008_12_35_27_+1000__xk2Yif9FDYTnlQy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__24_May_2008_12_35_27_+1000__xk2Yif9FDYTnlQy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

On Fri, 23 May 2008 22:28:42 +0400 Anton Vorontsov <avorontsov@ru.mvista.co=
m> wrote:
>
> +++ b/drivers/mmc/host/of_mmc_spi.c

> +static int of_mmc_spi_probe(struct spi_device *spi)

> +	/*
> +	 * mmc_spi_probe will use drvdata, so we can't use it. Use node's
> +	 * data instead.
> +	 */
> +	spi->dev.archdata.of_node->data =3D oms;

If you delay this assignment, you may not have to clean it up in the
error path.

> +	ocr_mask =3D of_get_property(np, "linux,mmc-ocr-mask", &size);

You should really explicitly include linux/of.h to use of_get_property etc

> +int __devexit of_mmc_spi_remove(struct spi_device *spi)
> +{
> +	struct of_mmc_spi *oms =3D spi->dev.archdata.of_node->data;
> +	int ret;
> +
> +	ret =3D mmc_spi_remove(spi);
> +	if (ret)
> +		return ret;

Maybe you should do this last so that you don't leak more than necessary
if mmc_spi_remove fails.  (I don't know what state mmc_spi_remove leaves
stuff in if it fails ...)

> +static struct spi_driver of_mmc_spi_driver =3D {
> +	.driver =3D {
> +		.name =3D "of_mmc_spi",
> +		.bus =3D &spi_bus_type,

This is initialised by spi_register_driver().

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__24_May_2008_12_35_27_+1000__xk2Yif9FDYTnlQy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIN370TgG2atn1QN8RAsnyAJ4+U5d39q5m5og1in7YRTCjl4SelwCglWgp
BkupoItpG1foUF/ec/46xYE=
=q6d8
-----END PGP SIGNATURE-----

--Signature=_Sat__24_May_2008_12_35_27_+1000__xk2Yif9FDYTnlQy--
