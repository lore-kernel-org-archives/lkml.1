Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab0CKXsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 18:48:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38107 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab0CKXsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 18:48:53 -0500
Date: Fri, 12 Mar 2010 10:48:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, benh@kernel.crashing.org,
       davem@davemloft.net, jeremy.kerr@canonical.com, monstr@monstr.eu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] of/flattree: Make unflatten_device_tree() safe to
 call from any arch
Message-Id: <20100312104840.2128fe99.sfr@canb.auug.org.au>
In-Reply-To: <20100311173203.4423.8733.stgit@angua>
References: <20100311173024.4423.53178.stgit@angua>
	<20100311173203.4423.8733.stgit@angua>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Mar_2010_10_48_40_+1100_78MdD8qFEPUyYrv3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Mar_2010_10_48_40_+1100_78MdD8qFEPUyYrv3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Thu, 11 Mar 2010 10:32:03 -0700 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> - If CONFIG_OF_FLATTREE is not set, then make unflatten_device_tree()
>   an empty #define.

"an empty static inline funtion."

> diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
> index f0fdd1f..54399f1 100644
> --- a/include/linux/of_fdt.h
> +++ b/include/linux/of_fdt.h
> @@ -99,6 +99,8 @@ extern int early_init_dt_scan_root(unsigned long node, =
const char *uname,
>  /* Other Prototypes */
>  extern void unflatten_device_tree(void);
>  extern void early_init_devtree(void *);
> +#else /* CONFIG_OF_FLATTREE */
> +static inline void define unflatten_device_tree(void) {}
                      ^^^^^^
You need to remove that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Mar_2010_10_48_40_+1100_78MdD8qFEPUyYrv3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuZgVgACgkQjjKRsyhoI8xIfQCffmMd7zivdpAOUCKyMUTfwkRG
UZwAoKelHuq+xFrCqlSQ1N5yRUrxfCxR
=R7bC
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Mar_2010_10_48_40_+1100_78MdD8qFEPUyYrv3--
