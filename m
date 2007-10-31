Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbXJaKqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbXJaKqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbXJaKqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:46:00 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:7595 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751015AbXJaKp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:45:59 -0400
Subject: Re: [PATCH 09/33] mm: system wide ALLOC_NO_WATERMARK
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
In-Reply-To: <200710311452.36239.nickpiggin@yahoo.com.au>
References: <20071030160401.296770000@chello.nl>
	 <20071030160912.283002000@chello.nl>
	 <200710311452.36239.nickpiggin@yahoo.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e5tlmua4wL578c6z+yiG"
Date: Wed, 31 Oct 2007 11:45:55 +0100
Message-Id: <1193827555.27652.133.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-e5tlmua4wL578c6z+yiG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-31 at 14:52 +1100, Nick Piggin wrote:
> On Wednesday 31 October 2007 03:04, Peter Zijlstra wrote:
> > Change ALLOC_NO_WATERMARK page allocation such that the reserves are sy=
stem
> > wide - which they are per setup_per_zone_pages_min(), when we scrape th=
e
> > barrel, do it properly.
> >
>=20
> IIRC it's actually not too uncommon to have allocations coming here via
> page reclaim. It's not exactly clear that you want to break mempolicies
> at this point.

Hmm, the way I see it is that mempolicies are mainly for user-space
allocations, reserve allocations are always kernel allocations. These
already break mempolicies - for example hardirq context allocations.

Also, as it stands, the reserve is spread out evenly over all
zones/nodes (excluding highmem), so by restricting ourselves to a
subset, we don't have access to the full reserve.


--=-e5tlmua4wL578c6z+yiG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHKFzjXA2jU0ANEf4RAoU0AJ0eZtew/3cO5/H6pCLyHNnXKc7hhgCgi54o
PtDuuGj/tQ4uMH0Vvthjoc4=
=Y12J
-----END PGP SIGNATURE-----

--=-e5tlmua4wL578c6z+yiG--

