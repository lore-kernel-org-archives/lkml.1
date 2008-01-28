Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbYA1B7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbYA1B7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 20:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYA1B71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 20:59:27 -0500
Received: from mail.admingilde.org ([213.95.32.147]:45076 "EHLO
	mail.admingilde.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYA1B70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 20:59:26 -0500
X-Greylist: delayed 1715 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 20:59:26 EST
Date: Mon, 28 Jan 2008 02:30:50 +0100
From: Martin Waitz <tali@admingilde.org>
To: Gianluca Alberici <gianluca@abinetworks.biz>, linux-kernel@vger.kernel.org
Cc: Ulrich Drepper <drepper@redhat.com>
Subject: NFS EINVAL with O_TRUNC
Message-ID: <20080128013050.GR27354@admingilde.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tAdHiH28s3ybHVSb"
Content-Disposition: inline
X-PGP-Fingerprint: B21B 5755 9684 5489 7577  001A 8FF1 1AC5 DFE8 0FB2
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tAdHiH28s3ybHVSb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hoi :)

I bisected the kernel to find out why cfs stopped working.
(open with O_TRUNC returning EINVAL when file already exists on an
cfs file system.)
First I tried to debug cfs itself, and after reading Gianlucas thread on
lkml I then looked at the kernel itself.

1c710c896eb461895d3c399e15bb5f20b39c9073 is first bad commit
commit 1c710c896eb461895d3c399e15bb5f20b39c9073
Author: Ulrich Drepper <drepper@redhat.com>
Date:   Tue May 8 00:33:25 2007 -0700

    utimensat implementation
   =20
    Implement utimensat(2) which is an extension to futimesat(2) in that it
   =20
    a) supports nano-second resolution for the timestamps
    b) allows to selectively ignore the atime/mtime value
    c) allows to selectively use the current time for either atime or mtime
    d) supports changing the atime/mtime of a symlink itself along the lines
       of the BSD lutimes(3) functions
    [...]

I don't have any clue how this commit can break cfs, but it definitely does.
At least it uncovers some bug either in the Linux NFS client or in the
cvs server code.

So, and now I will happily go to sleep...
Thanks to everybody who can figure out why above commit breaks stuff...

--=20
Martin

--tAdHiH28s3ybHVSb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHnTBKj/Eaxd/oD7IRAiouAJ4znCqiUGr4j4ideoR6RMI+UacWJACeNRK3
Ho2ocIFDWwyYPsyOiuoMhy4=
=2n1q
-----END PGP SIGNATURE-----

--tAdHiH28s3ybHVSb--
