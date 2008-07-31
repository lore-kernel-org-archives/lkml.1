Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYGaTNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYGaTNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbYGaTNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:13:09 -0400
Received: from intcomgrp.com ([216.54.13.120]:46996 "EHLO beta.intcomgrp.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbYGaTNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:13:08 -0400
X-Greylist: delayed 3418 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2008 15:13:08 EDT
Message-ID: <48920174.8000001@beta.intcomgrp.com>
Date: Thu, 31 Jul 2008 14:16:20 -0400
From: James Kosin <jkosin@beta.intcomgrp.com>
Organization: International Communications Group, Inc.
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removes extra checking in kernel/cpuset.c
References: <aVIzQ-Oh-23@gated-at.bofh.it>
In-Reply-To: <aVIzQ-Oh-23@gated-at.bofh.it>
X-Enigmail-Version: 0.95.6
OpenPGP: id=7BB59129
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEF22272A1DC3068949A2801B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEF22272A1DC3068949A2801B
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Rakib Mullick wrote:
> Hello guys, this patch removes an extra checking over 'cs' in
> functions 'guarantee_online_cpus' and 'guarantee_online_mems'.
>=20
> Thanks.
>=20
> Signed-off-by: Md.Rakib H. Mullick (rakib.mullick@gmail.com)
>=20

I'd have to NAK this one as well.  2-reasons:
1)  Your patch is guaranteed to generate a NULL pointer dereference at=20
some point.  You keep using cs; and assigning cs =3D cs->parent in the=20
loop, at some point you may end up at the TOP of the tree where=20
cs->parent =3D=3D NULL.
2)  The change breaks the actual meaning of the code.  Which is=20
suggesting my the short snippet, find an entry (while loop)... if the=20
entry is found (if cs test), do this otherwise BUG out.  Your code is=20
saying, if cs is not NULL initially... find someplace then do something. =

  The function never BUGS out unless someone calls with cs NULL initially=
=2E

James Kosin


--------------enigEF22272A1DC3068949A2801B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkiSAXQACgkQkNLDmnu1kSnfcgCfV7O5ouzQLIq1Y8i9g+tu2H/o
SDEAn2JBl8g/DZmVggFtgFaLk4rTbmFL
=QgjK
-----END PGP SIGNATURE-----

--------------enigEF22272A1DC3068949A2801B--
