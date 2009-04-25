Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZDYUYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZDYUYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 16:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbZDYUYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 16:24:24 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:36426 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbZDYUYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 16:24:23 -0400
Date: Sat, 25 Apr 2009 22:24:15 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Martin Fuzzey <mfuzzey@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Questions on mmc_test suite
Message-ID: <20090425222415.51c97cfa@mjolnir.ossman.eu>
In-Reply-To: <ba4215e10904150213o628cc9d1ke80bd6dd9bfad089@mail.gmail.com>
References: <ba4215e10904150213o628cc9d1ke80bd6dd9bfad089@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-28800-1240691057-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-28800-1240691057-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Apr 2009 11:13:44 +0200
Martin Fuzzey <mfuzzey@gmail.com> wrote:

> Hi,
> I'm currently updating the mxcmmc driver for the i.MX21 platform
> [patches have been posted to the arm list] and have a couple of
> questions about the test suite.
>=20
> 1) I'm getting an error on testcase 10 (weird reads) which does reads
> of 3 to 512 bytes by steps of 7.
> Modifying the test so it continues in case of error shows that it
> _only_ fails on the 395 byte read.
>=20
> It fails with a software timeout (-110)
> The card sends the same response to CMD17 (READ_SINGLE_BLOCK) as the
> reads that work
> but hardware never indicates transfer complete.
>=20
> Changing the test to start at 395 makes it fail immediately (so not
> dependent on previous reads).
> Has anyone seen this before?
>=20

Nothing I recognize, no. Have you tested more than one card in case
it's a card bug?

> 2) I'm getting "Warning: Host did not wait for busy state to end" on
> the multiblock write tests (Tests 5 and 13) but they still pass.
> Seems to be timing related since this doesn't occur with MMC debugging en=
abled.
> My understanding of this is that the driver should wait for the
> hardware to stop signalling busy on the data line (response R1b) after
> sending
> command 12 (stop transmission) before replying - is this correct?
> However the MX2 SDHC doesn't have a register for this.
>=20
> Should I:
> a) ignore it? [apart from the testcase warning everything seems to work]
> b) try reading the data line as GPIO  - seems a bit of a hack
> c) issue CMD13 (SEND_STATUS) from the driver to poll the card  - seems
> to be the wrong layer.
>=20
> If b) is the way to go how long can the delay be - is polling
> acceptable or must it be interrupt driven?
>=20

I'd say a). If the hardware doesn't support it then I don't think we
can do that much better than the polling that mmc_block does.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-28800-1240691057-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknzcXIACgkQ7b8eESbyJLga0gCglTAubxwvWKWq7vHRUfHFWtJc
Z/gAoIziNyiDh4NLmzaM8mS9dLS9Nhfq
=gdeV
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-28800-1240691057-0001-2--
