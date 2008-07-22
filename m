Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYGVEiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYGVEiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbYGVEiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:38:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45806 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYGVEiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:38:09 -0400
Date: Tue, 22 Jul 2008 14:38:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix pte_flags() to only return flags, fix lguest.
Message-Id: <20080722143800.d392994f.sfr@canb.auug.org.au>
In-Reply-To: <200807221431.58991.rusty@rustcorp.com.au>
References: <200807221431.58991.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Jul_2008_14_38_00_+1000_qF_Akfsr5ZVFzhNK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Jul_2008_14_38_00_+1000_qF_Akfsr5ZVFzhNK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Tue, 22 Jul 2008 14:31:58 +1000 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> +++ b/include/asm-x86/page.h	Tue Jul 22 14:09:33 2008 +1000
> @@ -144,6 +144,18 @@ static inline pteval_t native_pte_val(pt
>  	return pte.pte;
>  }
> =20
> +/* This belongs in pgtable.h, but our includes are too much of a mess. */
> +#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
> +#define PTE_FLAGS	_AC(0x8000000000000FFF, ULL)

Just a small point:  You don't actually need the _AC() because this is
already in a #ifndef __ASSEMBLY__ section of the file.  But better safe
than sorry, I guess.  :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Jul_2008_14_38_00_+1000_qF_Akfsr5ZVFzhNK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiFZCgACgkQjjKRsyhoI8yIrACffRx8JuKjxwgC1hstUngwUKy1
bKgAoKklQ0DCykqDLvh42hjlb6/Nk7ib
=ZUC1
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Jul_2008_14_38_00_+1000_qF_Akfsr5ZVFzhNK--
