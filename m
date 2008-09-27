Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbYI0BVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbYI0BVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 21:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYI0BVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 21:21:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:65025 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbYI0BVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 21:21:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,317,1220252400"; 
   d="asc'?scan'208";a="52045994"
Subject: Re: [PATCH 2/4] x86: Add UV bios call infrastructure v2
From: Huang Ying <ying.huang@intel.com>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
In-Reply-To: <20080926200242.GC138671@sgi.com>
References: <20080926200242.GC138671@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/CoewJOhqIe5kbqHZbFx"
Date: Sat, 27 Sep 2008 09:21:35 +0800
Message-Id: <1222478495.28661.19.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/CoewJOhqIe5kbqHZbFx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-26 at 15:02 -0500, Russ Anderson wrote:
> Index: linux/include/asm-x86/efi.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/include/asm-x86/efi.h	2008-09-26 14:13:24.000000000 -0500
> +++ linux/include/asm-x86/efi.h	2008-09-26 14:13:36.000000000 -0500
> @@ -49,6 +49,20 @@ extern u64 efi_call5(void *fp, u64 arg1,
>  extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
>  		     u64 arg4, u64 arg5, u64 arg6);
> =20
> +
> +#ifndef CONFIG_EFI
> +/*
> + * IF EFI is not configured, have the EFI calls return -ENOSYS.
> + */
> +#define efi_call0(_f)					(-ENOSYS)
> +#define efi_call1(_f, _a1)				(-ENOSYS)
> +#define efi_call2(_f, _a1, _a2)				(-ENOSYS)
> +#define efi_call3(_f, _a1, _a2, _a3)			(-ENOSYS)
> +#define efi_call4(_f, _a1, _a2, _a3, _a4)		(-ENOSYS)
> +#define efi_call5(_f, _a1, _a2, _a3, _a4, _a5)		(-ENOSYS)
> +#define efi_call6(_f, _a1, _a2, _a3, _a4, _a5, _a6)	(-ENOSYS)
> +#endif /* CONFIG_EFI */
> +
>  #define efi_call_phys0(f)			\
>  	efi_call0((void *)(f))
>  #define efi_call_phys1(f, a1)			\

efi_call_virt<n> and efi_call_phys<n> is the API instead of efi_call<n>.
And please put the implementation without CONFIG_EFI defined out of

#ifdef CONFIG_X86_32
<...>
#else
<...>
#endif

Best Regards,
Huang Ying


--=-/CoewJOhqIe5kbqHZbFx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjdipwACgkQKhFGF+eHlphRpgCglb6PRLPtRU5orbnZzCQU9QBX
erkAoIdi+itqpjVG8bV9dUqZB8jL57zG
=FNzl
-----END PGP SIGNATURE-----

--=-/CoewJOhqIe5kbqHZbFx--

