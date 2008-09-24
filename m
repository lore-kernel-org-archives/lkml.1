Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbYIXDVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbYIXDVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 23:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYIXDVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 23:21:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:29635 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbYIXDVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 23:21:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,297,1220252400"; 
   d="asc'?scan'208";a="442913346"
Subject: Re: [PATCH 2/4] x86: Add UV bios call infrastructure
From: Huang Ying <ying.huang@intel.com>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
In-Reply-To: <20080922210928.GE222374@sgi.com>
References: <20080922210928.GE222374@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PvrdG1igBDU/rwtqSskX"
Date: Wed, 24 Sep 2008 11:20:57 +0800
Message-Id: <1222226457.23099.114.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PvrdG1igBDU/rwtqSskX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Russ,

On Mon, 2008-09-22 at 16:09 -0500, Russ Anderson wrote:
> +
> +s64 uv_bios_call(int which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
>  {
> -	const char *str;
> -	switch (status) {
> -	case  0: str =3D "Call completed without error";	break;
> -	case -1: str =3D "Not implemented";		break;
> -	case -2: str =3D "Invalid argument";		break;
> -	case -3: str =3D "Call completed with error";	break;
> -	default: str =3D "Unknown BIOS status code";	break;
> -	}
> -	return str;
> +	struct sal_systab *tab =3D &sal_systab;
> +
> +	if (tab->function =3D=3D (unsigned long)NULL)
> +		/*
> +		 * BIOS does not support SAL systab
> +		 */
> +		return BIOS_STATUS_UNIMPLEMENTED;
> +
> +	return efi_call6((void *)__va(tab->function),
> +					which, a1, a2, a3, a4, a5);
>  }
[...]
> +#else	/* !CONFIG_EFI */
> +/*
> + * IF EFI is not configured, have the EFI calls return unimplemented.
> + */
> +u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
> +			u64 arg4, u64 arg5, u64 arg6)
> +{
> +	return  BIOS_STATUS_UNIMPLEMENTED;
> +}
> +
> +void uv_bios_init(void) { }
> +#endif
> +
[...]
> +
> +#ifndef CONFIG_EFI
> +extern u64 efi_call6(void *, u64, u64, u64, u64, u64, u64);
> +#endif

Either wrap efi_call6() in uv_bios_call() inside #ifdef CONFIG_EFI, or
add efi_call<x>() implementation when CONFIG_EFI is undefined into
include/asm-x86/efi.h.

Best Regards,
Huang Ying


--=-PvrdG1igBDU/rwtqSskX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjZshYACgkQKhFGF+eHlpgw1wCfU568Ggss7UCQhD3To2O0LmMt
WdUAn3T2oox2k8Hj+BpDs/776OSry1iU
=xaZB
-----END PGP SIGNATURE-----

--=-PvrdG1igBDU/rwtqSskX--

