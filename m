Return-Path: <linux-kernel-owner+w=401wt.eu-S966110AbXDCTcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966110AbXDCTcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966120AbXDCTcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:32:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966110AbXDCTcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:32:51 -0400
Message-ID: <4612ABD7.3000201@redhat.com>
Date: Tue, 03 Apr 2007 12:32:39 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <Pine.LNX.4.64.0704031152370.23808@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0704031152370.23808@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig37FB26F417660D7BF6E05C9E"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig37FB26F417660D7BF6E05C9E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> It sucks when seen from a micro-bench POV, but does it really matter=20
> overall? The vast majority of software usually calls=20
> sysconf(_SC_NPROCESSORS_*) with very little frequency (mostly once at=20
> initialization time) anyway. That's what 50us / call?

This is not today's situation.  Yes, 10 years ago when I added the
support to glibc it wasn't much of a problem.  But times change.  As I
said before in this thread, OpenMP by default scales the number of
threads used for a parallel loops depending on the number of available
processors/cores and therefore the number must be retrieved every time
(with perhaps minimal caching of a few secs, but this requires
gettimeofday calls...).  All of a sudden this is not micro benchmark
anymore.  It's a real issue which we only became aware of because it is
noticeable in real life.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig37FB26F417660D7BF6E05C9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEqvX2ijCOnn/RHQRAsfVAJ0Ys9qgzn/kJUAnoCvk1lNL/5uSQgCcDosJ
Gv93RdhXxKYKSETvx9KzpE0=
=yYsS
-----END PGP SIGNATURE-----

--------------enig37FB26F417660D7BF6E05C9E--
