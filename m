Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYI0BXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYI0BXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 21:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYI0BXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 21:23:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:49637 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbYI0BXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 21:23:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,317,1220252400"; 
   d="asc'?scan'208";a="444184664"
Subject: Re: [PATCH 1/4] x86: Add UV EFI table entry v2
From: Huang Ying <ying.huang@intel.com>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
In-Reply-To: <20080926200206.GB138671@sgi.com>
References: <20080926200206.GB138671@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-V5T7falECJw9NHAXlngc"
Date: Sat, 27 Sep 2008 09:23:39 +0800
Message-Id: <1222478619.28661.21.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-V5T7falECJw9NHAXlngc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-26 at 15:02 -0500, Russ Anderson wrote:
> [PATCH 1/4] Add UV EFI table entry
>=20
> Look for a UV entry in the EFI tables.
>=20
> Signed-off-by: Russ Anderson <rja@sgi.com>
> Signed-off-by: Paul Jackson <pj@sgi.com>

Acked-by: Huang Ying <ying.huang@intel.com>

Best Regards,
Huang Ying

> ---
>  arch/x86/kernel/efi.c |    4 ++++
>  include/linux/efi.h   |    4 ++++
>  2 files changed, 8 insertions(+)
>=20
> Index: linux/arch/x86/kernel/efi.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/arch/x86/kernel/efi.c	2008-09-26 13:54:11.000000000 -0500
> +++ linux/arch/x86/kernel/efi.c	2008-09-26 13:54:18.000000000 -0500
> @@ -367,6 +367,10 @@ void __init efi_init(void)
>  			efi.smbios =3D config_tables[i].table;
>  			printk(" SMBIOS=3D0x%lx ", config_tables[i].table);
>  		} else if (!efi_guidcmp(config_tables[i].guid,
> +					UV_SYSTEM_TABLE_GUID)) {
> +			efi.uv_systab =3D config_tables[i].table;
> +			printk(" UVsystab=3D0x%lx ", config_tables[i].table);
> +		} else if (!efi_guidcmp(config_tables[i].guid,
>  					HCDP_TABLE_GUID)) {
>  			efi.hcdp =3D config_tables[i].table;
>  			printk(" HCDP=3D0x%lx ", config_tables[i].table);
> Index: linux/include/linux/efi.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/include/linux/efi.h	2008-09-26 13:54:11.000000000 -0500
> +++ linux/include/linux/efi.h	2008-09-26 13:54:18.000000000 -0500
> @@ -208,6 +208,9 @@ typedef efi_status_t efi_set_virtual_add
>  #define EFI_GLOBAL_VARIABLE_GUID \
>      EFI_GUID(  0x8be4df61, 0x93ca, 0x11d2, 0xaa, 0x0d, 0x00, 0xe0, 0x98,=
 0x03, 0x2b, 0x8c )
> =20
> +#define UV_SYSTEM_TABLE_GUID \
> +    EFI_GUID(  0x3b13a7d4, 0x633e, 0x11dd, 0x93, 0xec, 0xda, 0x25, 0x56,=
 0xd8, 0x95, 0x93 )
> +
>  typedef struct {
>  	efi_guid_t guid;
>  	unsigned long table;
> @@ -255,6 +258,7 @@ extern struct efi {
>  	unsigned long boot_info;	/* boot info table */
>  	unsigned long hcdp;		/* HCDP table */
>  	unsigned long uga;		/* UGA table */
> +	unsigned long uv_systab;	/* UV system table */
>  	efi_get_time_t *get_time;
>  	efi_set_time_t *set_time;
>  	efi_get_wakeup_time_t *get_wakeup_time;

--=-V5T7falECJw9NHAXlngc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjdixgACgkQKhFGF+eHlpgCNgCfU3i8+26h+z4I1qUSU5tXkF36
JDUAniPPSI/v2YrKAF9cVeLbA/rOq6gL
=aWx9
-----END PGP SIGNATURE-----

--=-V5T7falECJw9NHAXlngc--

