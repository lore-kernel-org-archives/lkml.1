Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYHNLia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYHNLia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 07:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbYHNLiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 07:38:21 -0400
Received: from server.drzeus.cx ([85.8.24.28]:40653 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752556AbYHNLiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 07:38:20 -0400
Date: Thu, 14 Aug 2008 13:38:10 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alex Dubov <oakad@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: can block drivers get non-fs requests?
Message-ID: <20080814133810.746751cf@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-24507-1218713898-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-24507-1218713898-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jens,

There is one part of the block layer I'm having trouble completely
understanding (well there are loads really, but right now there's one in
particular :)):

Do block drivers need to watch out for requests that aren't "normal"
reads and writes? The MMC block driver has a funky prepare function
that checks for FS and PC requests and discards anything else. I
believe this is wrong in two regards:

a) PC requests seem to be prepared SCSI cmds, and the MMC driver just
expects normal transfer requests. Therefore, such requests should not
be accepted by this driver.

b) The block layer won't throw weird stuff at us unless explicitly told
so. I.e. a normal block queue will only produce normal FS requests.

Please educate the masses. :)

(I've cc:d Alex as he copied the MMC block driver for the MemoryStick
code, so he's probably also interested in this)

Rgds

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-24507-1218713898-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkikGSgACgkQ7b8eESbyJLhvfACg/EkBIlJ9aqNnZoEbIlhfGZy2
L/AAnivJ8TRX5iXes2aO1S2dBUt8jYBu
=xV5r
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-24507-1218713898-0001-2--
