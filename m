Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYJBIby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYJBIby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYJBIbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:31:46 -0400
Received: from server.drzeus.cx ([85.8.24.28]:36750 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752396AbYJBIbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:31:45 -0400
Date: Thu, 2 Oct 2008 10:31:37 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] atmel-mci: support multiple mmc slots
Message-ID: <20081002103137.57f5a9ad@mjolnir.drzeus.cx>
In-Reply-To: <20080925155149.173dde16@hskinnemo-gx745.norway.atmel.com>
References: <1222101497-21183-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-4-git-send-email-haavard.skinnemoen@atmel.com>
	<20080923195342.52b1164d@mjolnir.drzeus.cx>
	<20080923201650.4525b883@hskinnemo-gx745.norway.atmel.com>
	<20080923211222.551389ab@mjolnir.drzeus.cx>
	<20080924163527.30cfc223@hskinnemo-gx745.norway.atmel.com>
	<20080925090556.44940c89@mjolnir.drzeus.cx>
	<20080925155149.173dde16@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-7138-1222936305-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-7138-1222936305-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Sep 2008 15:51:49 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> > On Wed, 24 Sep 2008 16:35:27 +0200
> > Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> >=20
> > Remember to deal with the case of a powered but unclocked card. This
> > will primarily happen during card init, but it could should up later as
> > well if we start implementing aggressive power management.
>=20
> Ok, but how _do_ I deal with that? If the clock is turned off due to
> power management, it should be safe to leave it running at the same
> rate. But how about initialization? Should I stall the queue until the
> newly-powered card gets a clock rate?
>=20

Yes, I don't see any other safe way of handling it.

> Btw, I just noticed that other thread about pxamci clock management.
> Will it cause problems if the clock stops briefly from time to time?
> Currently, the controller stops the clock if the FIFO gets full/empty
> during transfer -- this is configurable, but I'd much rather let the
> clock stop than risk FIFO overruns/underruns...

Hopefully not. :)

The spec gives no other means of flow control than messing with the
clock. But as has been noted, some cards get a bit freaky if we leave
them without a clock for too long, so care should be taken to try to
minimise the time it is stopped.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-7138-1222936305-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjkhu4ACgkQ7b8eESbyJLgwEgCg0u8/S3ajHKN6Rr4qNaOFz4z9
Uq0AoJgm0OOGLCRM8sGexpmmzqOLmWJ3
=gSVv
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-7138-1222936305-0001-2--
