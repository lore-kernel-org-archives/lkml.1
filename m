Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbZBUP7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbZBUP7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 10:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbZBUP6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 10:58:52 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:50459 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbZBUP6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 10:58:51 -0500
Date: Sat, 21 Feb 2009 16:58:44 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Arnd Bergmann <arnd@arndb.de>, Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 12/13] sdhci: Add quirk for controllers with max. block
 size up to 4096 bytes
Message-ID: <20090221165844.4f494043@mjolnir.ossman.eu>
In-Reply-To: <20090213144739.GL23889@oksana.dev.rtsoft.ru>
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
	<20090213144739.GL23889@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-15490-1235231929-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-15490-1235231929-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Feb 2009 17:47:39 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> @@ -831,7 +832,12 @@ static void sdhci_prepare_data(struct sdhci_host *ho=
st, struct mmc_data *data)
>  	sdhci_set_transfer_irqs(host);
> =20
>  	/* We do not handle DMA boundaries, so set it to max (512 KiB) */
> -	sdhci_writew(host, SDHCI_MAKE_BLKSZ(7, data->blksz), SDHCI_BLOCK_SIZE);
> +	if (host->quirks & SDHCI_QUIRK_MAX_BLK_SZ_4096)
> +		blksz =3D data->blksz;
> +	else
> +		blksz =3D SDHCI_MAKE_BLKSZ(7, data->blksz);
> +
> +	sdhci_writew(host, blksz, SDHCI_BLOCK_SIZE);
>  	sdhci_writew(host, data->blocks, SDHCI_BLOCK_COUNT);
>  }
> =20

Hmm.. I seem to have overlooked this part previously. I guess they've
basically stripped out the DMA boundary stuff and used the bits for
other things?

At this point I'm leaning more towards simply not supporting their
extended block size. After all, is it ever used?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-15490-1235231929-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkmgJLkACgkQ7b8eESbyJLjhyACaA8FHr1u1aWy6/2W+aqlFgHWe
8YYAn32H12Pi4hPcFacaLNuTBGNDdDgi
=Vynl
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-15490-1235231929-0001-2--
