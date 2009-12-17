Return-Path: <linux-kernel-owner+w=401wt.eu-S965037AbZLQU1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965037AbZLQU1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 15:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764921AbZLQU10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 15:27:26 -0500
Received: from mail.klingt.org ([86.59.21.178]:36978 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762723AbZLQU1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 15:27:21 -0500
Message-ID: <4B2A93F2.3070407@klingt.org>
Date: Thu, 17 Dec 2009 21:26:26 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7pre) Gecko/20091216 Shredder/3.0.1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
CC: stern@rowland.harvard.edu, x86@kernel.org
Subject: Re: 2.6.32 regression: unable to handle kernel paging request
References: <4B269765.1070703@klingt.org> <4B2A2A7D.1050506@klingt.org>
In-Reply-To: <4B2A2A7D.1050506@klingt.org>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB5419907681ABAD9BCF37F75"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [127.0.0.1]); Thu, 17 Dec 2009 21:26:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB5419907681ABAD9BCF37F75
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>> i cannot boot any 2.6.32 kernel (i tested back until -rc5) on my nehal=
em
>> machine (x86_64, 12gb ram).
>>
>> there are bug messages in various (mostly module loader) functions,
>> stating "unable to handle kernel paging request". 2.6.31 on the same
>> machine works like charm. i haven't been able to save a boot log, but =
it
>> didn't look too different from this:
>>
>> http://lkml.org/lkml/2009/12/8/207
>=20
> trying to bisect the kernel tree,
> 405d967dc70002991f8fc35c20e0d3cbc7614f63 seems to be the first bad comm=
it.
> during bisecting, i recorded several boot logs, which are attached.

removing module-common.lds from LDFLAGS_MODULE, my machine boots fine
and without any error messages:

--- a/Makefile
+++ b/Makefile
@@ -326,7 +326,7 @@ CHECKFLAGS     :=3D -D__linux__ -Dlinux -D__STDC__ -D=
unix -D__unix__ \
 MODFLAGS       =3D -DMODULE
 CFLAGS_MODULE   =3D $(MODFLAGS)
 AFLAGS_MODULE   =3D $(MODFLAGS)
-LDFLAGS_MODULE  =3D -T $(srctree)/scripts/module-common.lds
+LDFLAGS_MODULE  =3D
 CFLAGS_KERNEL  =3D
 AFLAGS_KERNEL  =3D
 CFLAGS_GCOV    =3D -fprofile-arcs -ftest-coverage

i hope someone with more insights in these parts of the kernel can have
a closer look into this issue.

thanks, tim

--=20
tim@klingt.org
http://tim.klingt.org

Wherever we are, what we hear is mostly noise. When we ignore it, it
disturbs us. When we listen to it, we find it fascinating.
  John Cage


--------------enigB5419907681ABAD9BCF37F75
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksqk/YACgkQdL+4qsZfVsunawCcDTVDWAMzCRG3Oecu2A1onBTY
xGUAn1cfIo7bAtCxEcLXDdoG6zYZKiDn
=vEeg
-----END PGP SIGNATURE-----

--------------enigB5419907681ABAD9BCF37F75--
