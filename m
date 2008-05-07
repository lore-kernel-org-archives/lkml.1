Return-Path: <linux-kernel-owner+w=401wt.eu-S1761896AbYEGDtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896AbYEGDtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 23:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbYEGDtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 23:49:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33839 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370AbYEGDtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 23:49:19 -0400
Date: Wed, 7 May 2008 13:49:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: [patch, -git] drivers/media build fix for modular builds
Message-Id: <20080507134907.4417708b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_May_2008_13_49_07_+1000_8uQjfuTzw/qavFCJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_May_2008_13_49_07_+1000_8uQjfuTzw/qavFCJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Date:	Wed, 30 Apr 2008 09:48:07 +0200
From:	Ingo Molnar <mingo@elte.hu>
To:	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc:	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org

fix allmodconfig build bug introduced in latest -git by commit=20
7c91f0624a9 ("V4L/DVB(7767): Move tuners to common/tuners"):

  LD      kernel/built-in.o
  LD      drivers/built-in.o
  ld: drivers/media/built-in.o: No such file: No such file or directory

which happens if all media drivers are modular:

  http://redhat.com/~mingo/misc/config-Wed_Apr_30_09_24_48_CEST_2008.bad

In that case there's no obj-y rule connecting all the built-in.o files and
the link tree breaks.

the fix is to add a guaranteed obj-y rule for the core vmlinux to build.
(which results in an empty object file if all media drivers are modular)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/media/Makefile |    2 ++
 1 file changed, 2 insertions(+)

Linus,

I have been applying a similar patch to linux-next for some time.  It has
been reported a while ago and does break (at least) powerpc and x86_64
allmodconfig builds.

Please apply at you earliest convenience.

/me tries out his "random-build-fix-monkey" appointment.

Index: linux/drivers/media/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/media/Makefile
+++ linux/drivers/media/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the kernel multimedia device drivers.
 #
=20
+obj-y :=3D common/
+
 obj-$(CONFIG_VIDEO_MEDIA) +=3D common/
=20
 # Since hybrid devices are here, should be compiled if DVB and/or V4L

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_May_2008_13_49_07_+1000_8uQjfuTzw/qavFCJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIISa5TgG2atn1QN8RAqRmAJ4/ZT81Szhzj8Ms573O9YVLHyIhzwCeIiqF
ZBDCJWm0Xy2NnASwrmj0ZYw=
=rveX
-----END PGP SIGNATURE-----

--Signature=_Wed__7_May_2008_13_49_07_+1000_8uQjfuTzw/qavFCJ--
