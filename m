Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbXHTJRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbXHTJRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 05:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbXHTJRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 05:17:44 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:44848 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751877AbXHTJRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 05:17:43 -0400
Subject: Re: [PATCH 04/10] mm: slub: add knowledge of reserve pages
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0708201211240.20591@sbz-30.cs.Helsinki.FI>
References: <20070806102922.907530000@chello.nl>
	 <20070806103658.603735000@chello.nl> <1187595513.6114.176.camel@twins>
	 <Pine.LNX.4.64.0708201211240.20591@sbz-30.cs.Helsinki.FI>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-udHQMOltm/5b8k9KQ8wZ"
Date: Mon, 20 Aug 2007 11:17:35 +0200
Message-Id: <1187601455.6114.189.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-udHQMOltm/5b8k9KQ8wZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-20 at 12:12 +0300, Pekka J Enberg wrote:
> Hi Peter,
>=20
> On Mon, 20 Aug 2007, Peter Zijlstra wrote:
> > -static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int no=
de)
> > +static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int no=
de, int *reserve)
> >  {
>=20
> [snip]
>=20
> > +	*reserve =3D page->reserve;
>=20
> Any reason why the callers that are actually interested in this don't do=20
> page->reserve on their own?

because new_slab() destroys the content?

struct page {
	...
	union {
		pgoff_t index;		/* Our offset within mapping. */
		void *freelist;		/* SLUB: freelist req. slab lock */
		int reserve;		/* page_alloc: page is a reserve page */
		atomic_t frag_count;	/* skb fragment use count */
	};
	...
};

static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node, i=
nt *reserve)
{
	...
	*reserve =3D page->reserve;
	...
	page->freelist =3D start;
	...
}


--=-udHQMOltm/5b8k9KQ8wZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGyVwvXA2jU0ANEf4RAhQNAJ91XekewOmq+RfoxHrvoNYOGWXWFQCfbEUN
UUBObXECAFrQ2DfXDhTdUvk=
=zbSK
-----END PGP SIGNATURE-----

--=-udHQMOltm/5b8k9KQ8wZ--

