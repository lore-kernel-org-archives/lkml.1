Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYBKQRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYBKQRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbYBKQRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:17:47 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:39089 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113AbYBKQRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:17:46 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Linux 2.6.25-rc1
Date: Mon, 11 Feb 2008 11:17:41 -0500
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <20080211133137.GB20959@uranus.ravnborg.org>
In-Reply-To: <20080211133137.GB20959@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1324979.hF6DGWrZPB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802111117.42450.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1324979.hF6DGWrZPB
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 11 February 2008, Sam Ravnborg wrote:
> From 49af821e4b1c07e756cbc2e389eba9d885912602 Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Mon, 11 Feb 2008 14:26:26 +0100
> Subject: [PATCH] kbuild: fix make V=3D1
>
> When make -s support were added to filechk to
> combination created with make V=3D1 were not
> covered.
> Fix it by explicitly cover this case too.
>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Mike Frysinger <vapier@gentoo.org>

erp, i wondered if there was another case i was missing ... you'll also nee=
d=20
the attached fixed ...
=2D--
When make -s support was added to compile.h, it broke make V=3D1.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
=2D--
diff --git a/init/Makefile b/init/Makefile
index c5f157c..781f102 100644
=2D-- a/init/Makefile
+++ b/init/Makefile
@@ -26,7 +26,7 @@ $(obj)/version.o: include/linux/compile.h
 # so we regenerate it always.
 # mkcompile_h will make sure to only update the
 # actual file if its content has changed.
=2D
+       chk_compile.h =3D :
  quiet_chk_compile.h =3D echo '  CHK     $@'
 silent_chk_compile.h =3D :
 include/linux/compile.h: FORCE

--nextPart1324979.hF6DGWrZPB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR7B1JkFjO5/oN/WBAQIccg//ZMy3cQ21UjkXVvn+7+vDARmjvwjSiUn1
RKtu0JfHFC4ZMaT1OSnfxJSp9DWaYtk536auXvgTiBlxtHlNkR9rL9XKuJbu4p3A
LYOx/asarckf620Ec2US7yfTgBWw0eGXAF/akMnvilYY52fuvkqZGFBHQ/0iBYm6
61dYzM/Y5eNT4X1MWaSrpzQKcyPQvNfW1AvY1M41u3R0cPNNFQLfJZXNWFDDULX6
No6rlhXOjOZtigP5NBMcZDXT2FPUd1z0DFawaUjmH6xZm6tp9oAbh34LHO+L5PGS
prmTtnr+ASK6dRX9Lr6fuXLNw8AQN1j9a0iq0jwDoQE3Hi1j6qgNP+/1FhzD3ynH
YOFMtSzBHmjkOsuTiL4cgd/FoPwf4BSQfahA/HAIdzHqT6+plXMe0krSP213n+Yl
HHQqWbM+2bemRSf36k0wvW1DtY/3Pu0GI8hFPn55vIIJVhBpue2lu/TJeUreHzr3
OKn20W/IfqZvaOAu8ozKPbzJuo6JAKd3x1pTcaLM3g1fnY1nNDVEgs6Obe5L49g8
to56Uzu2aPXuvW1BJ65Tfrk8vFb1Tqr3HSOItNK241Jb9hROsjtSaWZXqqg6iBCy
Ksmy7Jn0ep0c4YynkmcMiJeyWvQDajVdi5gpEf72puY0snGj5kvOz7b1VPZfNU/l
jRJ8hVx3ZaM=
=kolC
-----END PGP SIGNATURE-----

--nextPart1324979.hF6DGWrZPB--
