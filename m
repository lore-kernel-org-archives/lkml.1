Return-Path: <linux-kernel-owner+w=401wt.eu-S1763316AbZCYPxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763316AbZCYPxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbZCYPxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:53:39 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:60499 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250AbZCYPxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:53:38 -0400
Date: Wed, 25 Mar 2009 16:53:28 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>, linux-kernel@vger.kernel.org
Subject: Re: MMC layer regression with single-block controllers
Message-ID: <20090325165328.251daabb@mjolnir.ossman.eu>
In-Reply-To: <20090325114248.GN27476@kernel.dk>
References: <20090323092802.GA30122@roarinelk.homelinux.net>
	<20090324210138.71029c2c@mjolnir.ossman.eu>
	<20090325104837.GA18389@roarinelk.homelinux.net>
	<20090325110401.GM27476@kernel.dk>
	<20090325123613.06404b17@mjolnir.ossman.eu>
	<20090325114248.GN27476@kernel.dk>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-28722-1237996412-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-28722-1237996412-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Mar 2009 12:42:48 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Mar 25 2009, Pierre Ossman wrote:
> >=20
> > That's an annoying limitation and sort of defeats the purpose of
> > specifying a maximum sector count. Why can't it go below 8?
>=20
> Because it would add all sorts of complexity for handling 4kb block size
> file systems on top of the block device. The bio_add_page() api depends
> on being able to add a single page at least, it has to or you would need
> to push that complexity to the callers.
>=20

Requests going in into the block layer and requests coming out aren't
that strongly coupled, so I don't see it of that much of a stretch to
expect this to be handled.

> So it's annoying, but you have to do the incremental completions
> yourself for the (obscure) device that doesn't do more than 512b
> transfers. It's really not that difficult, and it would be simpler than
> supporting partial completions generically in the block layer.

The code was there previously, but it seemed a bit redundant to have
functionality like that in the block driver since we've already told
the block layer about the restrictions.

The code was pretty simple. Basically it just cropped the sg list at
the correct place. Couldn't that be as easily done in the block layer?

>=20
> Saying that it defeats the purpose of the setting is missing the bigger
> picture - basically all other devices, that have sane limits (like 128k,
> or whatnot).
>=20

I suppose. But it makes the feature completely useless for MMC as it
has to implement it's own cropping of requests anyway.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-28722-1237996412-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknKU3oACgkQ7b8eESbyJLiuDgCgxqVjrbesmriJNYGmxOwEBguP
XBYAnjsRFGWMEN6p3I4r3hroOQRwrswv
=kRpR
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-28722-1237996412-0001-2--
