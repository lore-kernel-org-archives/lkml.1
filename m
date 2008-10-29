Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYJ2Imq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYJ2Imq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 04:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYJ2Imi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 04:42:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:30345 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbYJ2Imh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 04:42:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,505,1220252400"; 
   d="asc'?scan'208";a="353470117"
Subject: Re: [PATH -mm -v2] Fix a race condtion of oops_in_progress
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081029083434.GC6364@elte.hu>
References: <1225268796.24095.48.camel@yhuang-dev.sh.intel.com>
	 <20081029083434.GC6364@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lXr6ZGOsQRQydq2zETKM"
Date: Wed, 29 Oct 2008 16:42:16 +0800
Message-Id: <1225269736.24095.50.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lXr6ZGOsQRQydq2zETKM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-29 at 02:34 -0600, Ingo Molnar wrote:
> * Huang Ying <ying.huang@intel.com> wrote:
>=20
> > Fix a race condition accessing oops_in_progress.  Which may be=20
> > changed on multiple CPU simultaneously, but it is changed via=20
> > non-atomic operation ++/--.  This patch changes the definition of=20
> > oops_in_process from int to atomic_t, and accessing method to atomic=20
> > operations.
> >=20
> >=20
> > ChangeLog
> >=20
> > v2:
> >=20
> > - Includes fixes from Andrew Moton.
> >=20
> > - Re-based on Matthew Wilcox's new atomic_t patch.
>=20
> hm, there are a couple of places now that do atomic_set(,1) - they=20
> should be atomic_inc(), correct?

I just translate "oops_in_progress =3D 1" to
"atomic_set(&oops_in_progress, 1)". I think this is the safest method to
do the translation.

Best Regards,
Huang Ying=20


--=-lXr6ZGOsQRQydq2zETKM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkIIeMACgkQKhFGF+eHlpgiOQCgk/jvUlfyqnrFa80XGtGVcXFG
s+0An1Rfwfa72d5Yfr2xTecB+/FHUOP7
=liIB
-----END PGP SIGNATURE-----

--=-lXr6ZGOsQRQydq2zETKM--

