Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbZCXUBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbZCXUBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbZCXUBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:01:47 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:36500 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704AbZCXUBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:01:46 -0400
Date: Tue, 24 Mar 2009 21:01:38 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MMC layer regression with single-block controllers
Message-ID: <20090324210138.71029c2c@mjolnir.ossman.eu>
In-Reply-To: <20090323092802.GA30122@roarinelk.homelinux.net>
References: <20090323092802.GA30122@roarinelk.homelinux.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-18683-1237924900-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-18683-1237924900-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Mar 2009 10:28:02 +0100
Manuel Lauss <mano@roarinelk.homelinux.net> wrote:

> Hello Pierre,
>=20
> Since about 2.6.28-rc1, I hit the following BUG_ON() in mmc/core.c
> (line 155):
>=20
>         if (mrq->data) {
>                 BUG_ON(mrq->data->blksz > host->max_blk_size);
> >>>>>>>>>       BUG_ON(mrq->data->blocks > host->max_blk_count);  <<<<<<
>                 BUG_ON(mrq->data->blocks * mrq->data->blksz >
>                         host->max_req_size);
>=20
> It's easy to reproduce; just set your favorite host controllers'
> mmc->max_blk_cnt to 1 (or anything smaller than 4).  As far as I can
> tell it was introduced with some block layer changes before 2.6.28-rc1
> was released.
>=20

Ouch. Have you determined that it is the block layer that isn't
respecting its settings? If so, the we probably need to notify Jens
Axboe.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-18683-1237924900-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknJPCUACgkQ7b8eESbyJLhsmQCglENHOS24DwD6w1ZSUwr4THqY
cXsAoLBOZj9G2U3y2YhmKhQ51hDH4MfA
=DIjy
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-18683-1237924900-0001-2--
