Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbZK3NJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbZK3NJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 08:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZK3NJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 08:09:27 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:53209 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbZK3NJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 08:09:26 -0500
Date: Mon, 30 Nov 2009 14:09:28 +0100
From: Pierre Ossman <pierre@ossman.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Ben Hutchings <ben@decadent.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, 504391@bugs.debian.org,
       Wouter van Heyst <larstiq@larstiq.dyndns.org>
Subject: Re: [PATCH] mmc: add module parameter to set whether cards are
 assumed removable
Message-ID: <20091130140928.29d847a4@mjolnir.ossman.eu>
In-Reply-To: <20091130125405.541a6a01@lxorguk.ukuu.org.uk>
References: <1257914676.2237.57.camel@localhost>
	<20091116122329.847916b6.akpm@linux-foundation.org>
	<1258410709.2792.9.camel@localhost>
	<4B02565C.1030406@s5r6.in-berlin.de>
	<20091130133949.794fef00@mjolnir.ossman.eu>
	<20091130125405.541a6a01@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-30097-1259586574-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-30097-1259586574-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Nov 2009 12:54:05 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>=20
> For most file systems it is sufficient to check the superblock related
> information. So we'd need an fs->ops->validate_media() or somesuch but it
> wouldn't be that horrific or need to do much I/O in most cases.
>=20
> You could defeat that by being really stupid, but the purpose of the
> check isn't a stupidity filter but to stop accidents happening in normal
> use.
>=20

Agreed. Something like that would more or less solve the issue. Someone
just needs to write the code for all (or most) filesystems.

> > Another way of putting it is that the kernel needs to umount/mount
> > around suspend in a way that's transparent to users of the filesystem.
>=20
> No. The kernel needs to push stuff to media on suspend (which is good
> manners anyway), and validate on resume. if the validate fails you mark
> the media as changed and the block layer will already see to it that
> everything gets aborted as it already does with a truely removable device.
>=20
> In fact if you did this by media serial numbers and idents you don't even
> need the fs hook, although it would certainly be safer that way.
>=20

The hardware driver layer can only check if it's the same device being
plugged in, not if someone has done something with it during suspend,
so I see no other way than solving this in the filesystem layer.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-30097-1259586574-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAksTxAoACgkQ7b8eESbyJLiOTwCZAURNSM8OzfC52PG04SDEhVn/
+MYAn1HE5x/7zNFtGGWp2aysmTZGBCMT
=PtPp
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-30097-1259586574-0001-2--
