Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbYKYBac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbYKYBac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 20:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYKYBaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 20:30:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:29842 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbYKYBaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 20:30:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,661,1220252400"; 
   d="asc'?scan'208";a="407652106"
Subject: Re: v2.6.28-rc2: x86_32 relocation regression?
From: Huang Ying <ying.huang@intel.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <19f34abd0811241319u1abf5e77xc2359b4e8d17b518@mail.gmail.com>
References: <19f34abd0811241319u1abf5e77xc2359b4e8d17b518@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Svkht938fP7Rm6EZcp0j"
Date: Tue, 25 Nov 2008 09:30:20 +0800
Message-Id: <1227576620.2442.7.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Svkht938fP7Rm6EZcp0j
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Vegard,

On Tue, 2008-11-25 at 05:19 +0800, Vegard Nossum wrote:
[...]
> It looks like everything was offset by 0xe00000:
>=20
>     $ addr2line -e vmlinux c119e613
>     arch/x86/lib/string_32.c:20

Because relocation is supported in recent Linux kernel, it is possible
that the run-time address is different with compile-time address. In
most cases, the kernel will be loaded into 0x100000 during boot, so the
kernel run-time address range from 0xc0100000 on. But it seems that your
kernel compile-time address range from 0xc0f00000 on. Please check
CONFIG_PHYSICAL_START in your .config. In most cases, it will be set to
0x100000, so that it is same as run-time address in most cases.

Best Regards,
Huang Ying


--=-Svkht938fP7Rm6EZcp0j
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkrVSkACgkQKhFGF+eHlpi5kwCfXNPG1NIuPW7c69ScV7nWiC0s
dwMAnRyYNTGKNBsHrqdCbow5wXdb79SD
=dHgw
-----END PGP SIGNATURE-----

--=-Svkht938fP7Rm6EZcp0j--

