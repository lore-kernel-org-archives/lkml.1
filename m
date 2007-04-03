Return-Path: <linux-kernel-owner+w=401wt.eu-S1946022AbXDCWXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946022AbXDCWXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946026AbXDCWXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:23:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946022AbXDCWXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:23:18 -0400
Message-ID: <4612D3C4.9020500@redhat.com>
Date: Tue, 03 Apr 2007 15:23:00 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com> <200704040007.16916.arnd@arndb.de>
In-Reply-To: <200704040007.16916.arnd@arndb.de>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8BDE0F043A21A31C10891A8A"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8BDE0F043A21A31C10891A8A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Arnd Bergmann wrote:
> I thought this is what the read_zero_pagealigned hack [1] was used
> for (read from /dev/zero replaces target pages with empty_zero_page).

But that's not what we want.  If I understand that code correctly it's
the same as the current MADV_DONTNEED.  It will simply remove the
mapping for the pages and therefore upon new access it will provide
empty pages.

We want the pages to be kept around, even mapped, and only if memory
pressure is high enough collected and unmapped.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig8BDE0F043A21A31C10891A8A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEtPE2ijCOnn/RHQRAtySAKCFPA1Si7NYERXiRWs36m7XvmWvRgCeN4Pm
p9Dn2Mw0UIQP+6AnUE7GKOM=
=gC3i
-----END PGP SIGNATURE-----

--------------enig8BDE0F043A21A31C10891A8A--
