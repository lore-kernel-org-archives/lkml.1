Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZCHOVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZCHOVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 10:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZCHOVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 10:21:30 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:40720 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbZCHOVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 10:21:30 -0400
Date: Sun, 8 Mar 2009 15:21:20 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 12/13] sdhci: Add quirk for controllers with max. block
 size up to 4096 bytes
Message-ID: <20090308152120.38deb08b@mjolnir.ossman.eu>
In-Reply-To: <20090304174744.GB7477@oksana.dev.rtsoft.ru>
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
	<20090213144739.GL23889@oksana.dev.rtsoft.ru>
	<20090221165844.4f494043@mjolnir.ossman.eu>
	<20090304174744.GB7477@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-22064-1236522085-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-22064-1236522085-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Mar 2009 20:47:44 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

>=20
> I'll get rid of this particular patch, and put some BLOCK_SIZE
> magic into the writew accessor (to clean the DMA bits) instead.
>=20
> Though, I'll prepare another patch to force blksz to 2048, since
> eSDHC specifies "3" in the blksz capability bitfield, and that
> causes SDHCI core to fall back to the 512 byte blocks.
>=20

Ok.

> > After all, is it ever used?
>=20
> Not sure, maybe `dd bs=3D' can use it? A bit lazy to check this
> right now, but from the quick tests, enabling/disabling "blksz
> of 4096 bytes" doesn't cause any performance change. At least
> with the ordinary SD cards.
>=20

Memory cards will not use this (at least not with the current
standards), as the block layer thinks in 512 byte blocks. Also, the
sector size propagates to user space in a way that causes filesystems
to behave differently, making cards incompatible with all other
operating systems (i.e. if we don't use 512 byte blocks).

So the only scenario where this might be used is SDIO, and I'm not sure
such big blocks are a win there either because of the overhead of
changing block size.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-22064-1236522085-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkmz1GIACgkQ7b8eESbyJLhTfwCdEb94fpg8zMP799gEvcK6mzxd
omMAoL3BAmCZ4lBj5T91PH11e7It/950
=7CIh
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-22064-1236522085-0001-2--
