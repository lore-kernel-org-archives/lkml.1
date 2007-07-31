Return-Path: <linux-kernel-owner+w=401wt.eu-S1762471AbXGaXpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762471AbXGaXpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbXGaXp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:45:27 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49084 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbXGaXpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:45:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] clean Modules.symvers in external module dirs
Date: Tue, 31 Jul 2007 19:45:34 -0400
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200707311938.45116.vapier@gentoo.org>
In-Reply-To: <200707311938.45116.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart53936386.PZOYp0yayc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707311945.34672.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart53936386.PZOYp0yayc
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

At the moment, running `make clean` in an external module directory does a
nice job of cleaning up with one exception: it leaves behind Modules.symver=
s.=20
Attached patch adds this file to the clean list for external modules.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
=2D--
err it'd help if i actually prefixed the external directory

diff --git a/Makefile b/Makefile
index dfe3d16..1db97d6 100644
=2D-- a/Makefile
+++ b/Makefile
@@ -1253,8 +1253,10 @@ $(clean-dirs):
 	$(Q)$(MAKE) $(clean)=3D$(patsubst _clean_%,%,$@)
=20
 clean:	rm-dirs :=3D $(MODVERDIR)
+clean: rm-files :=3D $(KBUILD_EXTMOD)/Module.symvers
 clean: $(clean-dirs)
 	$(call cmd,rmdirs)
+	$(call cmd,rmfiles)
 	@find $(KBUILD_EXTMOD) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \) \

--nextPart53936386.PZOYp0yayc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iQIVAwUARq/JnkFjO5/oN/WBAQKNoRAAsjrYUP3zXXFMhrUSRhNP/LdRe/TlICFz
tb2hRzZuznpuczyurrLSJJI4IOPJ1YdLjntUvzoARStrfXKPouCNvM0P5hYdcLOS
trljh7/DEYZEmNz4M+EDEYvVkrfzFpxorp430AP3pc5iUcbVN/fuRwSvyqFgv1k6
IlP1UZ5L9ZlCksPQyKwtZs9NZY85YB6IQXvGNvJ5NdIJ8aZ0d1kuV3K7l0ZYDEkL
kDMz6DAtokZGhCdqO3Q81xxKfCoocdPIOfrkzbwPpbXgYag5OycCHwT9kBcc+gSE
TlG4Uo7tk0EtA1aTx8Xkel+ynEnMaEZqoAngH65E/LYDa1KZaLzXIis5ZGsWxrq6
w2b+VTyGHj2Besy80Nn/vHpnpnCQ/QovMVu5qz7AgDA4dtyBQXVC7wTrii3iHCaa
2Jeaq7Gg9TaaCyyTB+JRbMKKNez59RX2/pxBkSghYBRvBT6Fkfc9IPmHGS3AnFEA
/Sf0hg1nKY4ZZf9g0W5RtR4oZhiBJxTC005RHuMflyb9qbZRDtGhuBKcNHKrIKpW
weDxVQXEOSBbChUojitYNjtS3xbP8bEL3ItPmTPoGugr4M47fWjABhDYlflEGMmo
UMm93Kz1EiRj2swNE9s/yy9jASWpGiTb2pX0fV+sp2Bx4VdB4PRVu70BAU3FKKIg
jWjGwjNe/vo=
=pf/5
-----END PGP SIGNATURE-----

--nextPart53936386.PZOYp0yayc--
