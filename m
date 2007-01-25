Return-Path: <linux-kernel-owner+w=401wt.eu-S965284AbXAYXmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965284AbXAYXmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 18:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965321AbXAYXmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 18:42:50 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:32804 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965284AbXAYXmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 18:42:49 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: 'asm' operand has impossible constraints
Date: Fri, 26 Jan 2007 01:40:44 +0200
User-Agent: KMail/1.9.6
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3413919.0W7jL7Ur0D";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200701260140.47760.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3413919.0W7jL7Ur0D
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

=2Drc6 fails with latest gcc 4.2 snapshot as following;

CC [M]  drivers/kvm/svm.o
drivers/kvm/svm.c:206: warning: 'inject_db' defined but not used
drivers/kvm/svm.c: In function 'svm_vcpu_run':
drivers/kvm/kvm.h:560: error: 'asm' operand has impossible constraints
make[2]: *** [drivers/kvm/svm.o] Error 1
make[1]: *** [drivers/kvm] Error 2
make: *** [drivers] Error 2

And according to this thread http://lkml.org/lkml/2006/11/11/129, solution =
is=20
converting g to rm, patch follows

Signed-off-by: S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>

Index: linux-2.6/drivers/kvm/kvm.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- linux-2.6.orig/drivers/kvm/kvm.h	2007-01-26 01:38:35.000000000 +0200
+++ linux-2.6/drivers/kvm/kvm.h	2007-01-26 01:37:48.000000000 +0200
@@ -557,7 +557,7 @@
 #ifndef load_ldt
 static inline void load_ldt(u16 sel)
 {
=2D	asm ("lldt %0" : : "g"(sel));
+	asm ("lldt %0" : : "rm"(sel));
 }
 #endif


=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart3413919.0W7jL7Ur0D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQBFuT//y7E6i0LKo6YRArNMAJ9s+cGNZdq1XHOO2X2xB1xyW4T3CwCg2MBJ
4bmoTsHByzTCpdh5EgThKYI=
=4Nlp
-----END PGP SIGNATURE-----

--nextPart3413919.0W7jL7Ur0D--
