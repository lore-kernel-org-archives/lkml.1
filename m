Return-Path: <linux-kernel-owner+w=401wt.eu-S933965AbXDBLwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbXDBLwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933973AbXDBLwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:52:13 -0400
Received: from cel.leonerd.org.uk ([62.49.94.186]:3545 "EHLO cel.leo"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933965AbXDBLwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:52:13 -0400
X-Greylist: delayed 1562 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2007 07:52:12 EDT
Date: Mon, 2 Apr 2007 12:26:07 +0100
From: Paul LeoNerd Evans <leonerd@leonerd.org.uk>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       Daniel Jacobowitz <dan@debian.org>
Subject: Re: [PATCH 17/16] Do not reset UTF8 on terminal reset
Message-ID: <20070402112607.GK26707@cel.leo>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012001130.12316@yvahk01.tjqt.qr> <1175496595.4614.11.camel@daplas> <Pine.LNX.4.61.0704020904460.1245@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704020904460.1245@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 02, 2007 at 09:31:37AM +0200, Jan Engelhardt wrote:
> Also see:
> 	http://lkml.org/lkml/2005/5/17/289
> 	http://lkml.org/lkml/2005/5/17/297
>=20
> These posts argue about terminfo being the culprit. But how can terminfo=
=20
> be at fault, when `echo -en "\ec"` triggers it too?
>=20
> Since I am in a patch mood, here's my stance/patch, which is compile and=
=20
> run tested and behaves as expected (both with `echo` and `reset`).

=2E..

> Index: linux-2.6.21-rc5/drivers/char/vt.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.21-rc5.orig/drivers/char/vt.c
> +++ linux-2.6.21-rc5/drivers/char/vt.c
> @@ -1518,7 +1518,6 @@ static void reset_terminal(struct vc_dat
>  	vc->vc_charset		=3D 0;
>  	vc->vc_need_wrap	=3D 0;
>  	vc->vc_report_mouse	=3D 0;
> -	vc->vc_utf		=3D 0;
>  	vc->vc_utf_count	=3D 0;
> =20
>  	vc->vc_disp_ctrl	=3D 0;
> #<EOF>

Is it OK to do that? I recall when I was originally looking at the code
I didn't want to just remove that line, because it looked like that was
being used to first initialise the vc* structure when it is created, as
well as reset it every time. Doesn't this leave vc->vc_utf uninitialised
when a new VC is allocated?

--=20
Paul "LeoNerd" Evans

leonerd@leonerd.org.uk
ICQ# 4135350       |  Registered Linux# 179460
http://www.leonerd.org.uk/

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGEOhP7eTlovtaLtYRAl5HAKCDf1G68+xdkQAwcWPPh2x7kNVi0QCeKrcu
3G5vQ83s3wCnFWUySoDD8Ms=
=WqLn
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--
