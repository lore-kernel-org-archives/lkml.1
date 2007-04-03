Return-Path: <linux-kernel-owner+w=401wt.eu-S966030AbXDCSGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966030AbXDCSGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 14:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966188AbXDCSGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 14:06:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966030AbXDCSGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 14:06:02 -0400
Message-ID: <4612977D.4060903@redhat.com>
Date: Tue, 03 Apr 2007 11:05:49 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403172736.GA23689@one.firstfloor.org> <46128F47.2010107@redhat.com> <20070403173505.GD23689@one.firstfloor.org> <461292BF.5020803@redhat.com> <20070403175827.GA24033@one.firstfloor.org>
In-Reply-To: <20070403175827.GA24033@one.firstfloor.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCA70753D9FF5529C246BDBB0"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCA70753D9FF5529C246BDBB0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andi Kleen wrote:
>> There is an inexpensive solution: finally make the vdso concept a bit
>> more flexible.  You could add a vdso call to get the processor count.
>> The vdso code itself can use a data page mapped in from the kernel.
>=20
> The ELF aux vector is exactly that already.

No.  The aux vector cannot be changed after the process is changed.  The
memory belong to the process and not the kernel.  It must be possible at
any time to get the correct information even if the system changed.


>> This page (read-only at userlevel) would contain global information su=
ch
>> as processor count and topology.
>=20
> You would still need an event notification mechanism, won't you?

No, why?  The vdso call would be so inexpensive (just a simple function
call) that it can be done whenever a topology-based decision has to be
made.  Use cookies to determine whether nothing has been changed since
the last call etc.


> The cost will be still large. Accessing sysfs will be never cheap.
> For once anything going through the VFS tens to take a two sometimes
> three digit number of locks.

That stat solution actually ain't that bad.  It takes ~7400 cycles on my
machine.


> If you want it cheap look for some other way.

Well, who's brace enough to submit sys_sysconf() again?

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigCA70753D9FF5529C246BDBB0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEpd+2ijCOnn/RHQRAqv0AJ0XKyRqUUXKvlPkS4fMz45Mz1/BIwCfeTpL
2vXyMnep/g9/MJKIJrulCF4=
=l5DS
-----END PGP SIGNATURE-----

--------------enigCA70753D9FF5529C246BDBB0--
