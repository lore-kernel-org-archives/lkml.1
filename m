Return-Path: <linux-kernel-owner+w=401wt.eu-S1759739AbYEMRQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbYEMRQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334AbYEMRQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:16:46 -0400
Received: from mx28.mail.ru ([194.67.23.67]:3731 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbYEMRQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:16:46 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: block device statistics question
Date: Tue, 13 May 2008 19:50:10 +0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4223084.q4abFq9Mr5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200805131950.16269.arvidjaar@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4223084.q4abFq9Mr5
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

May I ask for clarification of block device stats meaning.

I am interested in basically two times - how long IO request has been
processed (i.e. from the very beginning it has been submitted till it was
finished) as well as how long *device* needed to process request passed to
it.

/sys/block/XXX/stat provides three set of timings:

read ticks, write ticks
io_ticks
time_in_queue

=46rom the description in Documentation/block/stat.txt it is not exactly cl=
ear
what is counted.

read ticks, write ticks
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

These values count the number of milliseconds that I/O requests have
waited on this block device.=20

Q. Waited since which point? From the point request entered block subsystem
or from the point request has been submitted to physical device (well,
not necessarily really physical of course)

io_ticks
=3D=3D=3D=3D=3D=3D=3D=3D

This value counts the number of milliseconds during which the device has
had I/O requests queued.

Q. "queued" - means "waited for submission"? I.e. this time does not include
actual IO processing by device? Or "queued" - submitted to device?

time_in_queue
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

This value counts the number of milliseconds that I/O requests have waited
on this block device.

Q. What is the difference between this one and read/write ticks? It really
sounds like time_in_queue =3D=3D read ticks + write ticks? In this case wha=
t is
the point in making it separate?

TIA

=2Dandrey

--nextPart4223084.q4abFq9Mr5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkgpuLQACgkQR6LMutpd94wg6QCgrrkh7b+lo4cAkdCwXkYb7kll
4yEAnjfsElLXUhb/BlLVIrp+Fdqw4fII
=CJwl
-----END PGP SIGNATURE-----

--nextPart4223084.q4abFq9Mr5--
