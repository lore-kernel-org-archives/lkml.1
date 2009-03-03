Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbZCCBH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbZCCBH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 20:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756816AbZCCBHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 20:07:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:46386 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbZCCBHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 20:07:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,292,1233561600"; 
   d="asc'?scan'208";a="494382871"
Subject: Re: [PATCH] Fix e820 end address with EFI
From: Huang Ying <ying.huang@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Maly <bmaly@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49AC51D7.1080203@kernel.org>
References: <49A965AD.10701@redhat.com>
	 <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>
	 <49AAEC79.3000808@redhat.com>
	 <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>
	 <49AB38E7.60305@redhat.com>
	 <1235960016.6204.170.camel@yhuang-dev.sh.intel.com>
	 <49AB4171.7000508@kernel.org>
	 <1235960708.6204.176.camel@yhuang-dev.sh.intel.com>
	 <49AB4521.8010909@kernel.org>
	 <1235961428.6204.190.camel@yhuang-dev.sh.intel.com>
	 <86802c440903011851t17e240eu9dc25116a40ca85e@mail.gmail.com>
	 <1235979959.6204.212.camel@yhuang-dev.sh.intel.com>
	 <49AC51D7.1080203@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3tNfEsOnpskYMI1b5I0b"
Date: Tue, 03 Mar 2009 09:07:39 +0800
Message-Id: <1236042459.6204.226.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3tNfEsOnpskYMI1b5I0b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-03 at 05:38 +0800, Yinghai Lu wrote:
> Huang Ying wrote:
> > On Mon, 2009-03-02 at 10:51 +0800, Yinghai Lu wrote:
> >> On Sun, Mar 1, 2009 at 6:37 PM, Huang Ying <ying.huang@intel.com> wrot=
e:
> >>>> so 64bit could use ioremap_cache() too?
> >>>> we may keep 32bit and 64bit a bit consistent.
> >>> If we use ioremap_cache(), kexec runtime service will not work in kex=
ec
> >>> situation, which needs EFI runtime memory area to be mapped at exact
> >>> same location across kexec. I think we should support kexec if possib=
le.
> >>
> >> sure.
> >>
> >> please don't touch max_low_pfn_mapped, because some range may not
> >> directly mapped under those efi run-time code
> >=20
> > Find an issue to use init_memory_mapping() here.
> >=20
> > If the memory range to be mapped is less than 2M, the last mapped
> > address may be next 2M aligned position, this may lead mapping
> > overlapping between memory range. Such as:
> >=20
> > 0x3f388000 - 0x3f488000: real mapped	0x3f388000 - 0x3f600000
> > 0x3f590000 - 0x3f5bb000: real mapped	0x3f590000 - 0x3f600000
> >=20
> > The problem is that the memory range 0x3f400000 - 0x3f590000 is left no=
t
> > mapped!
>=20
> what is max_low_pfn_mapped before that?

I don't know exactly what you mean. Can you elaborate a little?

0 ~ max_low_pfn_mapped ~ max_pfn_mapped can be mapped with
init_memory_mapping() properly.

The issue of above example is that 0x3f400000 ~ 0x3f488000 is a
sub-range of 0x3f388000 ~ 0x3f488000, which should be mapped but is left
not mapped.

Best Regards,
Huang Ying


--=-3tNfEsOnpskYMI1b5I0b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmsgtQACgkQKhFGF+eHlpgoAwCfZGdkw+efGOqdJodnMjKY4mve
6S0An0qTHJ/B9aF4h+yYjMrRFSxwaVk9
=h0v1
-----END PGP SIGNATURE-----

--=-3tNfEsOnpskYMI1b5I0b--

