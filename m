Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZGKXxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZGKXxp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 19:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZGKXxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 19:53:36 -0400
Received: from mail.open.by ([193.232.92.17]:63608 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZGKXxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 19:53:36 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9001 [Jul 11 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Info: {UDS BL}
X-SpamTest-Method: probable
X-SpamTest-Rate: 65
X-SpamTest-SPF: softfail
X-SpamTest-Status: Probable Spam
X-SpamTest-Status-Extended: probable_spam
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Sun, 12 Jul 2009 02:55:30 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: possible regression with pty.c commit
Message-ID: <20090711235530.GA3231@localdomain.by>
References: <20090711191556.GA3845@localdomain.by>
 <20090711232452.4dc7c1ba@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20090711232452.4dc7c1ba@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/11/09 23:24), Alan Cox wrote:
> On Sat, 11 Jul 2009 22:15:56 +0300
> Sergey Senozhatsky <sergey.senozhatsky@mail.by> wrote:
>=20
> > Hello,
> > commit d945cb9cce20ac7143c2de8d88b187f62db99bdc ("pty: Rework the pty l=
ayer to use the normal buffering logic")
> > seems to brake kdesu.
>=20
> This looks like a timing bug in kdesu at first glance but it may be more
> complex.
>=20
> > close(11)                               =3D 0
>=20
> We close one side of the pty/tty pair
>=20
> > write(10, "stop", 4)                    =3D 4
> > write(10, "\n", 1)                      =3D 1
> > fcntl64(10, F_GETFL)                    =3D 0x2 (flags O_RDWR)
> > read(10, 0xbf840858, 255)               =3D -1 EIO (Input/output error)=
		<<<<<<<<<
>=20
> At this point the other side is closed, we have a hangup and the read
> correctly I think gets -EIO.
>=20
> I will have a look at kdesu on Monday, I've got Fedora setups here so
> hopefully I can reproduce it simply.
>=20

Alan, I forgot to tell - I'm using KDE 3.5.9 (3.5.10). Don't know whether t=
his can be reproduced with KDE 4.x.x.

	Sergey
--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpZJnIACgkQfKHnntdSXjRtIQP/Z9726k4p2hZ2FCowjB7CL/Is
GeP8RbpzgjEFq7afQZ0jRaHNPDyOoGS9IG4M/ZBb3Com1npntHag/QFkGHjPYxrT
zPuAOTolFkylokag8wa6Q3rgwCmqE6slyHEirlkGXbHNSlb9AmzVa3/YgVs8jKAQ
mFNrZ6qfGbM6+9gHkYg=
=KU/l
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
