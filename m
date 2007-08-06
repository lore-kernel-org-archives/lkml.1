Return-Path: <linux-kernel-owner+w=401wt.eu-S1763643AbXHFU0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763643AbXHFU0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762992AbXHFU0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:26:38 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:37368 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762832AbXHFU0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:26:36 -0400
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, Daniel Phillips <phillips@phunq.net>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0708061315510.7603@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>
	 <200708061121.50351.phillips@phunq.net>
	 <Pine.LNX.4.64.0708061141511.3152@schroedinger.engr.sgi.com>
	 <200708061148.43870.phillips@phunq.net>
	 <Pine.LNX.4.64.0708061150270.7603@schroedinger.engr.sgi.com>
	 <20070806201257.GG11115@waste.org>
	 <Pine.LNX.4.64.0708061315510.7603@schroedinger.engr.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j9ombzTnzJ7u0ISCI54Z"
Date: Mon, 06 Aug 2007 22:26:32 +0200
Message-Id: <1186431992.7182.33.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-j9ombzTnzJ7u0ISCI54Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-06 at 13:19 -0700, Christoph Lameter wrote:
> On Mon, 6 Aug 2007, Matt Mackall wrote:
>=20
> > > > Because a block device may have deadlocked here, leaving the system=
=20
> > > > unable to clean dirty memory, or unable to load executables over th=
e=20
> > > > network for example.
> > >=20
> > > So this is a locking problem that has not been taken care of?
> >=20
> > No.
> >=20
> > It's very simple:
> >=20
> > 1) memory becomes full
>=20
> We do have limits to avoid memory getting too full.
>=20
> > 2) we try to free memory by paging or swapping
> > 3) I/O requires a memory allocation which fails because memory is full
> > 4) box dies because it's unable to dig itself out of OOM
> >=20
> > Most I/O paths can deal with this by having a mempool for their I/O
> > needs. For network I/O, this turns out to be prohibitively hard due to
> > the complexity of the stack.
>=20
> The common solution is to have a reserve (min_free_kbytes).=20

This patch set builds on that. Trouble with min_free_kbytes is the
relative nature of ALLOC_HIGH and ALLOC_HARDER.

> The problem=20
> with the network stack seems to be that the amount of reserve needed=20
> cannot be predicted accurately.
>=20
> The solution may be as simple as configuring the reserves right and=20
> avoid the unbounded memory allocations.=20

Which is what the next series of patches will be doing. Please do look
in detail at these networked swap patches I've been posting for the last
year or so.

> That is possible if one=20
> would make sure that the network layer triggers reclaim once in a=20
> while.

This does not make sense, we cannot reclaim from reclaim.

--=-j9ombzTnzJ7u0ISCI54Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGt4P4XA2jU0ANEf4RAvHDAJ4hcHpsFJPqLHGQMoQ1hCNYsYxC5ACfd6E3
ciEp6wvG+MRy3AItvJtVcLk=
=nuNO
-----END PGP SIGNATURE-----

--=-j9ombzTnzJ7u0ISCI54Z--

