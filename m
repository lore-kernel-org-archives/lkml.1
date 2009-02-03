Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbZBCMdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbZBCMdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZBCMdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:33:00 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:51144 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbZBCMdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:33:00 -0500
Date: Tue, 3 Feb 2009 13:32:42 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Hugh Dickins <hugh@veritas.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Grant Grundler <grundler@google.com>,
       Greg Freemyer <greg.freemyer@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through
 sysfs
Message-ID: <20090203133242.29904063@mjolnir.drzeus.cx>
In-Reply-To: <20090116064818.GS30821@kernel.dk>
References: <4964866D.8010503@msgid.tls.msk.ru>
	<1231342473.3282.19.camel@localhost.localdomain>
	<496ECBA0.60209@gmail.com>
	<87f94c370901150707h10506e99reaa40c23e32ab18c@mail.gmail.com>
	<1232035561.5966.48.camel@localhost.localdomain>
	<da824cf30901151055o2385ef74x918e8390e576d807@mail.gmail.com>
	<1232046039.5966.54.camel@localhost.localdomain>
	<da824cf30901151445q6b54c0b1nbf24f03849e1a5b3@mail.gmail.com>
	<1232061429.5966.87.camel@localhost.localdomain>
	<Pine.LNX.4.64.0901152341500.15035@blonde.anvils>
	<20090116064818.GS30821@kernel.dk>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-18211-1233664376-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-18211-1233664376-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Jan 2009 07:48:18 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

>=20
> For non-queuing devices, I think our current check is a bit too drastic.
> We probably want to change that to
>=20
> int dont_plug(q)
> {
>         return blk_queue_nonrot(q) && blk_queue_tagged(q);
> }
>=20

Please do. The MMC block driver sets nonrot as of late, but it is
extremely dependent on merging. The command overhead is just silly, so
to get anywhere near the speed numbers indicated in marketing you need
large requests.

It seems that too many confuse "non-rotational" with "low latency",
which isn't always the same. :)

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-18211-1233664376-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkmIOXIACgkQ7b8eESbyJLjdVQCgqNVyBfYB9z9dVstnhmi75i4t
GHkAoIi1mICX4UQmdcFWxF5fkUm/Zc1T
=cPzc
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-18211-1233664376-0001-2--
