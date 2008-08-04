Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbYHDR0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbYHDR0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbYHDRZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:25:55 -0400
Received: from home.keithp.com ([63.227.221.253]:2520 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbYHDRZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:25:55 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: keithp@keithp.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0808041720500.25617@blonde.site>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <200808041902.23970.nickpiggin@yahoo.com.au>
	 <1217845590.24714.45.camel@koto.keithp.com>
	 <200808042043.46710.nickpiggin@yahoo.com.au>
	 <1217850352.24714.66.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808041720500.25617@blonde.site>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ek0rv7+5nKTwFBB8kq6f"
Date: Mon, 04 Aug 2008 10:25:48 -0700
Message-Id: <1217870748.24714.79.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ek0rv7+5nKTwFBB8kq6f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 18:09 +0100, Hugh Dickins wrote:

> Whether such usage conforms to VFS API I'm not so sure: as I understand
> it, it's really for internal use by a filesystem

Sure, but presumably it could even be used by a layered file system?

>  - if it's going to be
> used beyond that, we ought to add a check that the filesystem it's used
> upon really has a ->readpage method (and I'd rather we add such a check
> than you do it at your end, in case we change the implementation later
> to use something other than a ->readpage method - Nick, you'll be
> nauseated to hear I was looking to see if ->fault with a pseudo-vma
> could do it).  But if the layering police are happy with this, I am.

It seems like I should put a check into my code that is kernel version
dependent so that I can't oops if someone tries to use a filesystem that
doesn't have ->readpage.

> But that route is in
> use and well-tested, and only an inefficiency when swapping, so should
> not cause you any problems.

Yeah, swapping performance isn't my primary concern; I looked through
the read_mapping_page codepath and it looked exactly like my existing
code in the fast path, which is why I was able to just delete all of
that from my driver and just call read_mapping_page.

So, when I release the pages from the page cache, I'm currently calling
mark_page_accessed for all pages, and set_page_dirty for pages which may
have been written by the GPU. Are those calls still needed?

--=20
keith.packard@intel.com

--=-Ek0rv7+5nKTwFBB8kq6f
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIlzucQp8BWwlsTdMRAlswAKDjmAQRCRLn2V33m0RgNtqBUJw96wCgkzTS
6iA25iAlKTaFSE2ELdbZ9cI=
=QNlb
-----END PGP SIGNATURE-----

--=-Ek0rv7+5nKTwFBB8kq6f--

