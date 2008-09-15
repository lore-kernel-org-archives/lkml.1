Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbYIOR7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbYIOR7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYIOR7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:59:32 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53572 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbYIOR7c (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:59:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Frank Mayhar <fmayhar@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc6-mmotm0913 build error - suspect itimers-fix-itimer-many-thread-hang.patch
In-Reply-To: Your message of "Mon, 15 Sep 2008 10:13:24 PDT."
             <1221498804.19012.13.camel@bobble.smo.corp.google.com>
From: Valdis.Kletnieks@vt.edu
References: <48922.1221496161@turing-police.cc.vt.edu>
            <1221498804.19012.13.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221501535_46396P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Sep 2008 13:58:55 -0400
Message-ID: <80040.1221501535@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221501535_46396P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Sep 2008 10:13:24 PDT, Frank Mayhar said:

> As it happens, my top-of-tree snapshot is missing this routine.  I'm
> re-snapping it now but I think you're right that it's a merge issue wit=
h
> linux-next.  The fix, however, is trivial:  Replace the entire if block=

> with the line:
> 	update_rlimit_cpu(rlim->rlim_cur);
>=20
> The above snippet becomes:
>=20
>        if (rc) =7B
>                 for (i =3D 0; i < RLIM_NLIMITS; i++) =7B
>                         rlim =3D current->signal->rlim + i;
>                         initrlim =3D init_task.signal->rlim+i;
>                         rlim->rlim_cur =3D min(rlim->rlim_max, initrlim=
->rlim_cur);
>                 =7D
>                 update_rlimit_cpu(rlim->rlim_cur);
>         =7D
>=20
> And double-check that linux/posix-timers.h is being =23included around
> line 80.

Yeah, it had the =23include already, and with the above fix, I actually g=
ot a
clean build of the kernel.  Boot testing will have to wait till tonight..=
.

Thanks for the help. :)

--==_Exmh_1221501535_46396P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIzqJfcC3lWbTT17ARAlKZAKCpwcBGYm4PDNF5xALyoKxQ80aLyACgpmbW
/mXs1rR/0QpyaYEa0wPqprs=
=KFS9
-----END PGP SIGNATURE-----

--==_Exmh_1221501535_46396P--
