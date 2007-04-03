Return-Path: <linux-kernel-owner+w=401wt.eu-S1946011AbXDCWNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946011AbXDCWNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946012AbXDCWNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:13:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946011AbXDCWNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:13:19 -0400
Message-ID: <4612D175.30604@redhat.com>
Date: Tue, 03 Apr 2007 15:13:09 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com>	<20070403131623.c6831607.akpm@linux-foundation.org>	<4612BB89.8040102@redhat.com> <20070403141348.9bcdb13e.akpm@linux-foundation.org>
In-Reply-To: <20070403141348.9bcdb13e.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig63FA844940228913A744C432"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig63FA844940228913A744C432
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> Did we mean to go off-list?

Oops, no, pressed the wrong button.

>> Andrew Morton wrote:
>>> So I'd have thought that in general an application should be querying=
 its
>>> present affinity mask - something like sched_getaffinity()?  That fix=
es the
>>> CPU hotplug issues too, of course.
>> Does it really?
>>
>> My recollection is that the affinity masks of running processes is not=

>> updated on hotplugging.  Is this addressed?
>=20
> ah, yes, you're correct.
>=20
> Inside a cpuset:
>=20
>   sched_setaffinity() is constrained to those CPUs which are in the
>   cpuset.
>=20
>   If a cpu if on/offlined we update each cpuset's cpu mask appropriatel=
y
>   but we do not update all the tasks presently running in the cpuset.
>=20
> Outside a cpuset:
>=20
>   sched_setaffinity() is constrained to all possible cpus
>=20
>   We don't update each task's cpus_allowed when a CPU is removed.
>=20
>=20
> I think we trivially _could_ update each tasks's cpus_allowed mask when=
 a
> CPU is removed, actually.

I think it has to be done.  But that's not so trivial.  What happens if
all the CPUs a process was supposed to be runnable on vanish.
Shouldn't, if no affinity mask is defined, new processors be added?  I
agree that if the process has a defined affinity mask no new processors
should be added _automatically_.


>> If yes, sched_getaffinity is a solution until the NUMA topology
>> framework can provide something better.  Even without a popcnt
>> instruction in the CPU (64-bit albeit) it's twice as fast as the the
>> stat() method proposed.
>=20
> I'm surprised - I'd have expected sched_getaffinity() to be vastly quic=
ker
> that doing fileystem operations.

You mean because it's only a factor of two?  Well, it's not once you
count the whole overhead.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig63FA844940228913A744C432
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEtF12ijCOnn/RHQRAuFQAJ92JTJ0LrFILt8nuAL1tMr8o+xrrgCgmFQ9
A6Gd4+d/zZlWoxqm5n/6WrI=
=b/sE
-----END PGP SIGNATURE-----

--------------enig63FA844940228913A744C432--
