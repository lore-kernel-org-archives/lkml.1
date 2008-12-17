Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753120AbYLQOa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbYLQOa2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 09:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYLQOaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 09:30:12 -0500
Received: from postman.teamix.net ([194.150.191.120]:54628 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751041AbYLQOaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 09:30:11 -0500
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: linux-kernel@vger.kernel.org
Subject: Re: physical memory limit of 64-bit linux
Date: Wed, 17 Dec 2008 15:30:06 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andi Kleen <andi@firstfloor.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <200812161556.25518.ms@teamix.de> <200812161654.17291.rjw@sisk.pl> <20081216184742.GL11683@elte.hu>
In-Reply-To: <20081216184742.GL11683@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1978444.ChWvtmH0M3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812171530.07946.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1978444.ChWvtmH0M3
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag, 16. Dezember 2008 schrieb Ingo Molnar:
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, 16 of December 2008, Martin Steigerwald wrote:
> > > Hi!
> > >
> > > What is the physical memory limit for 64-bit Linux? I read about 40
> > > bit address bus for AMD Athlon X2 (1 TB) and 48 bit for Barcelona X4
> > > (256 TB).
> > >
> > > Is 64-bit linux able to use that amount - provided that one would
> > > manage to build it into a machine? Or does it have a lower limit?
> > >
> > > Looking into the Google crystal ball gives unclear pictures... I tend
> > > to assume that Linux would handle it, but I am not sure.
> >
> > IIRC, the current maximal virtual memory space size of the kernel on
> > x86_64 is 2^46.
>
> Almost: the real current upstream kernel hard memory limit on x86-64 is 44
> bits, i.e. 16 TB.
>
> There's a couple of limits to consider here.
>
> Firstly, there's the architectural limit imposed by the CPU - that is 48
> bits, 256 TB. That is the full virtual memory range that x86-64 CPUs are
> able to address: non-canonical addresses outside that range create an
> exception.
>
> I.e. valid addresses on x86-64 are in the range of:
>
>         [ 0xffff800000000000...0x00007fffffffffff ]
>
> Which is minus 128 TB to plus 128 TB.

[...]

> This problem is academic because there are no such systems in existence,
> and because we have another limit on the size of physical memory:
>
>   arch/x86/include/asm/sparsemem.h:
>   # define MAX_PHYSMEM_BITS	44

So this gives a real 16 TB for userspace applications or is it splitted int=
o=20
minus 8 TB for kernel and plus 8 TB for userspace again?

How much memory can a process consume? On 32-Bit with 1GB/3GB split its 3=20
GB... are there special process limits on x86_64 or IA64?

BTW should any of those limits by documented outside of source or this=20
mailinglist? Maybe doesn't make too much sense cause it could change anytim=
e=20
anyway.

Ciao,
=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart1978444.ChWvtmH0M3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklJDO8ACgkQHhDFkwOZrpAPYgCdFihmQHDlftH+SLsJrewmiuGI
hRkAnjrLpmqeeoUVe4OEHUG24OIj3am5
=3NQj
-----END PGP SIGNATURE-----

--nextPart1978444.ChWvtmH0M3--
