Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbXJDKqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbXJDKqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 06:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbXJDKqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 06:46:08 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:33049 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766AbXJDKqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:46:07 -0400
Date: Thu, 4 Oct 2007 12:46:02 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Mullis <dwm@meer.net>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm2: OOPS in mmc on boot
Message-ID: <20071004124602.2be94bfe@poseidon.drzeus.cx>
In-Reply-To: <20071004103805.GB5711@kernel.dk>
References: <1191478262.21598.5.camel@dmullis-laptop>
	<20071003231659.f41df5ed.akpm@linux-foundation.org>
	<20071004072515.GC5236@kernel.dk>
	<20071004100154.6093844d@poseidon.drzeus.cx>
	<20071004080631.GB23808@kernel.dk>
	<20071004104626.2a219926@poseidon.drzeus.cx>
	<20071004093014.GE23808@kernel.dk>
	<20071004122439.0944f3db@poseidon.drzeus.cx>
	<20071004103805.GB5711@kernel.dk>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-1243-1191494737-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-1243-1191494737-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Oct 2007 12:38:05 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Oct 04 2007, Pierre Ossman wrote:
> >=20
> > Is that a yes or a no? You said that the ->page field was involved
> > in
>=20
> It's a conditional yes, re-read it :-)
>=20

I didn't get the memo about what chained sg entries entail.

> > list chaining, so does or doesn't it have to be initialized before a
> > call to sg_init_one()?
>=20
> That's not the problem. It has to be initialized before calling
> blk_rq_map_sg(). sg_init_one() will zero the entire sg entry, and that
> breaks if that particular sg entry is part of a larger sg table AND
> that sg entry happens to be the chain element.
>=20

Ok, then it shouldn't affect my world at least.

Rgds
Pierre

PS. Did someone forget to do a review of all blk_rq_map_sg() callers
before committing the chained list stuff? ;)

--=_hera.drzeus.cx-1243-1191494737-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHBMRq7b8eESbyJLgRAjBUAJ9hmtx/FeBCAsPZO+VyvO4DdOXzhwCfdS2A
A3YtvBeGA4m4tgjLMsfeL70=
=Re5y
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-1243-1191494737-0001-2--
