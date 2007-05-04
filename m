Return-Path: <linux-kernel-owner+w=401wt.eu-S1767669AbXEDEc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767669AbXEDEc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 00:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767672AbXEDEc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 00:32:57 -0400
Received: from home.keithp.com ([63.227.221.253]:3363 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767669AbXEDEcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 00:32:54 -0400
X-Greylist: delayed 1525 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2007 00:32:54 EDT
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
From: Keith Packard <keithp@keithp.com>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <46391860.3070409@tungstengraphics.com>
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>
	 <1178137279.53297.114.camel@vonnegut>
	 <46391860.3070409@tungstengraphics.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2CBnoYqIh1NCPsbdjWIE"
Date: Thu, 03 May 2007 21:07:01 -0700
Message-Id: <1178251621.27028.9.camel@neko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2CBnoYqIh1NCPsbdjWIE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-05-03 at 01:01 +0200, Thomas Hellstr=C3=B6m wrote:

> It might be possible to find schemes that work around this. One way=20
> could possibly be to have a buffer mapping -and validate order for=20
> shared buffers.

If mapping never blocks on anything other than the fence, then there
isn't any dead lock possibility. What this says is that ordering of
rendering between clients is *not DRMs problem*. I think that's a good
solution though; I want to let multiple apps work on DRM-able memory
with their own CPU without contention.

I don't recall if Eric layed out the proposed rules, but:

 1) Map never blocks on map. Clients interested in dealing with this=20
    are on their own.

 2) Submit blocks on map. You must unmap all buffers before submitting
    them. Doing the relocations in the kernel makes this all possible.

 3) Map blocks on the fence from submit. We can play with pending the
    flush until the app asks for the buffer back, or we can play with
    figuring out when flushes are useful automatically. Doesn't matter
    if the policy is in the kernel.

I'm interested in making deadlock avoidence trivial and eliminating any
map-map contention.

--=20
keith.packard@intel.com

--=-2CBnoYqIh1NCPsbdjWIE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGOrFlQp8BWwlsTdMRAsyLAKCompSXiYSyiXFTRPa5VNU9MD8nnACgwynO
tiY0QFw48VQlkOk0J5T6nJw=
=jUDR
-----END PGP SIGNATURE-----

--=-2CBnoYqIh1NCPsbdjWIE--
