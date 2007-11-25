Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbXKYUBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbXKYUBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 15:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbXKYUBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 15:01:41 -0500
Received: from mx33.mail.ru ([194.67.23.194]:4042 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbXKYUBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 15:01:40 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.24: Serial disabled in BIOS but serial modules still loaded (probably PnP related)
Date: Sun, 25 Nov 2007 23:01:33 +0300
User-Agent: KMail/1.9.7
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <fa.P01QcmUf2f3DN4etI8KJYFdaLnE@ifi.uio.no> <4749C15C.6020805@shaw.ca>
In-Reply-To: <4749C15C.6020805@shaw.ca>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart25451413.2so2eWPT9s";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711252301.34503.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart25451413.2so2eWPT9s
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 25 November 2007, Robert Hancock wrote:
> Andrey Borzenkov wrote:
> > I have no COM port on notebook (without port replicator which I do not =
have)
> > so COM is disabled in BIOS. No ttyS* is detected during boot (and no de=
vice
> > created) but I just noticed that serial modules are still loaded. Well,=
 this
> > partially defeats the purpose of disabling COM port - the intention was=
 to
> > free resources by *not* loading unneeded modules ...
> >=20
> > This may have something to do with (ACPI) PnP which apparently believes=
 COM is alive.
> > Notebook is Toshiba Portege 4000.
>=20
> Probably a BIOS bug. It still lists the port in PnP data even though the=
=20
> hardware is disabled, so the kernel still tries to load the serial=20
> driver for it, which finds there's no port there.
>=20

Here is what we get from _STA:

[ 1689.988245] HID=3DPNP0501 flags=3D0d

If I read specs correctly, if bit 1 is cleared it means, device is not able
to access its hardware resources, so it makes no sense to even try to
load driver for it.

And of course it makes PnP output completely bogus:

00:09 PNP0501 16550A-compatible serial port
    state =3D active
    allocated resources:
        io 0x3f8-0x3ff
        irq 5
=20
So two questions:

1. why device got enabled when ACPI explicitly stated it cannot be?
2. can we get information about _STA result in user space so we do not try
to autoload driver for device that can't work?

--nextPart25451413.2so2eWPT9s
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHSdSeR6LMutpd94wRAuH2AKDCNpLNXWltEqNkZQ+X/Osp7K0rDACgzUpj
UI6hGdKn3gbLoX75kTHETfE=
=dPVc
-----END PGP SIGNATURE-----

--nextPart25451413.2so2eWPT9s--
