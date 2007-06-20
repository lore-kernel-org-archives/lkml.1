Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbXFTRsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbXFTRsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbXFTRsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:48:23 -0400
Received: from dovecot.org ([82.118.211.50]:45553 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901AbXFTRsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:48:22 -0400
Subject: Re: SMP read() stopping at memory page boundaries
From: Timo Sirainen <tss@iki.fi>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070620180500.6e2d600a@the-village.bc.nu>
References: <1182351171.3768.65.camel@hurina>
	 <1182354493.3768.80.camel@hurina>
	 <2c0942db0706200922i15ce44b0xceaed95d002dba33@mail.gmail.com>
	 <1182358622.3768.98.camel@hurina>
	 <20070620180500.6e2d600a@the-village.bc.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0mkEwc+wuElenIXVMNcg"
Date: Wed, 20 Jun 2007 20:48:20 +0300
Message-Id: <1182361700.3768.107.camel@hurina>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0mkEwc+wuElenIXVMNcg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-20 at 18:05 +0100, Alan Cox wrote:
> > I thought this wouldn't happen when reading from local filesystems.
> > Anyway, my real program was doing that, and it was still seeing partial
> > data. But looks like I can't reproduce it in my test program with two
> > pread()s, so I'll have to do some more debugging.

Found the problem in my code. A buggy program, buggy test program and a
buggy brain while debugging doesn't seem to give the best results. :)

> It will occur if you are reading as someone else changes the file size.
> Use file locking, it exists for a reason ;)

Annoying extra overhead. Especially with NFS, when nowadays you can't
even use flock() to create local locks..


--=-0mkEwc+wuElenIXVMNcg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGeWhkyUhSUUBViskRAsAGAJ9GWxnKCAWMgotlb1Cj6cXxALmEFwCdGdon
0oP76Tk9EPRS17OHA66nUuE=
=6tDT
-----END PGP SIGNATURE-----

--=-0mkEwc+wuElenIXVMNcg--

