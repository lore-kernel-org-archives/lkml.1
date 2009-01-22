Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbZAVHQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbZAVHQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 02:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbZAVHQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 02:16:03 -0500
Received: from mga14.intel.com ([143.182.124.37]:39008 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbZAVHQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 02:16:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,305,1231142400"; 
   d="asc'?scan'208";a="102628848"
Subject: Re: [RFC] per-CPU cryptd thread implementation based on workqueue
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090122030400.GA10229@gondor.apana.org.au>
References: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com>
	 <20090116033105.GB10390@gondor.apana.org.au>
	 <1232591537.6101.3.camel@yhuang-dev.sh.intel.com>
	 <20090122030400.GA10229@gondor.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HCUmRwpk6pJrQeYMNJve"
Date: Thu, 22 Jan 2009 15:15:58 +0800
Message-Id: <1232608558.6101.13.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HCUmRwpk6pJrQeYMNJve
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-22 at 11:04 +0800, Herbert Xu wrote:
> On Thu, Jan 22, 2009 at 10:32:17AM +0800, Huang Ying wrote:
> >
> > This is the first attempt to use a dedicate workqueue for crypto. It is
> > not intended to be merged. Please feedback your comments, especially on
> > desgin.
>=20
> Thanks for the patch!
>=20
> > +		spin_lock_init(&cpu_queue->lock);
>=20
> Since we're switching to per-cpu queues it would be good to just
> kill the spin lock.  AFAICS the only place you really need it is
> in cryptd_tfm_in_queue.  That's just used for debugging so we can
> just kill it and lose this spin lock.

Yes. Except that, now we do not need a spin lock really. I think the
spin lock may be useful if we enqueue a request on other CPU's queue to
do load balance. And if it is possible that the work_struct to be
executed on CPU other original CPU for CPU hotplug (current code do
not).

Best Regards,
Huang Ying
=20

--=-HCUmRwpk6pJrQeYMNJve
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl4HSsACgkQKhFGF+eHlph70gCgq3w+nr0llPzdXYp0MjTQUL0L
DNAAn3ihB5CvTwHKvoZdmdBF9ANf7HX9
=nGXe
-----END PGP SIGNATURE-----

--=-HCUmRwpk6pJrQeYMNJve--

