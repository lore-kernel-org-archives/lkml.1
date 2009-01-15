Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbZAOGFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbZAOGFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 01:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZAOGFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 01:05:30 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:41736 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbZAOGF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 01:05:29 -0500
Date: Thu, 15 Jan 2009 07:05:21 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sdhci: Fix potential spinlock recursion
Message-ID: <20090115070521.25c3bda7@mjolnir.drzeus.cx>
In-Reply-To: <20090114194159.GA25017@oksana.dev.rtsoft.ru>
References: <20090114194159.GA25017@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-7238-1231999524-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-7238-1231999524-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Jan 2009 22:41:59 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

>=20
> This happens because plain spin_lock() won't protect us from
> softirqs (tasklets). So in the sdhci interrupt handler we must
> grab the _irq version of the lock.
>=20

?! The docs I've read state that softirq:s are not executed until all
the hardirq:s have finished processing. And looking at your code, that
seems to still hold true. A softirq running esdhc_tasklet_card() gets
preempted by a hard irq and we have the lockup.

If you're running the code you sent a few minutes later, then something
is broken with your platform as esdhc_tasklet_card() clearly tries to
disable interrupts when it grabs the lock.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-7238-1231999524-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklu0iUACgkQ7b8eESbyJLi0NwCgpvLH47vhe5kgTBvOMCLseaMA
6ZcAnjsj5Xoo0N4hC7HAo6u0y2hN3IDx
=Db/U
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-7238-1231999524-0001-2--
