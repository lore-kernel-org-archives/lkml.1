Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYHROos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYHROos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYHROok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:44:40 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:27901 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbYHROoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:44:39 -0400
Date: Mon, 18 Aug 2008 17:44:19 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] binfmt_misc.c: avoid potential kernel stack overflow
Message-ID: <20080818144418.GA4818@localhost.localdomain>
References: <20080818112849.GA4951@localhost.localdomain> <48A98293.5080109@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <48A98293.5080109@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2008 at 06:09:23PM +0400, Pavel Emelyanov wrote:
> (Put lkml in Cc. The original message is beyond)
>=20
> Oops! My fault. The problem is that in case of modularized binfmt,
> the appropriate binary handler gets registered _before_ the script
> one and sets the misc_bang flag even too early.
>=20
> Thus when we launch a script the load_misc_binary sets this bang,
> then returns error, since the binary is actually a script, then the
> load_script_binary successfully loads the script, then it loads the
> misc binary again, which exits with the -ENOEXEC error due to bang=20
> set.
>=20
> This patch helped my box, what about yours?

It works. Thank you.

Reported-and-tested-by: Kirill A. Shutemov <kirill@shutemov.name>

I have noticed yet another problem: more than one bit of sh_bang can be
used on alpha:

fs/exec.c
1189                         return retval;
1190=20
1191                 /* Remember if the application is TASO.  */
1192                 bprm->sh_bang =3D eh->ah.entry < 0x100000000UL;
1193=20
1194                 bprm->file =3D file;


--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkipisIACgkQbWYnhzC5v6rvJwCfYBXF7p90BbTBnEg8BVHGzZ2S
ksYAnjqgjqBmx5bWsMFXi2WZDgw2/BxM
=V/fY
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
