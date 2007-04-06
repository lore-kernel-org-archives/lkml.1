Return-Path: <linux-kernel-owner+w=401wt.eu-S1767512AbXDFCwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767512AbXDFCwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 22:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767516AbXDFCwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 22:52:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767416AbXDFCw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 22:52:28 -0400
Message-ID: <4615B5D9.7060703@redhat.com>
Date: Thu, 05 Apr 2007 19:52:09 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Rik van Riel <riel@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de> <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org> <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com> <20070403202937.GE355@devserv.devel.redhat.com> <4614A5CC.5080508@redhat.com> <46151F73.50602@redhat.com> <4615B043.8060001@yahoo.com.au>
In-Reply-To: <4615B043.8060001@yahoo.com.au>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig142F53141530ABD4FA3327D3"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig142F53141530ABD4FA3327D3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Nick Piggin wrote:
> Cool. According to my thinking, madvise(MADV_DONTNEED) even in today's
> kernels using down_write(mmap_sem) for MADV_DONTNEED is better than
> mmap/mprotect, which have more fundamental locking requirements, more
> overhead and no benefits (except debugging, I suppose).

It's a tiny bit faster, see

  http://people.redhat.com/drepper/dontneed.png

I just ran it once so the graph is not smooth.  This is on a UP dual
core machine.  Maybe tomorrow I'll turn on the big 4p machine.

I would have to see dramatically different results on the big machine to
make me change the libc code.  The reason is that there is a big drawback=
=2E

So far, when we allocate a new arena, we allocate address space with
PROT_NONE and only when we need memory the protection is changed to
PROT_READ|PROT_WRITE.  This is the advantage of catching wild pointer
accesses.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig142F53141530ABD4FA3327D3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGFbXZ2ijCOnn/RHQRAt06AKCJzuZsl2Ba8VCRWWUc2+BbSQ+16ACgnIGM
6NuLcq3+/gFllhoYBNJ0AtU=
=63qB
-----END PGP SIGNATURE-----

--------------enig142F53141530ABD4FA3327D3--
