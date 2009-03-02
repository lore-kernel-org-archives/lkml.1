Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbZCBCh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbZCBCh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 21:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbZCBChN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 21:37:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:6634 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299AbZCBChM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 21:37:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,286,1233561600"; 
   d="asc'?scan'208";a="390738458"
Subject: Re: [PATCH] Fix e820 end address with EFI
From: Huang Ying <ying.huang@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Maly <bmaly@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49AB4521.8010909@kernel.org>
References: <49A965AD.10701@redhat.com>
	 <86802c440902282014he17bb6an1f59872ef30db0c5@mail.gmail.com>
	 <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>
	 <49AAEC79.3000808@redhat.com>
	 <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>
	 <49AB38E7.60305@redhat.com>
	 <1235960016.6204.170.camel@yhuang-dev.sh.intel.com>
	 <49AB4171.7000508@kernel.org>
	 <1235960708.6204.176.camel@yhuang-dev.sh.intel.com>
	 <49AB4521.8010909@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kOWicOOpjAzNO7p2qTmM"
Date: Mon, 02 Mar 2009 10:37:08 +0800
Message-Id: <1235961428.6204.190.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kOWicOOpjAzNO7p2qTmM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-02 at 10:32 +0800, Yinghai Lu wrote:
> Huang Ying wrote:
> > On Mon, 2009-03-02 at 10:16 +0800, Yinghai Lu wrote:
> >> Huang Ying wrote:
> >>> On Mon, 2009-03-02 at 09:39 +0800, Brian Maly wrote:
> >>>> Huang Ying wrote:=20
> >>>>> Hi, Brian,
> >>>>>
> >>>>> On Mon, 2009-03-02 at 04:13 +0800, Brian Maly wrote:
> >>>>>  =20
> >>>>>> I was able verify the kernel that does not boot on the MacBook (va=
nilla=20
> >>>>>> 2.6.29-rc4) does call efi_ioremap() which bails out early returnin=
g=20
> >>>>>> NULL. So no remapping happens in this case.  I have no idea if=20
> >>>>>> efi_ioremap ever does succeed in mapping any ranges though being I=
 have=20
> >>>>>> no video or console this early in the boot and have to rely on tri=
ple=20
> >>>>>> faulting as a means of debugging.
> >>>>>>    =20
> >>>>> Please attach your dmesg of successful boot, so we can take a look =
at
> >>>>> the EFI memory map.
> >>>>>
> >>>>> Best Regards,
> >>>>> Huang Ying
> >>>>>  =20
> >>>> This dmesg is from a 2.6.25 kernel which works fine. I can gather
> >>>> other debugging info from the booting kernels if needed. But its a
> >>>> challenge to debug the bad kernel being efifb is initialized very la=
te
> >>>> (so you never even get to the video initialization and cant see any
> >>>> logged messages) and since its a MacBook I dont have a real serial
> >>>> port for serial console. The efi map is for MacBook has a different
> >>>> layout from other EFI systems I have to test on. 2.6.29 kernel works
> >>>> on every EFI system I have except MacBook.
> >>> It seems that you have an EFI system which has too big runtime area.
> >>>
> >>> EFI: mem44: type=3D0, attr=3D0x8000000000000000, range=3D[0x000000007=
ff00000-0x0000000080000000) (1MB)
> >>>
> >>> efi_ioremap() can map only memory range < 400k now.
> >>>
> >>> It seems that efi_ioremap is the bottle net now. Can we just use
> >>> init_memory_mapping() instead of efi_ioremap() for EFI runtime area?
> >>>
> >>> Yinghai, how about your opinion?
> >> you could call init_memory_maping() in that efi_ioremap position?
> >>
> >> problems is how about 32bit?
> >=20
> > efi_ioremap() is defined as ioremap_cache() on 32bit system. As that in
> > arch/x86/include/asm/efi.h.
> >=20
> > On 64bit system, efi_ioremap() can be a wrapper for
> > init_memory_mapping(). Do you think it is appropriate?
>=20
> so 64bit could use ioremap_cache() too?
> we may keep 32bit and 64bit a bit consistent.

If we use ioremap_cache(), kexec runtime service will not work in kexec
situation, which needs EFI runtime memory area to be mapped at exact
same location across kexec. I think we should support kexec if possible.

Best Regards,
Huang Ying


--=-kOWicOOpjAzNO7p2qTmM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmrRlAACgkQKhFGF+eHlpjYYACfZKhex+7ewsMncxc5gNbRlXwZ
47UAnjVB5erzMBrwkCHE6Anm2IGZ/xEl
=vsW3
-----END PGP SIGNATURE-----

--=-kOWicOOpjAzNO7p2qTmM--

