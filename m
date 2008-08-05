Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbYHEE3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbYHEE3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYHEE2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:28:33 -0400
Received: from home.keithp.com ([63.227.221.253]:4557 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbYHEE2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:28:31 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: John Stoffel <john@stoffel.org>
Cc: keithp@keithp.com, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <18583.47633.987143.236236@stoffel.org>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <200808041902.23970.nickpiggin@yahoo.com.au>
	 <1217845590.24714.45.camel@koto.keithp.com>
	 <200808042043.46710.nickpiggin@yahoo.com.au>
	 <1217850352.24714.66.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808041720500.25617@blonde.site>
	 <1217870748.24714.79.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808041855050.5717@blonde.site>
	 <1217877645.24714.87.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808042055240.17041@blonde.site>
	 <18583.47633.987143.236236@stoffel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pCdLfgfkkX0ejagQ1nsu"
Date: Mon, 04 Aug 2008 21:28:25 -0700
Message-Id: <1217910505.24714.152.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pCdLfgfkkX0ejagQ1nsu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 22:25 -0400, John Stoffel wrote:

> What about the onboard memory of graphics cards?  Isn't that where
> Textures and such are stored as well?  So once something is loaded to
> the card, shouldn't you be able to free it in system memory?  Or swap
> it out ahead of time? =20

Right now, I'm working only on Intel integrated graphics, which doesn't
have any on-board memory. My thinking is that we'd best solve the
easiest case first before attempting the harder discrete graphics
driver. Plus, Intel pays me do do integrated graphics, so I have an
incentive.

Not that we haven't been thinking about how this plays with a discrete
card; we'll need to allocate backing store for any objects which are
placed in on-card memory in case we run out of on-card memory, and also
as a place to store objects when the system suspends. From the
perspective of shmem, it should be precisely the same; allocating
anonymous pages and handing them to the DRM driver to store video card
data.

> I just wonder here, since GPUs are different from other drivers in
> that (I assume) they are written too much more often than they are
> read to, that they should hopefully be much more amenable to drop
> behind semantics for pages they've been sent, to free system
> resources.

Yup, I think you understand the situation fairly well. I've got a big
pile of pages sitting idle in the GTT which could be pulled out and
given back to the system. I like to keep a bunch around as the cost of
getting pages out of the CPU cache and bound to the GTT is non-trivial,
but if there's any memory pressure, the cost to free them is quite low.

--=20
keith.packard@intel.com

--=-pCdLfgfkkX0ejagQ1nsu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIl9bpQp8BWwlsTdMRAi/dAKDYTowMBOojktpL1u/LFUeDuFJ9rACfX0Fa
N01Tu1zdzqmVn7ttyZDUGpg=
=0oJ6
-----END PGP SIGNATURE-----

--=-pCdLfgfkkX0ejagQ1nsu--

