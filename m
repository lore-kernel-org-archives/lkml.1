Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbZANCCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbZANCCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZANCCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:02:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:6010 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbZANCCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:02:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,261,1231142400"; 
   d="asc'?scan'208";a="378238209"
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090113174522.GA26965@elte.hu>
References: <20081227155019.GA15493@elte.hu>
	 <20081227225102.GA17822@elte.hu> <49594411.60000@linux.intel.com>
	 <20090113174522.GA26965@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rKYHO/CVuNE869qZ0+Y5"
Date: Wed, 14 Jan 2009 10:02:21 +0800
Message-Id: <1231898541.5937.143.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rKYHO/CVuNE869qZ0+Y5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-14 at 01:45 +0800, Ingo Molnar wrote:
> * Andi Kleen <ak@linux.intel.com> wrote:
>=20
> > Ingo Molnar wrote:
> >
> >>>> A far more useful design for handling MCE events would be to feed=20
> >>>> them into printk logging.
> >>> If there's ASCII logging it should be separate from normal printk.
> >>
> >> Well, why?=20
> >
> > Mostly because the problem is not a kernel issue. Especially large=20
> > systems with a lot of memory can generate a lot of corrected events (on=
e=20
> > bit flips in DIMMs are not that uncommon) and it's not good to mix that=
=20
> > all up into other kernel messages. It also makes it more clear that it'=
s=20
> > not a kernel problem, but a hardware problem. I've got feedback over th=
e=20
> > years that confirm this sight.
>=20
> Is your argument that syslog is not suitable for the logging of hw events=
?
>=20
> If that is your argument then the answer is to extend syslog with those=20
> aspects, instead of widening the quirky /dev based mce ABIs to achieve=20
> something similar.

In current /dev based mce ABI implementation, syslog is used for logging
hw events, not though printk, but through /dev/mcelog and /sbin/mcelog.

For uncorrected MCE, they should be logged via printk. But for corrected
MCE, there could be thousands/millions ones (imagining you have a DIMM
with one data pin corrupted). I don't think it's a good idea to blend
these hardware events with other kernel software events in printk.

Best Regards,
Huang Ying


--=-rKYHO/CVuNE869qZ0+Y5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkltR6oACgkQKhFGF+eHlphXDgCfWxRpfYcAiGiZi4f24hWRpU4Q
eqMAnRVeQch8CyHAgNoTVm2LnkSXwws2
=AlIH
-----END PGP SIGNATURE-----

--=-rKYHO/CVuNE869qZ0+Y5--

