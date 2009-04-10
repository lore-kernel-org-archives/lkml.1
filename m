Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbZDJVgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbZDJVgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 17:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZDJVfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 17:35:53 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:59975 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbZDJVfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 17:35:52 -0400
Date: Fri, 10 Apr 2009 23:35:46 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: =?UTF-8?B?Sm9zw6kgTWFyw63CrWEgRmVybsOhbmRleiBHb256w6FsZXo=?= 
	<josemariafg@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: Some microSD cards are not recognized by
 PCIxx12 SDA controller
Message-ID: <20090410233546.7e8ca52b@mjolnir.ossman.eu>
In-Reply-To: <49DA9094.1070803@gmail.com>
References: <49B5C091.3090303@gmail.com>
	<20090324211748.30cd7429@mjolnir.ossman.eu>
	<49C9E4B8.3000708@gmail.com>
	<20090325171749.62bd0fbb@mjolnir.ossman.eu>
	<49CBAF36.1010203@gmail.com>
	<20090405203317.72ce6aff@mjolnir.ossman.eu>
	<49DA9094.1070803@gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-20157-1239399347-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-20157-1239399347-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 07 Apr 2009 01:30:28 +0200
Jos=C3=A9 Mar=C3=AD=C2=ADa Fern=C3=A1ndez Gonz=C3=A1lez <josemariafg@gmail.=
com> wrote:

> It is curious. I have concentrated my tests on 2.6.29 with HZ=3D100 and n=
o preemption, and I have done next tests with my microSD card and laptop:
>=20
> *	mmc_delay(2) -> FAIL
> *	mdelay(2) -> FAIL
> *	mmc_delay(10) -> Works!
> *	mdelay(10) -> Works!
>=20

Looks good. Although it would have been nice to also know exactly when
it starts working.

> And by mistake I found that:
>=20
> *	msleep(2) -> Works!
>=20

This is the scheduling effect I was talking about. Basically you can
never get msleep() to delay shorter than 1/HZ seconds.

I'll queue up your patch.

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

--=_freyr.ossman.eu-20157-1239399347-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknfu7UACgkQ7b8eESbyJLjlAwCfdcLEXdDGfZfbph5TnA5114yK
nucAoJKm4NprZz3jSL1fywRe+qAeDhQm
=s6zC
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-20157-1239399347-0001-2--
