Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZBBDa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZBBDa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 22:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbZBBDas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 22:30:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:11099 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbZBBDar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 22:30:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,362,1231142400"; 
   d="asc'?scan'208";a="105976899"
Subject: Re: [RFC] per-CPU cryptd thread implementation based on workqueue
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090122073040.GA12395@gondor.apana.org.au>
References: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com>
	 <20090116033105.GB10390@gondor.apana.org.au>
	 <1232591537.6101.3.camel@yhuang-dev.sh.intel.com>
	 <20090122030400.GA10229@gondor.apana.org.au>
	 <1232608558.6101.13.camel@yhuang-dev.sh.intel.com>
	 <20090122073040.GA12395@gondor.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ij6+OURCg9bxBSTFjr1N"
Date: Mon, 02 Feb 2009 11:30:25 +0800
Message-Id: <1233545425.19806.44.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ij6+OURCg9bxBSTFjr1N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-22 at 15:30 +0800, Herbert Xu wrote:
> On Thu, Jan 22, 2009 at 03:15:58PM +0800, Huang Ying wrote:

The only needed spin lock usage is cryptd_tfm_in_queue() now, I think we
can protect that via RCU, what's your opinions?

> > Yes. Except that, now we do not need a spin lock really. I think the
> > spin lock may be useful if we enqueue a request on other CPU's queue to
> > do load balance. And if it is possible that the work_struct to be
> > executed on CPU other original CPU for CPU hotplug (current code do
> > not).
>=20
> Right, but I think load-balancing should be explicitly enabled,
> i.e., we probably don't want to do it by default for AES-NI.
>=20
> The way I see load balancing work is if you had a template that
> sat on top of cryptd pass the requests to the cryptd on a CPU
> it chooses.

But I think the simplest method to pass requests to specified CPU is via
work queue (queue_work_on()). We can add a function named
cryptd_enqueue_request_on(), and construct a load-balance version cryptd
on top of that.

> Then we can enable it for any algorithm in the system simply
> by instantiating that template for it.

Well. At least we can just remove spin lock now, and if it is necessary
we can add that back without big effort.

Best Regards,
Huang Ying


--=-ij6+OURCg9bxBSTFjr1N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmGaMsACgkQKhFGF+eHlpgukgCglLTAp9lHHT4h+KzpPC2/6n6a
Sf0AoKhEP+1jcDOtlQVoDaStLyTM5Okg
=Mr/p
-----END PGP SIGNATURE-----

--=-ij6+OURCg9bxBSTFjr1N--

