Return-Path: <linux-kernel-owner+w=401wt.eu-S934088AbZE0U0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088AbZE0U0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764362AbZE0U02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:26:28 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:58183 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763735AbZE0U01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:26:27 -0400
Date: Wed, 27 May 2009 22:26:22 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Nicolas Pitre <nico@cam.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mvsdio: fix config failure with some high speed SDHC
 cards
Message-ID: <20090527222622.6539d92f@mjolnir.ossman.eu>
In-Reply-To: <alpine.LFD.2.00.0905262231120.3906@xanadu.home>
References: <alpine.LFD.2.00.0905262231120.3906@xanadu.home>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-4583-1243455987-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-4583-1243455987-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 May 2009 22:35:34 -0400 (EDT)
Nicolas Pitre <nico@cam.org> wrote:

>    =20
> Especially with Sandisk SDHC cards, the second SWITCH command was failing
> with a timeout and the card was not recognized at all.  However if the
> system was busy, or debugging was enabled, or a udelay(100) was inserted
> before the second SWITCH command in the core code, then the timing was
> so that the card started to work.
>=20
> This appears to be a problem with the host hardware.  With some unusual
> block sizes, the data FIFO status doesn't indicate a "empty" state right
> away when the data transfer is done.  Queuing another data transfer in
> that condition results in a transfer timeout.
>=20
> The empty FIFO bit eventually get set by itself in less than 50 usecs
> when it is not set right away. So let's just poll for that bit before
> configuring the controller with a new data transfer.
>=20
> Signed-off-by: Nicolas Pitre <nico@marvell.com>
>=20

You seem to be having a lot of fun with this controller. :)

Patch queued.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-4583-1243455987-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEUEARECAAYFAkodofIACgkQ7b8eESbyJLircQCg/CFuVHaRMm7x2jjnftVOOKK2
7RIAmIlMThszXHHKpG5XxCzV5vof1Yc=
=B7nY
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-4583-1243455987-0001-2--
