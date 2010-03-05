Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0CEE5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 23:57:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44229 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab0CEE53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 23:57:29 -0500
Date: Fri, 5 Mar 2010 15:57:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/9] bitops: rename for_each_bit to for_each_set_bit
Message-Id: <20100305155722.4ca9f449.sfr@canb.auug.org.au>
In-Reply-To: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
References: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__5_Mar_2010_15_57_22_+1100_v1PWwBgapSRzZF0/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Mar_2010_15_57_22_+1100_v1PWwBgapSRzZF0/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue,  2 Feb 2010 00:10:32 +0900 Akinobu Mita <akinobu.mita@gmail.com> wr=
ote:
>
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index c05a29c..de68c58 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -16,7 +16,7 @@
>   */
>  #include <asm/bitops.h>
> =20
> -#define for_each_bit(bit, addr, size) \
> +#define for_each_set_bit(bit, addr, size) \
>  	for ((bit) =3D find_first_bit((addr), (size)); \
>  	     (bit) < (size); \
>  	     (bit) =3D find_next_bit((addr), (size), (bit) + 1))

If you also added

#define for_each_bit(bit, addr, size) for_each_set_bit((bit), (addr), (size=
))

Then the transition can be made not as painful i.e. less likely to impact
on new users of for_each_bit() that may not currently be in Linus' tree.

(and the patch to bitops.h could be submitted on its own, and the other
parts could be sent to their respective maintainer - which also lowers
the pain for them with conflicts etc).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__5_Mar_2010_15_57_22_+1100_v1PWwBgapSRzZF0/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuQjzIACgkQjjKRsyhoI8yKBQCeJPZFxLSnJ0klZ9eouqpm1ijX
n3gAn3mzwy130I0JEFRHRHcavqQukHLI
=jkxb
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Mar_2010_15_57_22_+1100_v1PWwBgapSRzZF0/--
