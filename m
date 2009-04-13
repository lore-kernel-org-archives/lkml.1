Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbZDMCly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbZDMCly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 22:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZDMCln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 22:41:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:56187 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbZDMClm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 22:41:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,178,1239001200"; 
   d="asc'?scan'208";a="402541878"
Subject: Re: [PATCH] Add MCE support to KVM
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <49E08762.1010206@redhat.com>
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>
	 <49DE195D.1020303@redhat.com>
	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>
	 <49E08762.1010206@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mUoLZyOnorH1UZKHQJHq"
Date: Mon, 13 Apr 2009 10:41:39 +0800
Message-Id: <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mUoLZyOnorH1UZKHQJHq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-11 at 20:04 +0800, Avi Kivity wrote:
> >> Why not always allocate it on vcpu setup?
> >>    =20
> >
> > Because the MCE bank number is not fixed, it is based on mcg_cap from
> > user space.
> >  =20
>=20
> Right, but we can allocate the maximum number, no?  it's a fairly small=20
> amount of memory.

OK. If you are OK with 8k extra memory usage.
  =20
> >  =20
> >>> +	case KVM_X86_SETUP_MCE: {
> >>> +		u64 mcg_cap;
> >>> +
> >>> +		r =3D -EFAULT;
> >>> +		if (copy_from_user(&mcg_cap, argp, sizeof mcg_cap))
> >>> +			goto out;
> >>> +		/*
> >>> +		 * extended machine-check state registers and CMCI are
> >>> +		 * not supported.
> >>> +		 */
> >>> +		mcg_cap &=3D ~(MCG_EXT_P|MCG_CMCI_P);
> >>>  =20
> >>>      =20
> >> Instead of silently dropping, should return an error.
> >>
> >>    =20
> >>> +		if (copy_to_user(argp, &mcg_cap, sizeof mcg_cap))
> >>> +			goto out;
> >>>  =20
> >>>      =20
> >> And not copy.
> >>    =20
> >
> > This is designed as some kind of feature negotiating. Use space request
> > MCE features via mcg_cap, kernel space remove un-supported features and
> > return the resulting mcg_cap.
> >  =20
>=20
> kvm does feature negotiation (really, feature advertising) using=20
> KVM_CAP_... and KVM_CHECK_EXTENSION.  So there's no need for this.

It is not only feature advertising, but also something like CPUID. Based
on CPU type specified in command line (qemu -cpu ?), different mcg_cap
can be used to determine number of MCE banks and various features of MCE
(MCG_CTL_P, MCG_TES_P, MCG_CMCI, etc) for specified CPU type. With KVM
feature advertising, we can only check whether MCE simulation is
supported, but can not set parameters of MCE simulation.

Maybe this interface can be changed to KVM_SET_MSRS, with
MSR_IA32_MCG_CAP be set by kvm-qemu. But MSR_IA32_MCG_CAP is read-only
by spec, and current interface can not distinguishes between MSR set
from guest system and MSR setup from kvm-qemu. I think there should be
other read-only MSRs need to be setup during guest system
creation/setup. How about add a interface such as KVM_SETUP_MSRS to
setup the value of read-only MSRs?

Best Regards,
Huang Ying


--=-mUoLZyOnorH1UZKHQJHq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknipmAACgkQKhFGF+eHlpiYAwCglkIgorNQpJDBh/Ba7BkSD54V
3coAn0Zb38kNANUlIMk+Ot+F6rSvjP48
=WQjQ
-----END PGP SIGNATURE-----

--=-mUoLZyOnorH1UZKHQJHq--

