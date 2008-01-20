Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbYATRwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbYATRwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 12:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYATRvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 12:51:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:60182 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753528AbYATRvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 12:51:53 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+wSIU3wkSwmJZJ6ndgCuOo6aB9VAVch42xBi1h2d
	GUIS+dzuKbAqqt
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: build #344 issue for v2.6.24-rc8-74-ga7da60f Section mismatch: reference to .init.text:lguest_entry
Date: Sun, 20 Jan 2008 18:51:46 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
References: <200801201619.01965.toralf.foerster@gmx.de> <20080120172151.GA22524@uranus.ravnborg.org>
In-Reply-To: <20080120172151.GA22524@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1781370.l6H4lb9lVx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801201851.49422.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1781370.l6H4lb9lVx
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Sonntag, 20. Januar 2008 schrieb Sam Ravnborg:
> Different issue. Untested patch below.
>=20
> 	Sam
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index fbad51f..f0cacff 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -9,6 +9,7 @@
> =20
>  .text
>  #include <linux/threads.h>
> +#include <linux/init.h>
>  #include <linux/linkage.h>
>  #include <asm/segment.h>
>  #include <asm/page.h>
> @@ -151,7 +152,9 @@ WEAK(xen_entry)
>  	/* Unknown implementation; there's really
>  	   nothing we can do at this point. */
>  	ud2a
> -.data
> +
> +	__INITDATA
> +
>  subarch_entries:
>  	.long default_entry		/* normal x86/PC */
>  	.long lguest_entry		/* lguest hypervisor */
>=20


works fine :-)

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart1781370.l6H4lb9lVx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHk4o1hyrlCH22naMRAor3AJ90twuwG3wGgnyakhmfp6ZA0AGQ7QCgi4Vy
Q3cfBFdI8DHhgrah/g2pyBo=
=Nd+W
-----END PGP SIGNATURE-----

--nextPart1781370.l6H4lb9lVx--
