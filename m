Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbXJDH2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbXJDH2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 03:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbXJDH2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 03:28:48 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:51838 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbXJDH2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 03:28:47 -0400
Date: Thu, 4 Oct 2007 09:28:41 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Don Mullis <dwm@meer.net>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.23-rc8-mm2: OOPS in mmc on boot
Message-ID: <20071004092841.322a3476@poseidon.drzeus.cx>
In-Reply-To: <20071003231659.f41df5ed.akpm@linux-foundation.org>
References: <1191478262.21598.5.camel@dmullis-laptop>
	<20071003231659.f41df5ed.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-30782-1191482899-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-30782-1191482899-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Oct 2007 23:16:59 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 03 Oct 2007 23:11:02 -0700 Don Mullis <dwm@meer.net> wrote:
>=20
> > OOPS followed by a 3 minute timeout, then completion of boot.
> > Not seen if card (Kingston microSD adapter) is ejected; not seen in
> > 2.6.23-rc8. Running on a Dell XPS M1330 laptop.
> >=20

Impossible! My code is bug free!

> > [   13.709831] EIP is at blk_rq_map_sg+0xc0/0x160
> > [   13.711857] Call Trace:
> > [   13.711971]  [<f8c39e58>] mmc_queue_map_sg+0x28/0xc0 [mmc_block]
> > [   13.712085]  [<f8c396c9>] mmc_blk_issue_rq+0x199/0x780 [mmc_block]
> > [   13.712193]  [<f8c3a168>] mmc_queue_thread+0x78/0xe0 [mmc_block]

Seems to be in the handling of the bounce buffer. I don't see how any
of the parameters to blk_rq_map_sg() could be incorrect though, so I
suspect the problem is not in the mmc layer.

Don, is MMC_BLOCK_BOUNCE enabled? Could you try toggling it and see if
things change?

>=20
> This could be due to git-block changes (or a lack of them ;))
>=20

There are no pending patches, or recent changes that mess about in any
real way in there.

Don, when did this work last?

Rgds
Pierre

--=_hera.drzeus.cx-30782-1191482899-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHBJYp7b8eESbyJLgRArMrAJ9G0ZRI8Y9TFJvECDqLgiKTGeIOFgCeKUAo
x3k8Y+ag7V1c4reNtX5JUZU=
=fdLJ
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-30782-1191482899-0001-2--
