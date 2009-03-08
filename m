Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbZCHOLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbZCHOLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 10:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZCHOL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 10:11:28 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:33423 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbZCHOL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 10:11:28 -0400
Date: Sun, 8 Mar 2009 15:11:21 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 05/13] sdhci: Add support for card-detection polling
Message-ID: <20090308151121.291f1abb@mjolnir.ossman.eu>
In-Reply-To: <20090304174917.GD7477@oksana.dev.rtsoft.ru>
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
	<20090213144718.GE23889@oksana.dev.rtsoft.ru>
	<20090221165821.1239aa5a@mjolnir.ossman.eu>
	<20090304174917.GD7477@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-21533-1236521483-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-21533-1236521483-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Mar 2009 20:49:17 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> On Sat, Feb 21, 2009 at 04:58:21PM +0100, Pierre Ossman wrote:
> > Just modify the if-clause and
> > things will work.
>=20
> That would look horrid...
>=20
>         if ((!(host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION) &&
>                         !(sdhci_readl(host, SDHCI_PRESENT_STATE) &
>                                 SDHCI_CARD_PRESENT)) ||
>                         (host->flags & SDHCI_DEVICE_DEAD)) {
>=20

There are worse ones in that code, but I see your point. :)

> > Might want to add a comment also to make it more obvious what the
> > if-clause does.
>=20
> Let's try to avoid the if-clause above? How about this:
>=20

Looks ok.

> @@ -1096,6 +1099,7 @@ out:
>  static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
>  {
>  	struct sdhci_host *host;
> +	bool present;
>  	unsigned long flags;
> =20
>  	host =3D mmc_priv(mmc);

Can we use bool in the kernel?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-21533-1236521483-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkmz0gsACgkQ7b8eESbyJLgkcgCeNGAc+jwH2/4ht5XKRKv86kIT
ZiQAn0a0K9B2vrmq6hxq8rXLf/sb0qkc
=1YEC
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-21533-1236521483-0001-2--
