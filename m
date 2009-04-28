Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbZD1Tiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbZD1Tiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZD1Tij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:38:39 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:40367 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbZD1Tii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:38:38 -0400
Date: Tue, 28 Apr 2009 21:38:33 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Tony Lindgren <tony@atomide.com>
Cc: "Gadiyar, Anand" <gadiyar@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] OMAP: HSMMC: Do not enable buffer ready interrupt if
 using DMA
Message-ID: <20090428213833.18afbba0@mjolnir.ossman.eu>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB02FB2F2A90@dbde02.ent.ti.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02FB2F2A90@dbde02.ent.ti.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-7766-1240947514-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-7766-1240947514-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Jarkko? Tony?

On Tue, 21 Apr 2009 13:09:22 +0530
"Gadiyar, Anand" <gadiyar@ti.com> wrote:

> From: Anand Gadiyar <gadiyar@ti.com>
>=20
> OMAP: HSMMC: Do not enable buffer ready interrupt if using DMA
>=20
> This considerably reduces the number of interrupts during a transfer
> and ought to result in some power saving.
>=20
> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Acked-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
> ---
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index e62a22a..2d83807 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -70,6 +70,8 @@
>  #define DTO_MASK		0x000F0000
>  #define DTO_SHIFT		16
>  #define INT_EN_MASK		0x307F0033
> +#define BWR_ENABLE		(1 << 4)
> +#define BRR_ENABLE		(1 << 5)
>  #define INIT_STREAM		(1 << 1)
>  #define DP_SELECT		(1 << 21)
>  #define DDIR			(1 << 4)
> @@ -241,7 +243,12 @@ mmc_omap_start_command(struct mmc_omap_host *host, s=
truct mmc_command *cmd,
>  	 */
>  	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
>  	OMAP_HSMMC_WRITE(host->base, ISE, INT_EN_MASK);
> -	OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
> +
> +	if (host->use_dma)
> +		OMAP_HSMMC_WRITE(host->base, IE,
> +				 INT_EN_MASK & ~(BRR_ENABLE | BWR_ENABLE));
> +	else
> +		OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
> =20
>  	host->response_busy =3D 0;
>  	if (cmd->flags & MMC_RSP_PRESENT) {


--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-7766-1240947514-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkn3WzsACgkQ7b8eESbyJLgNnACg2R3hBqIGqBmYVD+IksF/B+l+
19sAoLfrXO//XciTOlBTGI94jVDoiMww
=ZMZQ
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-7766-1240947514-0001-2--
