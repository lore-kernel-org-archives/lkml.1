Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbYLUNcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbYLUNcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 08:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYLUNck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 08:32:40 -0500
Received: from server.drzeus.cx ([85.8.24.28]:60558 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751833AbYLUNcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 08:32:39 -0500
Date: Sun, 21 Dec 2008 14:32:29 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 5/8] SDHCI: Samsung SDHCI (HSMMC) driver
Message-ID: <20081221143229.54a7d5ff@mjolnir.drzeus.cx>
In-Reply-To: <20081202154112.640260459@fluff.org.uk>
References: <20081202154018.906091477@fluff.org.uk>
	<20081202154112.640260459@fluff.org.uk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-23380-1229866355-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-23380-1229866355-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 02 Dec 2008 15:40:23 +0000
Ben Dooks <ben-linux@fluff.org> wrote:

> Index: linux.git/drivers/mmc/host/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.git.orig/drivers/mmc/host/Kconfig	2008-12-01 23:18:20.000000000=
 +0000
> +++ linux.git/drivers/mmc/host/Kconfig	2008-12-01 23:25:18.000000000 +0000
> @@ -48,6 +48,18 @@ config MMC_SDHCI_PCI
> =20
>  	  If unsure, say N.
> =20
> +config MMC_SDHCI_S3C
> +	tristate "SDHCI support on Samsung S3C SoC"
> +	depends on MMC_SDHCI && (PLAT_S3C24XX || PLAT_S3C64XX)
> +	help
> +	  This selects the Secure Digital Host Controller Interface (SDHCI)
> +	  often referrered to as the HSMMC block in some of the Samsung S3C
> +	  range of SoC.
> +
> +	  If you have a controller with this interface, say Y or M here.
> +
> +	  If unsure, say N.
> +
>  config MMC_RICOH_MMC
>  	tristate "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
>  	depends on MMC_SDHCI_PCI

You should probably put it under MMC_RICOH_MMC as that will become a
subentry under MMC_SDHCI_PCI.

> +static void sdhci_s3c_set_ios(struct sdhci_host *host,
> +			      struct mmc_ios *ios)
> +{
> +	struct sdhci_s3c *ourhost =3D to_s3c(host);
> +	struct s3c_sdhci_platdata *pdata =3D ourhost->pdata;
> +
> +	if (pdata->cfg_card)
> +		pdata->cfg_card(ourhost->pdev, host->ioaddr, ios);
> +}

I'm still waiting for a proper reason to allow this hook. Since you've
added this, I assume you have at least one implementation of cfg_card.
Care to include that so that I can see what it is you're trying to do?

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-23380-1229866355-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklORXIACgkQ7b8eESbyJLj8RACfSsSAWnNDGl5XFJLCh2f4soLj
ySoAn159HmNgmTpdLgL0PoIqFlClyNZ3
=k4zq
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-23380-1229866355-0001-2--
