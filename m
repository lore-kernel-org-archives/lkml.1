Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbZDXIwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbZDXIwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZDXIwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:52:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:26256 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZDXIwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:52:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,240,1239001200"; 
   d="asc'?scan'208";a="135415169"
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <49F16A38.1030306@jp.fujitsu.com>
References: <20090407506.675031434@firstfloor.org>
	 <20090407150656.43E161D046D@basil.firstfloor.org>
	 <49DC5D11.4060505@jp.fujitsu.com>
	 <1240479833.6842.554.camel@yhuang-dev.sh.intel.com>
	 <49F15922.5090704@jp.fujitsu.com>
	 <1240554911.6842.880.camel@yhuang-dev.sh.intel.com>
	 <49F16A38.1030306@jp.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-odkzvjh8amXoJKuDG3SJ"
Date: Fri, 24 Apr 2009 16:52:27 +0800
Message-Id: <1240563147.6842.891.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-odkzvjh8amXoJKuDG3SJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-24 at 15:28 +0800, Hidetoshi Seto wrote:
> Huang Ying wrote:
> > On Fri, 2009-04-24 at 14:16 +0800, Hidetoshi Seto wrote:
> >> One question is: if (RIPV,EIPV) =3D (0,0), then is the IP on the stack
> >> really invalid value, or is it still point IP when MCE is generated?
> >> I suppose it is not invalid.  If a processor encounters MCE and if it
> >> is not sure what happened, then it will store the IP on the stack,
> >> indicating neither of flags.
> >>
> >> If this supposition is correct, the best way is pick the value on
> >> the stack unconditionally, and record valid flags together.
> >=20
> > According to spec, the IP on stack can be not related to MCE if
> > (RIPV,EIPV) =3D (0,0). So it is meaningless to report them. If you repo=
rt
> > them unconditionally, you just push the logic to user space or
> > administrator.
>=20
> Sorry, I could not find good page in the spec (Intel64 and IA-32 ASDM)...
> Could you point one?

14.3.1.2 IA32_MCG_STATUS MSR
* EIPV

> I believe that the IP with (RIPV,EIPV) =3D (1,0) is "not associated with =
the
> error" too, so is it meaningless to report the IP?
> If you think so then correct fix is replacing RIPV check by EIPV check.

In theory, that is possible (not associated), but I think in practical,
IP with (RIPV,EIPV) =3D (1,0) is still meaningful as Andi said.

> From another point of view, the reported IP will be one of followings:
>   - IP that associated with error (=3D related to MCE)
>   - IP that the interrupted program can restart from
>   - IP that when MCE is generated
> Are there no way to distinguish them in user space?

I think you just push same logic to user space.

Best Regards,
Huang Ying


--=-odkzvjh8amXoJKuDG3SJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknxfcIACgkQKhFGF+eHlphk0gCfatgSF7elOVNEz2PxsOnVm4+n
IbQAoK1HEbBKXhUxoNuoshrY0poKUefX
=IEWC
-----END PGP SIGNATURE-----

--=-odkzvjh8amXoJKuDG3SJ--

