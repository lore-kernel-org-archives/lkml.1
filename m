Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZARWvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZARWvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 17:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZARWur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 17:50:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51850 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbZARWuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 17:50:46 -0500
Date: Mon, 19 Jan 2009 09:50:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
Message-Id: <20090119095035.bf9d0e7c.sfr@canb.auug.org.au>
In-Reply-To: <1232273454.23100.9.camel@localhost.localdomain>
References: <1232273454.23100.9.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__19_Jan_2009_09_50_35_+1100_D=gkPKcpPLYvwXPf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Jan_2009_09_50_35_+1100_D=gkPKcpPLYvwXPf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jaswinder,

On Sun, 18 Jan 2009 15:40:54 +0530 Jaswinder Singh Rajput <jaswinder@kernel=
.org> wrote:
>
> diff --git a/include/linux/raw.h b/include/linux/raw.h
> index 62d543e..3898e30 100644
> --- a/include/linux/raw.h
> +++ b/include/linux/raw.h
> @@ -13,6 +13,10 @@ struct raw_config_request
>  	__u64	block_minor;
>  };
> =20
> +#ifdef __KERNEL__
>  #define MAX_RAW_MINORS CONFIG_MAX_RAW_DEVS
> +#else /* __KERNEL__ */
> +#define MAX_RAW_MINORS 0
> +#endif /* __KERNEL__ */
> =20
>  #endif /* __LINUX_RAW_H */

Since MAX_RAW_MINORS has only one user (drivers/char/raw.c), why not
just remove the define from here and add it it there?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Jan_2009_09_50_35_+1100_D=gkPKcpPLYvwXPf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklzsjsACgkQjjKRsyhoI8zHaACgvKQThz0EFzdyDuDCBe9LWX3X
AQAAnj/Q+YuBZEArA7VchmTQMMz4mEb/
=Zls7
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Jan_2009_09_50_35_+1100_D=gkPKcpPLYvwXPf--
