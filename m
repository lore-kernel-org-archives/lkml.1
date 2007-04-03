Return-Path: <linux-kernel-owner+w=401wt.eu-S1161049AbXDCSVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161049AbXDCSVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 14:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161071AbXDCSVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 14:21:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161049AbXDCSVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 14:21:36 -0400
Message-ID: <46129B21.5090205@redhat.com>
Date: Tue, 03 Apr 2007 11:21:21 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403172736.GA23689@one.firstfloor.org> <46128F47.2010107@redhat.com> <20070403173505.GD23689@one.firstfloor.org> <461292BF.5020803@redhat.com> <20070403175827.GA24033@one.firstfloor.org> <4612977D.4060903@redhat.com> <20070403181100.GE23689@one.firstfloor.org>
In-Reply-To: <20070403181100.GE23689@one.firstfloor.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA82932D0E79625987175E73C"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA82932D0E79625987175E73C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andi Kleen wrote:
> I would be opposed for adding another page per process at least
> because the per process memory footprint in Linux is imho already
> too large.

That's a single page shared by all threads on the system.  Or make this
a page per NUMA node.  And if the number of threads is larger than the
share counter for page, create a few more.

But in general the extra overhead would be minimal from the memory
consumption POV.


>> No, why?  The vdso call would be so inexpensive (just a simple functio=
n
>> call) that it can be done whenever a topology-based decision has to be=

>> made.  Use cookies to determine whether nothing has been changed since=

>> the last call etc.
>=20
> But how would that mix with the OpenMP use case where you have
> thread pools that normally don't make decisions afer startup, but=20
> just stay around?

There is a different between having threads in the thread pool and
actually using them.  For every #omp loop the number of processors is
checked again and this is the number of threads from the pool which is us=
ed.


> I think for those you would need events of some sort
> to start or remove threads as needed.=20

We need no events if determining the number of processors is cheap.
There is really no reason why it shouldn't.  Restarting all the threads
is not the cheapest operation so a single syscall (sys_sysconf, etc)
does not increase the cost a lot.


> If there's a good use case fine for me. However I suspect it's
> either "slow is ok" or "want it very fast" where even a syscall
> would hurt.

Ideally, as I said, an optimized vdso call is best.  But a syscall is
OK.  The nice thing about the vdso is that for now one could simply
implement it using a syscall and in future add optimizations to avoid
the kernel entry if possible.

A single syscall is two order of magnitude better than the best solution
available today.  This is my main concern right now.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigA82932D0E79625987175E73C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEpsh2ijCOnn/RHQRAiizAJ4hHA6kdvmnwyo4/cP6DJYjhFimUwCgymSw
vMAocvZTOtAi1hkUJ1uPVuY=
=B1wp
-----END PGP SIGNATURE-----

--------------enigA82932D0E79625987175E73C--
