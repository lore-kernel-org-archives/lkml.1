Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZK3Mju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZK3Mju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZK3Mjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:39:49 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:44686 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbZK3Mjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:39:48 -0500
Date: Mon, 30 Nov 2009 13:39:49 +0100
From: Pierre Ossman <pierre@ossman.eu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ben Hutchings <ben@decadent.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, 504391@bugs.debian.org,
       Wouter van Heyst <larstiq@larstiq.dyndns.org>
Subject: Re: [PATCH] mmc: add module parameter to set whether cards are
 assumed removable
Message-ID: <20091130133949.794fef00@mjolnir.ossman.eu>
In-Reply-To: <4B02565C.1030406@s5r6.in-berlin.de>
References: <1257914676.2237.57.camel@localhost>
	<20091116122329.847916b6.akpm@linux-foundation.org>
	<1258410709.2792.9.camel@localhost>
	<4B02565C.1030406@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-29976-1259584796-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-29976-1259584796-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Nov 2009 08:53:00 +0100
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Ben Hutchings wrote:
> > In general, it is not possible to tell whether a card present in an MMC
> > slot after resume is the same that was there before suspend.
>=20
> That's true for virtually all storage devices, not just MMC.
>=20
> > So there are two possible behaviours, each of which will cause data
> > loss in some cases:
> >=20
> > CONFIG_MMC_UNSAFE_RESUME=3Dn (default): Cards are assumed to be removed
> > during suspend.  Any filesystem on them must be unmounted before
> > suspend; otherwise, buffered writes will be lost.
> >=20
> > CONFIG_MMC_UNSAFE_RESUME=3Dy: Cards are assumed to remain present during
> > suspend.  They must not be swapped during suspend; otherwise, buffered
> > writes will be flushed to the wrong card.
> >=20
> > Currently the choice is made at compile time and this allows that to be
> > overridden at module load time.
>=20
> Can't the kernel flush the write buffer at suspend time, so that you can
> remove this choice for good?

I'm afraid that's insufficient. What it would need to do is to is
flush everything (to make sure what's on disk matches what's in
memory), but also read back the filesystem on resume to verify that
nothing else modified it (i.e. making sure what's on disk still matches
what's in memory).

Another way of putting it is that the kernel needs to umount/mount
around suspend in a way that's transparent to users of the filesystem.

Until we have such a system in place then everything will be hacks
which only shift around the problem.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-29976-1259584796-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAksTvRcACgkQ7b8eESbyJLiMGgCfVpmnb/sdZcz4qn+TFVfkfILI
OvEAmwfjDQUPebeN2Iv/ThmnXXfMswKm
=o000
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-29976-1259584796-0001-2--
