Return-Path: <linux-kernel-owner+w=401wt.eu-S1764256AbYHDVje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764256AbYHDVje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764809AbYHDVh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:37:57 -0400
Received: from home.keithp.com ([63.227.221.253]:4839 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757672AbYHDVhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:37:55 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: keithp@keithp.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0808042055240.17041@blonde.site>
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
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y+l4GtW8g2GhsVEmLrF0"
Date: Mon, 04 Aug 2008 14:37:48 -0700
Message-Id: <1217885869.24714.97.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Y+l4GtW8g2GhsVEmLrF0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 20:55 +0100, Hugh Dickins wrote:

> Okay, thanks for the warning.  It sounds like the shrinker will be
> important, but we'll also need to mark those pages as unevictable
> while they're unshrunk.

That seems like a sensible optimization; otherwise the system could
spend quite a bit of time wandering over these pages.

>   (Usually when drivers grab a large number
> of pages, they're not on any LRU to begin with: you're being nice
> by choosing swappable LRU pages - in the tmpfs case - but enough
> to upset the balance while they're not swappable.)=20

It's not a matter of 'being nice', of course, it's a matter of keeping
the system running under heavy firefox load. Check out the memory usage
by your X server with numerous tabs open to image-heavy pages someday.
Not making those pageable would result in OOM visiting far too often.

Right now, we make these images pageable by copying them in and out of a
set of pages bound permanently to the GTT. The performance implications
of doing that are fairly severe, enough so that in many cases it's
better to just use the CPU for most rendering.

>  Offhand I can't
> say what will be the appropriate way to do that, it's something we
> need to revisit later (from your point of view it should amount to
> one function call or flag set somewhere, not any grand redesign).

Ok, cool. I haven't added the shrinker support yet in any case, although
that doesn't look like a big job.

--=20
keith.packard@intel.com

--=-Y+l4GtW8g2GhsVEmLrF0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIl3asQp8BWwlsTdMRAkhjAKCryCe7pRrRORBaRAw49UEFSzzRIACg1CXR
R1Ucry3SSPyR4LnawULOUQc=
=hp/I
-----END PGP SIGNATURE-----

--=-Y+l4GtW8g2GhsVEmLrF0--

