Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbZCZEMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbZCZEMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 00:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZCZEM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 00:12:28 -0400
Received: from home.keithp.com ([63.227.221.253]:56501 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbZCZEM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 00:12:28 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2009 00:12:27 EDT
Subject: Re: [PATCH 4/6] drm/i915: Fix lock order reversal in shmem pread
	path.
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0903252328590.27027@skynet.skynet.ie>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <1238017510-26784-2-git-send-email-eric@anholt.net>
	 <1238017510-26784-3-git-send-email-eric@anholt.net>
	 <1238017510-26784-4-git-send-email-eric@anholt.net>
	 <1238017510-26784-5-git-send-email-eric@anholt.net>
	 <alpine.DEB.2.00.0903252328590.27027@skynet.skynet.ie>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NZOtivrmD3fBmnpfQmXa"
Date: Wed, 25 Mar 2009 21:03:13 -0700
Message-Id: <1238040193.26771.186.camel@aiko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NZOtivrmD3fBmnpfQmXa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-25 at 23:30 +0000, Dave Airlie wrote:
>=20
> I've no idea when a fault is likely in the fast case, i.e. will it happen
> usually on the first page etc, because if it happens on the last page and=
=20
> you fallback and restart the whole copy, I would think that would be=20
> sub-optimal, granted it could get ugly quick, but this code has already=20
> hit a few branches on the tree.

The data in question is presumably 'hot', and so unlikely to be swapped
out. Testing the slow paths doing a complete copy is fairly easy, while
testing partial copies would be considerably more difficult. The
combination of these two seems to encourage a careful and simplistic
slow path.

We can always make it 'faster' in the future, but having it wrong from
the first seems sub-optimal.

--=20
keith.packard@intel.com

--=-NZOtivrmD3fBmnpfQmXa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJyv6BQp8BWwlsTdMRAjokAKDcXwteMwFlxf5eY0whr8+Ta2sa1ACfSDvZ
xtUZ4JYVyZnufH2bmtvB/yI=
=/NQW
-----END PGP SIGNATURE-----

--=-NZOtivrmD3fBmnpfQmXa--

