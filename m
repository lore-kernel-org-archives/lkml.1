Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbXEGRvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbXEGRvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 13:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbXEGRvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 13:51:39 -0400
Received: from fallback.mail.ru ([194.67.57.14]:24812 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbXEGRvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 13:51:38 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: hirofumi@mail.parknet.co.jp
Subject: Long file names in VFAT broken with iocharset=utf8
Date: Mon, 7 May 2007 21:51:14 +0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4194964.7MKHQEKNzt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705072151.20104.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4194964.7MKHQEKNzt
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This was posted in one of Russian forums. It was not possible to archive=20
(under Linux, using tar) vfat directory where files had long Russian names=
=20
(really long - over 150 - 170 characters) - tar returned stat failure. When=
=20
looking with plain ls, file names appeared truncated.

Now looking at current (2.6.21) fat driver, __fat_readdir allocates large=20
enough buffer (PAGE_SIZE-522) for UTF-8 name; but for iocharset=3Dutf8 it c=
alls=20
uni16_to_x8() which artificially limits length of UTF-8 name to 256 ... whi=
ch=20
is obviously not enough for long UTF-8 Russian string (2 bytes per characte=
r)=20
not to mention the - theoretical - general case of 6 bytes UTF-8 characters.

Similar problem has apparently vfat_lookup()->...->fat_search_long() call=20
chain. Except this appears to be broken even in case of "utf8", because=20
fat_search_long allocates fixed 256 bytes buffer for UTF-8 name.

Am I off track here?

=2Dandrey

--nextPart4194964.7MKHQEKNzt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGP2cTR6LMutpd94wRAtG4AKDQ9fjiGKn9lBXe1d/wsj9V6LFYHACgz/mQ
DyzOj1A+4BSr/AT8rnR6GPk=
=xXOF
-----END PGP SIGNATURE-----

--nextPart4194964.7MKHQEKNzt--
