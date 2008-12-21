Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbYLUNtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbYLUNtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 08:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYLUNtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 08:49:31 -0500
Received: from server.drzeus.cx ([85.8.24.28]:38058 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751682AbYLUNta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 08:49:30 -0500
Date: Sun, 21 Dec 2008 14:49:21 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 6/8] SDHCI: Check DMA for overruns at end of transfer
Message-ID: <20081221144921.1b0c5862@mjolnir.drzeus.cx>
In-Reply-To: <20081202154112.788195791@fluff.org.uk>
References: <20081202154018.906091477@fluff.org.uk>
	<20081202154112.788195791@fluff.org.uk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-24271-1229867368-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-24271-1229867368-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 02 Dec 2008 15:40:24 +0000
Ben Dooks <ben-linux@fluff.org> wrote:

> At the end of a transfer, check that the DMA engine in the
> SDHCI controller actually did what it was meant to and didn't
> overrun the end of the buffer.
>=20
> This seems to be triggered by a timeout during an CMD25 (multiple block  =
      =20
> write) to a card. The mmc_block module then issues a command to find out =
      =20
> how much data was moved and this seems to end up triggering this DMA     =
      =20
> check. The result is the card's queue generates an OOPS as the stack has =
      =20
> been trampled on due to the extra data transfered.
>=20

Hmm... this is even stranger. CMD25 (write) will only read from main
memory and should not be able to mess up the stack. And it shouldn't be
the stack getting messed up anyway as that is not near the buffer
memory.

I still consider this a critical bug since it seems to be provoked by
hitting the timeout condition.

I'll queue up your patches (once the other things are fixed), but I
will add a patch disabling DMA on this controller until this is
properly understood and handled.

RGds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-24271-1229867368-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklOSWcACgkQ7b8eESbyJLjN0ACeKe7KM0jvVpj+1gPdOrc8GTtd
3JwAniV8JiJoq8e9qoRicLQOy9t+W46n
=0koe
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-24271-1229867368-0001-2--
