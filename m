Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbZESLVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbZESLVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 07:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZESLVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 07:21:39 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:46034 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbZESLVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 07:21:38 -0400
Date: Tue, 19 May 2009 13:21:30 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: yingchao li <rjn637@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Removed SD card causes kernel panic when a transfer is
 on-going.
Message-ID: <20090519132130.4c74ef39@mjolnir.ossman.eu>
In-Reply-To: <437bd5150905150145k6d750c7er89fa9b02749f738d@mail.gmail.com>
References: <437bd5150905150145k6d750c7er89fa9b02749f738d@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-18778-1242732096-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-18778-1242732096-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 15 May 2009 16:45:06 +0800
yingchao li <rjn637@gmail.com> wrote:

> In my omap3430 board, when a transfer is on-going(i.e. reading from sd
> card), I unpluged directly sd card, then kernel panic.
>=20

Known issue unfortunately. Something is not properly reference counting
the block queue, but the handling in mmc_block is correct as far as I
can gather.

Your patch works around the problem by basically keeping a reference to
the queue longer than the driver needs (hiding any missing references
in other layers).

I've been trying to find this bug without much success. The block layer
isn't that easy to understand. :/

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-18778-1242732096-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoSlj4ACgkQ7b8eESbyJLiymwCfQ88IAq7oRNasA1R/leR5SWn+
8iIAoLvWaQ5v3tZXpx4oH23nv/JYGl1W
=aDhY
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-18778-1242732096-0001-2--
