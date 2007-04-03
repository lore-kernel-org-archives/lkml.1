Return-Path: <linux-kernel-owner+w=401wt.eu-S1161029AbXDCRp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161029AbXDCRp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161010AbXDCRp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:45:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161029AbXDCRp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:45:56 -0400
Message-ID: <461292BF.5020803@redhat.com>
Date: Tue, 03 Apr 2007 10:45:35 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403172736.GA23689@one.firstfloor.org> <46128F47.2010107@redhat.com> <20070403173505.GD23689@one.firstfloor.org>
In-Reply-To: <20070403173505.GD23689@one.firstfloor.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD20F68132CF277FB9DEF2027"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD20F68132CF277FB9DEF2027
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andi Kleen wrote:
>>> Topology is dependent on the number of CPUs.
>> Not all of it.
>=20
> What is not?

Memory banks can exist without a CPU present.  The places where you can
plug in memory don't change and so the memory hierarchy can be described.=



> Hmm, e.g. in OpenMP you would have another thread that just reads /proc=
/cpuinfo
> in a loop and starts new threads on new CPUs?
>=20
> That sounds ...... "expensive"=20

That's the cost of doing business.

There is an inexpensive solution: finally make the vdso concept a bit
more flexible.  You could add a vdso call to get the processor count.
The vdso code itself can use a data page mapped in from the kernel.
This page (read-only at userlevel) would contain global information such
as processor count and topology.


But we're getting IMO off topic here.  That's a separate and far more
complicated issue.

Here we now have the concrete issue that determining the CPU count is
terribly expensive and there is a simple proposal to make it faster by
keeping /sys/devices/system/cpu/ free from anything but cpu* directories.=


--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigD20F68132CF277FB9DEF2027
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEpK/2ijCOnn/RHQRAvQlAKC3ge61paQHNWDbtQSvZhpFfVIJhQCeMdyv
qQl23KmsstTu4uPd+rYTZjE=
=P8fV
-----END PGP SIGNATURE-----

--------------enigD20F68132CF277FB9DEF2027--
