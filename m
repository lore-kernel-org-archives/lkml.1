Return-Path: <linux-kernel-owner+w=401wt.eu-S934111AbXGRRrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111AbXGRRrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbXGRRqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:46:53 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:40928 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751006AbXGRRqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:46:52 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
Date: Wed, 18 Jul 2007 20:46:02 +0300
User-Agent: KMail/1.9.7
Cc: Anthony Liguori <anthony@codemonkey.ws>, kvm-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <11846910642166-git-send-email-avi@qumranet.com> <200707181309.11900.caglar@pardus.org.tr> <469DEC04.8000503@qumranet.com>
In-Reply-To: <469DEC04.8000503@qumranet.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1645361.qppIEI9WYJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707182046.05358.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1645361.qppIEI9WYJ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Avi;

18 Tem 2007 =C3=87ar tarihinde, Avi Kivity =C5=9Funlar=C4=B1 yazm=C4=B1=C5=
=9Ft=C4=B1:=20
> This trace is certainly a kvm bug.  What guest are you running?  If it
> is free (and does not contain private information), can you post it
> somewhere for me to download?

After seeing your "[PATCH] i386: Decouple PAE from CONFIG_CMPXCHG64" mail i=
=20
applied it on top of Linus's current git and disabled HIGHMEM64 (following =
is=20
the diff between configs)

caglar@zangetsu linux-2.6 $ diff -u config .config
=2D-- config      2007-07-18 12:34:36.000000000 +0300
+++ .config     2007-07-18 19:47:56.000000000 +0300
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.22
=2D# Wed Jul 18 02:32:10 2007
+# Wed Jul 18 19:47:56 2007
 #
 CONFIG_X86_32=3Dy
 CONFIG_GENERIC_TIME=3Dy
@@ -200,11 +200,10 @@
 CONFIG_DCDBAS=3Dm
 CONFIG_DMIID=3Dy
 # CONFIG_NOHIGHMEM is not set
=2D# CONFIG_HIGHMEM4G is not set
=2DCONFIG_HIGHMEM64G=3Dy
+CONFIG_HIGHMEM4G=3Dy
+# CONFIG_HIGHMEM64G is not set
 CONFIG_PAGE_OFFSET=3D0xC0000000
 CONFIG_HIGHMEM=3Dy
=2DCONFIG_X86_PAE=3Dy
 CONFIG_ARCH_FLATMEM_ENABLE=3Dy
 CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
 CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
@@ -1228,7 +1227,6 @@
 CONFIG_I2O=3Dm
 CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=3Dy
 CONFIG_I2O_EXT_ADAPTEC=3Dy
=2DCONFIG_I2O_EXT_ADAPTEC_DMA64=3Dy
 CONFIG_I2O_CONFIG=3Dm
 CONFIG_I2O_CONFIG_OLD_IOCTL=3Dy
 CONFIG_I2O_BUS=3Dm

And this time i get another oops [1] and because my kernel is tainted by=20
nvidia driver i also tried and get same with untainted one [2]. I hope they=
=20
helps...

[1] http://cekirdek.pardus.org.tr/~caglar/kvm/opps_tainted
[2] http://cekirdek.pardus.org.tr/~caglar/kvm/opps_not_tainted

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1645361.qppIEI9WYJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGnlHdy7E6i0LKo6YRAmMLAJ9o2Tu/gLdXsPTc5eYbfF2OITTMwgCfU8nT
PoPF+dxtJTaVo6gINftFKUk=
=eFYH
-----END PGP SIGNATURE-----

--nextPart1645361.qppIEI9WYJ--
