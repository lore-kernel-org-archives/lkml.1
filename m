Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbYJSVFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbYJSVFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 17:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYJSVFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 17:05:03 -0400
Received: from home.keithp.com ([63.227.221.253]:34522 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbYJSVFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 17:05:01 -0400
Subject: Re: io resources and cached mappings (was: [git pull] drm patches
	for 2.6.27-rc1)
From: Keith Packard <keithp@keithp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: keithp@keithp.com, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20081019175320.GA6442@elte.hu>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <200810181237.49784.nickpiggin@yahoo.com.au>
	 <1224357062.4384.72.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com>
	 <1224398496.5303.7.camel@koto.keithp.com>  <20081019175320.GA6442@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0VdByRzYbljFa1egThHw"
Date: Sun, 19 Oct 2008 14:04:51 -0700
Message-Id: <1224450291.5303.23.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0VdByRzYbljFa1egThHw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-19 at 19:53 +0200, Ingo Molnar wrote:

> Note how simple and consistent it all gets: IO resources already know=20
> their physical location and their size limits. Being able to cache an=20
> ioremap in a mapping [and being able to use atomic kmaps on 32-bit] is a=20
> relatively simple and natural extension to the concept.

I'm not sure I see any value in caching mappings here; we're mostly
interested in copying lots of data onto the card and so we use a lot of
different mappings; atomic mappings are easy to use, and efficient
enough.

Also, if we're using a resource, I'd like to just use byte offsets and
not pfns; the resource presumably knows the base address.

> i think we need to finalize the API names and their abstraction level,=20
> and then could even merge those APIs into v2.6.28 on a fast path, to=20
> enable you to use it. It does not interact with anything else so it=20
> should be safe to do.

Let's figure out the API we want, then figure out whether it makes sense
to stick it into 2.6.28 or whether we just want to wait for .29. I don't
mind rewriting the driver for the next release.

I will probably use something like the io_reserve stuff for .28 though;
it makes the code easier to read and gives us good performance on 64 bit
kernels.

--=20
keith.packard@intel.com

--=-0VdByRzYbljFa1egThHw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI+6DzQp8BWwlsTdMRAqmxAJ9FziebA91LFkDDzflZTWuSeBd9owCg4DVm
kdSrpHDmhSK7vkWxtuV/LAU=
=XvUM
-----END PGP SIGNATURE-----

--=-0VdByRzYbljFa1egThHw--

