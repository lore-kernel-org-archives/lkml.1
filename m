Return-Path: <linux-kernel-owner+w=401wt.eu-S965762AbXIJThi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965762AbXIJThi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932710AbXIJThV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:37:21 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:11924 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932169AbXIJThS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:37:18 -0400
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Daniel Phillips <phillips@phunq.net>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0709101225350.24735@schroedinger.engr.sgi.com>
References: <20070814142103.204771292@sgi.com>
	 <200709050220.53801.phillips@phunq.net>
	 <Pine.LNX.4.64.0709050334020.8127@schroedinger.engr.sgi.com>
	 <20070905114242.GA19938@wotan.suse.de>
	 <Pine.LNX.4.64.0709050507050.9141@schroedinger.engr.sgi.com>
	 <20070905121937.GA9246@wotan.suse.de>
	 <Pine.LNX.4.64.0709101225350.24735@schroedinger.engr.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vZgxFaUnD3pN0yohNHoy"
Date: Mon, 10 Sep 2007 21:37:11 +0200
Message-Id: <1189453031.21778.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vZgxFaUnD3pN0yohNHoy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-10 at 12:29 -0700, Christoph Lameter wrote:
> On Wed, 5 Sep 2007, Nick Piggin wrote:
>=20
> > Implementation issues aside, the problem is there and I would like to
> > see it fixed regardless if some/most/or all users in practice don't
> > hit it.
>=20
> I am all for fixing the problem but the solution can be much simpler and=20
> more universal. F.e. the amount of tcp data in flight may be controlled=20
> via some limit so that other subsystems can continue to function even if=20
> we are overwhelmed by network traffic.

With swap over network you need not only protect other subsystems from
networking, but you also have to guarantee networking will in some form
stay functional, otherwise you'll never receive the writeout completion.

>  Peter's approach establishes the=20
> limit by failing PF_MEMALLOC allocations.=20

I'm not failing PF_MEMALLOC allocations. I'm more stringent in failing !
PF_MEMALLOC allocations.

> If that occurs then other=20
> subsystems (like the disk, or even fork/exec or memory management=20
> allocation) will no longer operate since their allocations no longer=20
> succeed which will make the system even more fragile and may lead to=20
> subsequent failures.

Failing allocations should never be a stability problem, we have the
fault-injection framework which allows allocations to fail randomly -
this should never crash the kernel - if it does its a BUG.

--=-vZgxFaUnD3pN0yohNHoy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG5ZznXA2jU0ANEf4RArjEAJ9f1xNJBfypM0uf/kA40IPOIyGD2QCgi19D
B8toeZ/ycbmdXVVKUQ7HxOI=
=xOmX
-----END PGP SIGNATURE-----

--=-vZgxFaUnD3pN0yohNHoy--

