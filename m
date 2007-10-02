Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbXJBJTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbXJBJTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbXJBJTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:19:39 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:58231 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751590AbXJBJTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:19:38 -0400
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, nickpiggin@yahoo.com.au, hch@lst.de,
       mel@skynet.ie, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dgc@sgi.com, jens.axboe@oracle.com
In-Reply-To: <20071001143047.238dfe49.akpm@linux-foundation.org>
References: <20070919033605.785839297@sgi.com>
	 <20070919033643.763818012@sgi.com>
	 <200709280742.38262.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
	 <1191002119.18147.80.camel@lappy>
	 <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
	 <1191003950.18147.85.camel@lappy>
	 <20070929011311.8b51dedb.akpm@linux-foundation.org>
	 <1191055632.18147.101.camel@lappy>
	 <20070929020049.f73f4aea.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0710011354480.19779@schroedinger.engr.sgi.com>
	 <20071001143047.238dfe49.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-st+70RLI1y/CYantNC8k"
Date: Tue, 02 Oct 2007 11:19:34 +0200
Message-Id: <1191316774.13204.50.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-st+70RLI1y/CYantNC8k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-01 at 14:30 -0700, Andrew Morton wrote:
> On Mon, 1 Oct 2007 13:55:29 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
>=20
> > On Sat, 29 Sep 2007, Andrew Morton wrote:
> >=20
> > > > atomic allocations. And with SLUB using higher order pages, atomic =
!0
> > > > order allocations will be very very common.
> > >=20
> > > Oh OK.
> > >=20
> > > I thought we'd already fixed slub so that it didn't do that.  Maybe t=
hat
> > > fix is in -mm but I don't think so.
> > >=20
> > > Trying to do atomic order-1 allocations on behalf of arbitray slab ca=
ches
> > > just won't fly - this is a significant degradation in kernel reliabil=
ity,
> > > as you've very easily demonstrated.
> >=20
> > Ummm... SLAB also does order 1 allocations. We have always done them.
> >=20
> > See mm/slab.c
> >=20
> > /*
> >  * Do not go above this order unless 0 objects fit into the slab.
> >  */
> > #define BREAK_GFP_ORDER_HI      1
> > #define BREAK_GFP_ORDER_LO      0
> > static int slab_break_gfp_order =3D BREAK_GFP_ORDER_LO;
>=20
> Do slab and slub use the same underlying page size for each slab?
>=20
> Single data point: the CONFIG_SLAB boxes which I have access to here are
> using order-0 for radix_tree_node, so they won't be failing in the way in
> which Peter's machine is.
>=20
> I've never ever before seen reports of page allocation failures in the
> radix-tree node allocation code, and that's the bottom line.  This is jus=
t
> a drop-dead must-fix show-stopping bug.  We cannot rely upon atomic order=
-1
> allocations succeeding so we cannot use them for radix-tree nodes.  Nor f=
or
> lots of other things which we have no chance of identifying.
>=20
> Peter, is this bug -mm only, or is 2.6.23 similarly failing?

I'm mainly using -mm (so you have at least one tester :-), I think the
-mm specific SLUB patch that ups slub_min_order makes the problem -mm
specific, would have to test .23.

--=-st+70RLI1y/CYantNC8k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHAg0mXA2jU0ANEf4RAj/bAJ42BGRHeps/hEiUqZ/gnOF/iIwaagCfetrd
1PGseqivQWs1wQkFGyLQe2k=
=iMYz
-----END PGP SIGNATURE-----

--=-st+70RLI1y/CYantNC8k--

