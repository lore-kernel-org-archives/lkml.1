Return-Path: <linux-kernel-owner+w=401wt.eu-S2992482AbXDCXBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992482AbXDCXBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992483AbXDCXBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:01:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992482AbXDCXBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:01:10 -0400
Message-ID: <4612DCA2.2090400@redhat.com>
Date: Tue, 03 Apr 2007 16:00:50 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Paul Jackson <pj@sgi.com>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com>	<20070403131623.c6831607.akpm@linux-foundation.org>	<4612BB89.8040102@redhat.com>	<20070403141348.9bcdb13e.akpm@linux-foundation.org>	<4612D175.30604@redhat.com> <20070403154831.37bde672.akpm@linux-foundation.org>
In-Reply-To: <20070403154831.37bde672.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig57DD67FE212B30AFAE70CA39"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig57DD67FE212B30AFAE70CA39
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> Now it could be argued that the current behaviour is that sane thing: w=
e
> allow the process to "pin" itself to not-present CPUs and just handle i=
t in
> the CPU scheduler.

As a stop-gap solution Jakub will likely implement the sched_getaffinity
hack.  So, it would realy be best to get the masks updated.


But all this of course does not solve the issue sysconf() has.  In
sysconf we cannot use sched_getaffinity since all the systems CPUs must
be reported.


> Is it kernel overhead, or userspace?  The overhead of counting the bits=
?

The overhead I meant is userland.


> Because sched_getaffinity() could be easily sped up in the case where
> it is operating on the current process.

If there is possibility to treat this case special and make it faster,
please do so.  It would be best to allow pid=3D=3D0 as a special case so
that callers don't have to find out the TID (which they shouldn't have
to know).


> Anyway, where do we stand?  Assuming we can address the CPU hotplug iss=
ues,
> does sched_getaffinity() look like it will be suitable?

It's only usable for the special case on the OpenMP code where the
number of threads is used to determine the number of worker threads.
For sysconf() we still need better support.  Maybe now somebody will
step up and say they need faster sysconf as well.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig57DD67FE212B30AFAE70CA39
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEtyi2ijCOnn/RHQRAsTQAJ0Qnv9ERvT0vt5xjocIlYknfcE8XgCcCixW
uQKXXF5BzTFJT11wdA02DVA=
=2UFm
-----END PGP SIGNATURE-----

--------------enig57DD67FE212B30AFAE70CA39--
