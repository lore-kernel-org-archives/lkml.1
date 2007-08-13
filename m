Return-Path: <linux-kernel-owner+w=401wt.eu-S947960AbXHMPEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947960AbXHMPEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S972321AbXHMMmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:42:52 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:44908 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S972304AbXHMMmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:42:49 -0400
Date: Mon, 13 Aug 2007 14:42:47 +0200
From: Nicolas George <nicolas.george@normalesup.org>
To: linux-kernel@vger.kernel.org, uml-devel@lists.sourceforge.net
Subject: UML/man: BLKGETSIZE takes a long, not an int
Message-ID: <20070813124247.GA7414@she-seel.salle-s.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Disposition: inline


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

I found a type mismatch in UML that makes host block devices unusable as ubd
devices on x86_64 and other 64 bits systems (segfault of the mm subsystem):

In block/ioctl.c, the following lines show that the BLKGETSIZE ioctl expects
a pointer to a long:

	case BLKGETSIZE:
		if ((bdev->bd_inode->i_size >> 9) > ~0UL)
			return -EFBIG;
		return put_ulong(arg, bdev->bd_inode->i_size >> 9);

In arch/um/os-Linux/file.c, os_file_size calls it with an int.

The ioctl_list man page should be fixed as well.

Regards,

--=20
  Nicolas George

--huq684BweRXVnRxX
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="linux-umlblkgetsize-20070813.diff"
Content-Transfer-Encoding: quoted-printable

diff --git a/arch/um/os-Linux/file.c b/arch/um/os-Linux/file.c
index 6f92f73..c3ecc2a 100644
--- a/arch/um/os-Linux/file.c
+++ b/arch/um/os-Linux/file.c
@@ -320,7 +320,8 @@ int os_file_size(char *file, unsigned long long *size_o=
ut)
 	}
=20
 	if(S_ISBLK(buf.ust_mode)){
-		int fd, blocks;
+		int fd;
+		long blocks;
=20
 		fd =3D os_open_file(file, of_read(OPENFLAGS()), 0);
 		if(fd < 0){

--huq684BweRXVnRxX--

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGwFHHsGPZlzblTJMRAvGKAKC/7LMJbxHSEkQAD1YI6M2vEHFNYQCdHIHe
upQ8eAtszSYMQbRbVn7+NCo=
=6r/h
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
