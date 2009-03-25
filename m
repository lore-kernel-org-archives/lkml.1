Return-Path: <linux-kernel-owner+w=401wt.eu-S1762193AbZCYQZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762193AbZCYQZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758983AbZCYQYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:24:50 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:35885 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408AbZCYQYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:24:49 -0400
Date: Wed, 25 Mar 2009 17:24:41 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>, linux-kernel@vger.kernel.org
Subject: Re: MMC layer regression with single-block controllers
Message-ID: <20090325172441.26e32fe3@mjolnir.ossman.eu>
In-Reply-To: <20090325161425.GY27476@kernel.dk>
References: <20090323092802.GA30122@roarinelk.homelinux.net>
	<20090324210138.71029c2c@mjolnir.ossman.eu>
	<20090325104837.GA18389@roarinelk.homelinux.net>
	<20090325110401.GM27476@kernel.dk>
	<20090325123613.06404b17@mjolnir.ossman.eu>
	<20090325114248.GN27476@kernel.dk>
	<20090325165328.251daabb@mjolnir.ossman.eu>
	<20090325161425.GY27476@kernel.dk>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-28841-1237998284-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-28841-1237998284-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Mar 2009 17:14:25 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Mar 25 2009, Pierre Ossman wrote:
> >=20
> > The code was there previously, but it seemed a bit redundant to have
> > functionality like that in the block driver since we've already told
> > the block layer about the restrictions.
>=20
> You never saw the warnings? It's pretty clear that it does not support <
> PAGE_CACHE_SIZE blocks. It has always been so, I don't know why the
> subject says regression. I guess that is referring to a mmc layer
> regression?
>=20

Yes. The MMC code did all of this magic by itself previously and
assumed very little about the block layer.

> > The code was pretty simple. Basically it just cropped the sg list at
> > the correct place. Couldn't that be as easily done in the block layer?
>=20
> No, because if you do it transparently, then you have to keep partial
> state in the bio for completions. So it makes everything a lot more
> complex, I don't want to do that for something like this.
>=20

How is this different from the low level driver partially completing a
request, which is how it would have to be handled otherwise?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-28841-1237998284-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknKWswACgkQ7b8eESbyJLjpMACeNhF/5G++4ReMuPFAQl+Z/oD3
tuUAoOblGCY7fu/+LkpebW1iZWfJUmrd
=4m3Q
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-28841-1237998284-0001-2--
