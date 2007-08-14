Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbXHNKXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbXHNKXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbXHNKXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:23:07 -0400
Received: from nef2.ens.fr ([129.199.96.40]:1540 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099AbXHNKXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:23:05 -0400
X-Greylist: delayed 3187 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 06:23:05 EDT
Date: Tue, 14 Aug 2007 11:29:42 +0200
From: Nicolas George <nicolas.george@ens.fr>
To: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       jdike@linux.intel.com, mtk-manpages@gmx.net
Message-ID: <20070814092942.GA14324@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Tue, 14 Aug 2007 11:29:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--kXdP64Ggrk/fb43R
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Cc:=20
Bcc:=20
Subject: Re: UML/man: BLKGETSIZE takes a long, not an int
Reply-To:=20
In-Reply-To: <20070813124247.GA7414@she-seel.salle-s.org>

Hi.

I fear that my bug-report yesterday was very badly written, with me writing
to the wrong mailing-list and all.

I was saying:

> I found a type mismatch in UML that makes host block devices unusable as =
ubd
> devices on x86_64 and other 64 bits systems (segfault of the mm subsystem=
):
>=20
> In block/ioctl.c, the following lines show that the BLKGETSIZE ioctl expe=
cts
> a pointer to a long:
>=20
> 	case BLKGETSIZE:
> 		if ((bdev->bd_inode->i_size >> 9) > ~0UL)
> 			return -EFBIG;
> 		return put_ulong(arg, bdev->bd_inode->i_size >> 9);
>=20
> In arch/um/os-Linux/file.c, os_file_size calls it with an int.
>=20
> The ioctl_list man page should be fixed as well.

I add that the bug was still there yesterday in the git repository.

I join the patch to file.c.

Regards,

--=20
  Nicolas George

--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
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

--u3/rZRmxL6MmkK24--

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (SunOS)

iD8DBQFGwXYGsGPZlzblTJMRApedAJ9Wq+sRaXrv62yt9NIxanJ548jzUgCgzG8a
2uU1AubmBlL7YVZIQHv28KE=
=82ZP
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
