Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbYK1K7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbYK1K7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYK1K73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:59:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45508 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbYK1K72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:59:28 -0500
Date: Fri, 28 Nov 2008 21:59:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH -next] at91rm9200 vs cpumask changes
Message-Id: <20081128215912.f12c644e.sfr@canb.auug.org.au>
In-Reply-To: <20081128103913.GA8488@x200.localdomain>
References: <20081128103913.GA8488@x200.localdomain>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__28_Nov_2008_21_59_12_+1100_pMe2eM.9Ldqf/VZ0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Nov_2008_21_59_12_+1100_pMe2eM.9Ldqf/VZ0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexey,

On Fri, 28 Nov 2008 13:39:13 +0300 Alexey Dobriyan <adobriyan@gmail.com> wr=
ote:
>
> --- a/arch/arm/mach-at91/at91rm9200_time.c
> +++ b/arch/arm/mach-at91/at91rm9200_time.c
> @@ -169,7 +169,6 @@ static struct clock_event_device clkevt =3D {
>  	.features	=3D CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
>  	.shift		=3D 32,
>  	.rating		=3D 150,
> -	.cpumask	=3D CPU_MASK_CPU0,
>  	.set_next_event	=3D clkevt32k_next_event,
>  	.set_mode	=3D clkevt32k_mode,
>  };
> @@ -197,7 +196,7 @@ void __init at91rm9200_timer_init(void)
>  	clkevt.mult =3D div_sc(AT91_SLOW_CLOCK, NSEC_PER_SEC, clkevt.shift);
>  	clkevt.max_delta_ns =3D clockevent_delta2ns(AT91_ST_ALMV, &clkevt);
>  	clkevt.min_delta_ns =3D clockevent_delta2ns(2, &clkevt) + 1;
> -	clkevt.cpumask =3D cpumask_of_cpu(0);
> +	clkevt.cpumask =3D cpumask_of(0);
>  	clockevents_register_device(&clkevt);
> =20
>  	/* register clocksource */

This patch is already in the rr tree today.  But thanks for the patch.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__28_Nov_2008_21_59_12_+1100_pMe2eM.9Ldqf/VZ0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkvzwAACgkQjjKRsyhoI8xULgCgp2u+YHPkSVctmHPJowsGnRyU
KY8AmQE6FY3r7FyGUSCBznwZOSdxsXAp
=CrvK
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Nov_2008_21_59_12_+1100_pMe2eM.9Ldqf/VZ0--
