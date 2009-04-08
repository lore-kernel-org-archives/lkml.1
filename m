Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbZDHCeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbZDHCeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 22:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbZDHCeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 22:34:03 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:35291 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694AbZDHCeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 22:34:02 -0400
Subject: Re: Regression X Hangs at bootup -- PATCH
From: Eric Anholt <eric@anholt.net>
To: Florian Mickler <florian@mickler.org>
Cc: LKML <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       airlied@linux.ie, keithp@keithp.com
In-Reply-To: <20090407221425.3dc1831e@schatten>
References: <20090406225541.0e1e043b@schatten>
	 <1239069835.31656.109.camel@gaiman.anholt.net>
	 <20090407092346.058d19a0@schatten>
	 <1239121300.9617.0.camel@gaiman.anholt.net>
	 <20090407221425.3dc1831e@schatten>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-v+2CDLp/AhxkfRZpHIQ5"
Date: Tue, 07 Apr 2009 19:33:59 -0700
Message-Id: <1239158039.19045.6.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-v+2CDLp/AhxkfRZpHIQ5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 22:14 +0200, Florian Mickler wrote:
> On Tue, 07 Apr 2009 09:21:40 -0700
> Eric Anholt <eric@anholt.net> wrote:
>=20
>=20
> > drm_free's other arguments are unused memory debug leftovers.  I've
> > got a patch I need to push at airlied to remove
> > drm_malloc/drm_calloc/drm_free.
> >=20
> in that case it is of course a non issue. but would you mind=20
> to add a note like 'this adds a memleak to i915_gem_put_relocs_to_user
> which will be fixed in a followup patch', or just rebase it onto that
> patch?=20

Just to be clear, there is no memleak:

/** Wrapper around kfree() */
static __inline__ void drm_free(void *pt, size_t size, int area)
{
	kfree(pt);
}

The arg would only get used if DRM_DEBUG_MEMORY was set, but there's no
way in the kernel to do so.  I don't think anybody's used it in years,
and I'm sure there would be broken drm_free arguments since it's
untested.  It was never very useful even back in the day, since most
everything ended up lumped under DRM_MEM_DRIVER.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-v+2CDLp/AhxkfRZpHIQ5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkncDRQACgkQHUdvYGzw6vcr0wCcDRvMEBPClQISfymfwkqiFAht
LGwAnjOBfyJItLka7GDO7lYpCKdgh78Y
=mPrW
-----END PGP SIGNATURE-----

--=-v+2CDLp/AhxkfRZpHIQ5--
