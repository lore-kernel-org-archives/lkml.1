Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZFCGdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZFCGdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZFCGdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:33:47 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:35747 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZFCGdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:33:46 -0400
Date: Wed, 3 Jun 2009 08:33:41 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Speed of SDHCI subsystem
Message-ID: <20090603083341.7a2c84c8@mjolnir.ossman.eu>
In-Reply-To: <20090519003750.461abe7d@werewolf.home>
References: <20090519003750.461abe7d@werewolf.home>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-24685-1244010826-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-24685-1244010826-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 19 May 2009 00:37:50 +0200
"J.A. Magall=C3=B3n" <jamagallon@ono.com> wrote:

> Hi all...
>=20
> I have notice something strange with SD cards.
> I have an Aspire One and had an 8Gb SDHC card that used for my home,
> and have recently upgraded to a 16Gb one.
> This new one came with an USB reader.
>=20
> The thing is that cards look much faster when accessed through the USB
> key that directly on the readers of the One.
>=20
> Some numbers with hdparm:
>=20
> TakeMS 8Gb Class 6:
> 	Gives 10MB/s on the slot, 17MB/s via the USB key
> SanDisk UltraII 16Gb, Class 4, advertised as 15Mb/s:
> 	Gives 10MB/s on the slot, 14MB/s on USB
>=20
> I know that hdparm is not a benchmark, but I supposed it should be
> limited by the media, not the connection.
>=20
> But somehow the SDHCI/MMC subsystem seems to be stuck at 10MB/s, independ=
ent
> of the quality of the media.
>=20
> Any ideas ?
>=20

Given your numbers I'd guess that your USB reader supports high-speed
and your built-in one does not. The theoretical throughput without
high-speed is 12.5 MB/s (SI-prefix). With some overhead, and the fact
that many controllers have a lower maximum frequency than 25 MHz, makes
your 10 MB/s pretty reasonable.

For reference, I've managed to achieve ~23 MB/s using a Sandisk Extreme
III card and a JMicron controller, so there doesn't seem to be any
major inherent bottle necks in the MMC stack.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-24685-1244010826-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkomGUkACgkQ7b8eESbyJLg6pQCePbZ857H5ZjxXlkOLsgP7kq6q
qGgAn2W0vlHCSaKlFtFXEnkErijCF2Ux
=bb+d
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-24685-1244010826-0001-2--
