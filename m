Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbZFMKfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbZFMKfG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 06:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZFMKe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 06:34:56 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:50445 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZFMKez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 06:34:55 -0400
Date: Sat, 13 Jun 2009 12:34:52 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: dsaxena@plexity.net
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Add 400ms to CAFE SD controller resume path
Message-ID: <20090613123452.0d24ec82@mjolnir.ossman.eu>
In-Reply-To: <20090604233349.GA2545@plexity.net>
References: <20090513200556.GA7882@plexity.net>
	<20090522135150.7e0716d6@mjolnir.ossman.eu>
	<20090528013629.0173522b.akpm@linux-foundation.org>
	<20090528104823.0a551ecb@mjolnir.ossman.eu>
	<20090604233349.GA2545@plexity.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-24465-1244889296-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-24465-1244889296-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Jun 2009 23:33:49 +0000
Deepak Saxena <dsaxena@plexity.net> wrote:

>=20
> The request is not ending up in the queue of the new device.  If I=20
> recall correctyl What is happening is that userspace does an unmount on t=
he=20
> old device when it receives the notification that it is gone (since it is=
 not=20
> redected and a new entry is created). By the time that unmount is called,=
 the=20
> various data structures for the device has been zeroed out but the variou=
s=20
> operation pointers are !NULL, so when we go back to write the superblock =
for=20
> the mounted partition, we overwrite the device's partition table as the
> partition offset is now 0. The main issue here is that the kernel is allo=
wing=20
> an I/O to a device that is technically still there but not from the kerne=
l's
> POV.

But if the device is not there from the kernel's POV then it should be
impossible to write to it. It seems this is a kernel bug though. See
this thread:

http://marc.info/?t=3D124413860500006&r=3D1&w=3D2

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-24465-1244889296-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkozgNAACgkQ7b8eESbyJLinSwCfdihymwEE0q7WZqpe6pvQQc5g
KvsAn00Z17h0psFW1CgUfdUIzylXBkMF
=knZn
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-24465-1244889296-0001-2--
