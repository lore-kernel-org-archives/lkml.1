Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbYAJUlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbYAJUlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYAJUlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:41:07 -0500
Received: from systemlinux.org ([83.151.29.59]:54851 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYAJUlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:41:06 -0500
Date: Thu, 10 Jan 2008 21:40:20 +0100
From: Andre Noll <maan@systemlinux.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to unlocked_ioctl
Message-ID: <20080110204020.GC20152@skl-net.de>
References: <20080110180529.GA32640@skl-net.de> <1199991298.3141.75.camel@localhost.localdomain> <20080110185944.GA1690@one.firstfloor.org> <20080110190748.GA20152@skl-net.de> <20080110192950.GG747@one.firstfloor.org> <20080110194550.GB20152@skl-net.de> <47867C7E.3000100@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xesSdrSSBC0PokLI"
Content-Disposition: inline
In-Reply-To: <47867C7E.3000100@panasas.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xesSdrSSBC0PokLI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22:13, Boaz Harrosh wrote:

> All the scsi calls do not need any locks. The scsi LLDS never
> see these threads since commands are queued through the block
> layer.

That's what everybody believes, but nobody seems to know for sure.
Therefore I did what Andi suggested: Make a zero-semantics change
that moves the lock_kernel() to sg_ioctl() to make people aware of
the fact that this function runs under the BKL. At least the latter
has already succeeded.

> What's left is what you see, here in sg.c. you must have the best=20
> knowledge about the possible races between ioctl and open/release
> and probe/remove. And all these put_user() copy_user() etc...
> Why don't you have a hard look and fix them properly.

Because that requires much more knowledge. Al is looking into this
which indicates that it is non-trivial issue. I am clearly not the
right person to decide this question.

> please don't *lock_kernel();* for scsi's sake.

The BKL was there all the time. My patch just made it more visable
to the scsi people by moving it into sg.c.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--xesSdrSSBC0PokLI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHhoK0Wto1QDEAkw8RAkcKAJ4+vNpx4NrOss6bK2yatia7dHNz1gCfXeCe
37GBqDPeAUgRejyC1oXJ7fw=
=IJPr
-----END PGP SIGNATURE-----

--xesSdrSSBC0PokLI--
