Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbZDXGf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbZDXGf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbZDXGfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:35:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:50402 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbZDXGfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:35:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,240,1239001200"; 
   d="asc'?scan'208";a="135376477"
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <49F15922.5090704@jp.fujitsu.com>
References: <20090407506.675031434@firstfloor.org>
	 <20090407150656.43E161D046D@basil.firstfloor.org>
	 <49DC5D11.4060505@jp.fujitsu.com>
	 <1240479833.6842.554.camel@yhuang-dev.sh.intel.com>
	 <49F15922.5090704@jp.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-31tqgh/alnAIr1T4B27x"
Date: Fri, 24 Apr 2009 14:35:11 +0800
Message-Id: <1240554911.6842.880.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-31tqgh/alnAIr1T4B27x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-24 at 14:16 +0800, Hidetoshi Seto wrote:
> Huang Ying wrote:
> > Add some description for the patch, hope that to be more clear.
> >=20
> > Best Regards,
> > Huang Ying
> > --------------------------------------------->
> > mce_get_rip() is used to get IP when MCE is generated, usually from
> > the stack. But the IP on the stack is not always valid.
> > MCG_STATUS_RIPV indicates program can restart from the IP on the stack,
> > so if it is set, the IP is valid. MCG_STATUS_EIPV indicate IP on the
> > stack is directly associated with the error, so if it is set, the IP
> > is valid too.
> >=20
> > In current implementation, no IP will be returned (and then reported)
> > if MCG_STATUS_RIPV is not set and MCG_STATUS_EIPV is set. This patch
> > fixes this issue by returning IP on the stack when MCG_STATUS_EIPV is
> > set.
> >=20
> > In some CPU, a MSR (rip_msr) provides another way to get IP when MCE
> > is generated. This is used by mce_get_rip() too.
> >=20
> > There is no MSR for CS, in current implementation, if rip_msr is used
> > to get IP, reported CS is set to 0. But in fact, the CS on the stack
> > can be trusted if MCG_STATUS_RIPV or MCG_STATUS_EIPV is set. This
> > patch fixes this issue by keeping reported CS when rip_msr is used.
>=20
> So the bug is in short:
>  In some cases no IP/CS reported even there were valid records.
> Right?
>=20
> Then in other words it will mean lost of error information, that is not
> good for error investigation.
>=20
> One question is: if (RIPV,EIPV) =3D (0,0), then is the IP on the stack
> really invalid value, or is it still point IP when MCE is generated?
> I suppose it is not invalid.  If a processor encounters MCE and if it
> is not sure what happened, then it will store the IP on the stack,
> indicating neither of flags.
>=20
> If this supposition is correct, the best way is pick the value on
> the stack unconditionally, and record valid flags together.

According to spec, the IP on stack can be not related to MCE if
(RIPV,EIPV) =3D (0,0). So it is meaningless to report them. If you report
them unconditionally, you just push the logic to user space or
administrator.

Best Regards,
Huang Ying


--=-31tqgh/alnAIr1T4B27x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknxXZsACgkQKhFGF+eHlpgw+ACgpveWTIzkKm4TpA5BKGMW8HHS
WhUAnA7d28p78zaM7uKcjYEo/yne6Jy3
=q5L5
-----END PGP SIGNATURE-----

--=-31tqgh/alnAIr1T4B27x--

