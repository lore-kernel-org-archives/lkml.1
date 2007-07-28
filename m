Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbXG1JwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbXG1JwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 05:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbXG1JwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 05:52:11 -0400
Received: from piware.de ([213.9.79.162]:49266 "EHLO box79162.elkhouse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbXG1JwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 05:52:10 -0400
X-Greylist: delayed 1691 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jul 2007 05:52:09 EDT
Date: Sat, 28 Jul 2007 11:23:55 +0200
From: Martin Pitt <martin.pitt@ubuntu.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jeremy@goop.org,
       martin.pitt@ubuntu.com, wwoods@redhat.com,
       Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [PATCH 2/3] core_pattern: allow passing of arguments to user
	mode helper when core_pattern is a pipe
Message-ID: <20070728092355.GA5808@piware.de>
References: <20070727200746.GC18946@hmsreliant.homelinux.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20070727200746.GC18946@hmsreliant.homelinux.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

thanks a lot for your work on this!

Neil Horman [2007-07-27 16:08 -0400]:
> Hey
> 	Patch 2/3 of my core_pattern enhancements.  This patch is a rewrite of
> my previous post for this enhancement.  It uses jeremy's split_argv/free_=
argv
> library functions to translate core_pattern into an argv array to be pass=
ed to
> the user mode helper process. =20
> [...]
>   	if (ispipe) {
>  		core_limit =3D RLIM_INFINITY;
> +		helper_argv =3D argv_split(GFP_KERNEL, corename+1, &helper_argc);

I just want to mention a potential problem with this: If you first
expand the macros (from pattern to corename) and then split corename
into an argv, then this breaks macro expansions containing spaces.
This mostly affects the executable name, of course.

In fact we considered this macro approach when doing the original
patches in the Ubuntu kernel, but we eventually used environment
variables because they are much easier and more robust to implement
than doing a robust macro expansion (i. e. first split core_pattern
into an argv and then call the macro expansion for each element).

I would love to use macros instead since it looks a bit cleaner, and
personally I do not care about the "executable name" macro for Apport
[1] (I grab it from /proc/pid/exe), but I wanted to mention this
possible caveat before it goes upstream.

Thank you,

Martin

[1] https://wiki.ubuntu.com/Apport

--=20
Martin Pitt        http://www.piware.de
Ubuntu Developer   http://www.ubuntu.com
Debian Developer   http://www.debian.org

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGqwsrDecnbV4Fd/IRAmzsAKDZKWVBoI9IZKPHuH8iIFBAJspeigCgsEuW
G4wXdanVCe043x+2w6/6lYs=
=JrCK
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
