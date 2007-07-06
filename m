Return-Path: <linux-kernel-owner+w=401wt.eu-S1763904AbXGFSQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763904AbXGFSQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 14:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760619AbXGFSQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 14:16:05 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:51464 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761266AbXGFSQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 14:16:04 -0400
Message-ID: <468E86DF.4050509@web.de>
Date: Fri, 06 Jul 2007 20:15:59 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: kgdb-bugreport@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: preemption counter havoc on kgdb-taken faults (was: kgdb Bad IO access)
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>	<468E4BA5.8010601@imap.cc> <468E8106.8080801@windriver.com>
In-Reply-To: <468E8106.8080801@windriver.com>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD1A557E5BB67CA9F97FBD950"
X-Provags-ID: V01U2FsdGVkX186U/p+EN5f/zEMwCJvs/nOa0mneJAsnM82QpiJ
	XVBaSRndCK0ShjCNsxKQkvHvqT7vL6YX9F8Hk/v4tPMKZAe+Cd
	isxrr1KO4=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD1A557E5BB67CA9F97FBD950
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Jason Wessel wrote:
> The only place I could foresee that kgdb could be eating extra cycles i=
n=20
> the runtime case is from the die_notifier processing.  Any kind of=20
> exception such as a page fault, trap etc... will have a few extra ops=20
> and checks of variables so as to determine if the debugger should take =

> the exception.  It looks to me like it would even benefit to add the=20
> check at the top of the notify hook for kgdb to exit immediately if the=
=20
> debugger is not attached.
>=20
> I have contemplated making some changes to KGDB so as to make the=20
> registration to the die_notifier to be dynamic with attaching and=20
> detaching of the debugger.  If this is done, I would also make a change=
=20
> to allow for the case where the kernel would wait for the debugger to=20
> attach on any fatal fault.

At this chance... Reminds me that this old issue still seems to be
unsolved in current kgdb:

http://www.mail-archive.com/kgdb-bugreport@lists.sourceforge.net/msg00442=
=2Ehtml

I'm only looking at that spot in kgdb right now and /may/ oversee new
border conditions elsewhere. But my feeling is there are none.

Jan (looking forward to see kgdb merged)


--------------enigD1A557E5BB67CA9F97FBD950
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGjobgniDOoMHTA+kRAgmqAJ0VFklTDNsWYzaYcoYtXPzQE9HsPQCeMt2v
Q4BcvTJKQCGVGN17JqiN2GQ=
=CwjS
-----END PGP SIGNATURE-----

--------------enigD1A557E5BB67CA9F97FBD950--
