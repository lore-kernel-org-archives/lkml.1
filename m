Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbZC1JZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbZC1JZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 05:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZC1JZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 05:25:23 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:43260 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZC1JZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 05:25:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=SbhzB8hJOUH4F/eQmRj3SJD1tXUhUU61bTfaVe8buzOXRtr5M3xkL+v5uqFlIEQm4R
         KOh1sqCmGqcLndiezqHMyuPHJ5HgkATwSyDwsyv4Nr3fuhX867z3fGV6X7HVVi76NjsX
         T4V4T5OwGZW0i7hJD040Tqx4HLOpvdwzuEevQ=
Date: Sat, 28 Mar 2009 10:26:22 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Kristoffer Ericson <Kristoffer.Ericson@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 23/58] move jornada_ssp's probe function to
 .devinit.text
Message-Id: <20090328102622.b9137eb6.kristoffer.ericson@gmail.com>
In-Reply-To: <1238196439-16535-23-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de>
	<1238196439-16535-23-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__28_Mar_2009_10_26_22_+0100_An5zFRdGs2_4oPfJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__28_Mar_2009_10_26_22_+0100_An5zFRdGs2_4oPfJ
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Acked-by : Kristoffer Ericson <kristoffer.ericson@gmail.com>

Thx

On Sat, 28 Mar 2009 00:26:44 +0100
Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de> wrote:

> A pointer to jornada_ssp_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=3Dy)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
>=20
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> Cc: Kristoffer Ericson <Kristoffer.Ericson@gmail.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  arch/arm/mach-sa1100/jornada720_ssp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/arch/arm/mach-sa1100/jornada720_ssp.c b/arch/arm/mach-sa1100=
/jornada720_ssp.c
> index 28cf369..ce4c6cb 100644
> --- a/arch/arm/mach-sa1100/jornada720_ssp.c
> +++ b/arch/arm/mach-sa1100/jornada720_ssp.c
> @@ -130,7 +130,7 @@ void jornada_ssp_end(void)
>  };
>  EXPORT_SYMBOL(jornada_ssp_end);
> =20
> -static int __init jornada_ssp_probe(struct platform_device *dev)
> +static int __devinit jornada_ssp_probe(struct platform_device *dev)
>  {
>  	int ret;
> =20
> --=20
> 1.6.2
>=20


--=20
Kristoffer Ericson <kristoffer.ericson@gmail.com>

--Signature=_Sat__28_Mar_2009_10_26_22_+0100_An5zFRdGs2_4oPfJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknN7T4ACgkQPQls10ERAGfF6gCgxuAT8t3F08TPgLLNuAhxNR97
TDsAoNcnS0jcpXacQFKISRBON5KHGV7h
=ba2h
-----END PGP SIGNATURE-----

--Signature=_Sat__28_Mar_2009_10_26_22_+0100_An5zFRdGs2_4oPfJ--
