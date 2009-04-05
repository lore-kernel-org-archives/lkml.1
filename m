Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207AbZDESeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbZDESeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 14:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZDESdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 14:33:55 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:34012 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbZDESdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 14:33:55 -0400
Date: Sun, 5 Apr 2009 20:33:17 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: =?UTF-8?B?Sm9zw6kgTWFyw63CrWEgRmVybsOhbmRleiBHb256w6FsZXo=?= 
	<josemariafg@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: Some microSD cards are not recognized by
 PCIxx12 SDA controller
Message-ID: <20090405203317.72ce6aff@mjolnir.ossman.eu>
In-Reply-To: <49CBAF36.1010203@gmail.com>
References: <49B5C091.3090303@gmail.com>
	<20090324211748.30cd7429@mjolnir.ossman.eu>
	<49C9E4B8.3000708@gmail.com>
	<20090325171749.62bd0fbb@mjolnir.ossman.eu>
	<49CBAF36.1010203@gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-21100-1238956401-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-21100-1238956401-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Mar 2009 17:37:10 +0100
Jos=C3=A9 Mar=C3=AD=C2=ADa Fern=C3=A1ndez Gonz=C3=A1lez <josemariafg@gmail.=
com> wrote:

> Pierre Ossman wrote:
> > On Wed, 25 Mar 2009 09:00:56 +0100
> > Jos=C3=A9 Mar=C3=AD=C2=ADa Fern=C3=A1ndez Gonz=C3=A1lez <josemariafg@gm=
ail.com> wrote:
> >=20
> >> As I'm going to install 2.6.29 today, I can test the patch with it and=
 HZ=3D100.
> >=20
> > Please do. And try to determine where it breaks. I'd prefer if we don't
> > need to increase this yet again in a month because we were relying on
> > some scheduling latencies. :)
> >=20
> > Rgds
>=20
> I have been testing the patch with kernel 2.6.29 and a couple of cards (t=
he Transcend 2GB microSD and a EZ Memory 8GB SDHC) in a few cases:
>=20
> *	HZ=3D300 + tickless + desktop preemption
> *	HZ=3D100 + tickless + desktop preemption
> *	HZ=3D100 + desktop preemption
> *	HZ=3D100 + low latency desktop preemption
> *	HZ=3D1000 + tickless + desktop preemption
>=20
> and it worked with no problem. I don't know if I have forgotten any obvio=
us corner case. Perhaps I should have tested with no preemption...
>=20

All of them will result in a sleep though. Preferably, I'd like to now
the minimum delay you need to get things working. Change from
mmc_delay() to mdelay() to make sure there aren't any sleeps (which
generally take quite some time to complete).

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-21100-1238956401-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknY+XEACgkQ7b8eESbyJLgEOwCfb8n+Igwa9rp0YHQENyauTco6
p/sAoL66tzud4KanwK2iyvJ81T2leY5q
=Ywvu
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-21100-1238956401-0001-2--
