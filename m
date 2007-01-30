Return-Path: <linux-kernel-owner+w=401wt.eu-S965165AbXA3AgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965165AbXA3AgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965242AbXA3AgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:36:01 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:57905 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965165AbXA3AgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:36:00 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: linux-kernel@vger.kernel.org
Subject: [patch] new toplevel target: headers_check_all
Date: Mon, 29 Jan 2007 19:36:45 -0500
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_eMpvFxEWOamSqOR"
Message-Id: <200701291936.46523.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_eMpvFxEWOamSqOR
Content-Type: multipart/signed;
  boundary="nextPart2967080.hACoIFd5v0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2967080.hACoIFd5v0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

useful for distros (and people with too much time on their hands) that supp=
ort=20
a ton of architectures, headers_check_all is to headers_check as=20
headers_install_all is to headers_install
=2Dmike

--nextPart2967080.hACoIFd5v0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iQIVAwUARb6THkFjO5/oN/WBAQL2eBAA0PRObt/536zz8/Og+yUOusQIAR3VYjqo
G5+p1WYrkgZ5T/6fIbRP9Hzepz6f1uxvDNTOQLffjUCs0LKxjkPZRv5XOtAZqrQq
ZS9+iMV1EcIolo5vwRHt8GccFBAr3scvpmBc/DKhJyM9QAqnUUZyjZ9z0Zf/rLB4
j0G6uE+RSPe9WVboTmYQcgmIq3ipAjmg9tH81Wnx5m0r7aa5Z3ejwz1bH0LZFWIt
rlF6ew2kGdgtgqLCC+T62TI4ug+RvMx/oIhOSfxlFhvyrxZhn//UzOLi/UkSTMqG
8gs764+D4kuzUZ4vA0+Q7PpVdPhVYCy/xqmOXn1IZQEuYFx+BULmQgr7VID9YVmV
QWFk1UzdURaoO6sFy2Dv92u9DiqlyZstEGcMjfiHFazKkROudJ28Xg6X8I0ei9lI
pnytvy4FdC2hrQvEzIHgaOLV8sHWesTZS0k/k3jXzszaI3jeTHyIQB1I4qoN4EgN
4EPz1GKSP2WkCQxcOgFo+Q3jxLu1w76zf7DXOhnk/oGP9cThyHPcXM+LJyd2LwxL
67PS+i4dJrzIK0O29sO9z0C7SOd58J9BTs7Qa4/euJMjj7iVBrJjDtCsFbmdvDhc
fdqNe8c0n3KhWDSiVXC1+qjTGiw/Ckln04r1/JRCu7tn+bCjc9HErcOpWEoZjDOe
Z39LE3Juol4=
=GGL1
-----END PGP SIGNATURE-----

--nextPart2967080.hACoIFd5v0--

--Boundary-00=_eMpvFxEWOamSqOR
Content-Type: text/x-diff;
  charset="us-ascii";
  name="linux-headers-check-all.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="linux-headers-check-all.patch"

Add new headers_check_all target for checking all arches in one go.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>

--- a/Makefile
+++ b/Makefile
@@ -936,6 +936,12 @@ headers_install: include/linux/version.h scripts_basic FORCE
 	$(Q)$(MAKE) $(build)=scripts scripts/unifdef
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.headersinst obj=include
 
+PHONY += headers_check_all
+headers_check_all: headers_install_all
+	$(Q)for arch in $(HDRARCHES); do \
+	 $(MAKE) ARCH=$$arch -f $(srctree)/scripts/Makefile.headersinst obj=include BIASMDIR=-bi-$$arch HDRCHECK=1 ;\
+	 done
+
 PHONY += headers_check
 headers_check: headers_install
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.headersinst obj=include HDRCHECK=1

--Boundary-00=_eMpvFxEWOamSqOR--
