Return-Path: <linux-kernel-owner+w=401wt.eu-S1761994AbYHDTVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761994AbYHDTVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761899AbYHDTU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:20:57 -0400
Received: from home.keithp.com ([63.227.221.253]:2011 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761892AbYHDTUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:20:52 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: keithp@keithp.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0808041855050.5717@blonde.site>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <200808041902.23970.nickpiggin@yahoo.com.au>
	 <1217845590.24714.45.camel@koto.keithp.com>
	 <200808042043.46710.nickpiggin@yahoo.com.au>
	 <1217850352.24714.66.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808041720500.25617@blonde.site>
	 <1217870748.24714.79.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808041855050.5717@blonde.site>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-snp3EfrhZBZ6cUOPHTql"
Date: Mon, 04 Aug 2008 12:20:45 -0700
Message-Id: <1217877645.24714.87.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-snp3EfrhZBZ6cUOPHTql
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 19:39 +0100, Hugh Dickins wrote:

> Well, I guess put the check on ->readpage into your code for now, and
> by the time GEM gets into Linus's tree, we should have -EINVAL checks
> on NULL filler() in __read_cache_page() and read_cache_page_async(),
> so remove check at your end before final submission.

Sounds good to me.

> I think you should drop the mark_page_accessed(): that's done in
> read_cache_page_async() as part of the initial read_mapping_page().
> But do it again when releasing if you think there's a good chance
> that object will be wanted again shortly.  set_page_dirty() if
> modified by GPU, yes, that would still be needed.

I'll just remove it then; pages pulled from the GTT are unlikely to be
used soon.

> For how long are these objects' pages pinned in memory like this?

Forever? The only reason an object would get unpinned would be on
eviction from the GTT, and objects will only be evicted if we fill the
aperture with other stuff. When we add a register_shrinker callback,
we'll also unpin pages at that point.

A busy system should have the GTT entirely full, and that will be
somewhere between 256MB and 1GB.

> I ask because Rik & Lee have patches in -mm, trying to avoid long
> scans of LRUs cluttered with unevictable pages.  I've no idea
> whether you're adding a lot or a little to that problem.

If the idea of 1GB of pinned memory doesn't scare you, then I don't see
a problem ;-)

--=20
keith.packard@intel.com

--=-snp3EfrhZBZ6cUOPHTql
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIl1aNQp8BWwlsTdMRAiGmAJ0cvdo9k2ihP9t4YCbrmE+rDZIuhQCgw1nz
NiDJuSbzmwAl1gKo8MfcrPw=
=Dhpv
-----END PGP SIGNATURE-----

--=-snp3EfrhZBZ6cUOPHTql--

