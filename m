Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXBACTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXBACTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 21:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933340AbXBACTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 21:19:00 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:53003 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932978AbXBACS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 21:18:59 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.20-rc7
Date: Thu, 1 Feb 2007 04:16:48 +0200
User-Agent: KMail/1.9.6
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5396694.LIL18qlPpU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702010416.59469.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5396694.LIL18qlPpU
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

31 Oca 2007 =C3=87ar tarihinde =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=C4=B1n=
=C4=B1z:
> In other words, please do give it a good testing. We should have fixed the
> nasty stuff on Adrian's list (and here's another thanks to Adrian for
> keeping me on my toes!) and it's all good. But please give it a quick
> shake-down to make sure that nothing silly happened while fixing the bad
> stuff.

=46or me, both 2.6.20-rc6 and 2.6.20-rc7 fails while booting with initramfs=
=20
(initramfs that uses busybox) with "request_module: runaway loop modprobe=20
binfmt-0000" error.=20

So i modified kmod.c with [1] to get dump_stack, here is the picture taken=
=20
with [2] dump_stack enabled one with description below.

And here is the some observations that i made;

* Booting without an initramfs works,
* Booting with converted initrd from failed initramfs's content works,
* Booting with "Hello world" type initramfs described=20
in "Documentation/filesystems/ramfs-rootfs-initramfs.txt" works,

But what is not working is busybox binaries inside the _initramfs_, modifiy=
ing=20
our init shell script to use staticly linked bash with confirms that, bash=
=20
script interpretted without a problem by staticaly linked bash until=20
busybox's mount binary called inside the initramfs.

=46irst i thought somehow busybox is broken but copying initramfs's content=
 into=20
initrd works without a problem and also same binaries are working with 2.6.=
18=20
so i think its a regression in kernel but of course im not sure :), if you=
=20
need more information please ask.

[1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg109266.html
[2] http://cekirdek.uludag.org.tr/~caglar/error.png

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart5396694.LIL18qlPpU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQBFwU2by7E6i0LKo6YRAnYxAJ4x/NMFKHnb+8qc24A7dSposwsREgCgq/Y1
e4Pigq1EB+rweLp0AEyC3pQ=
=XYRx
-----END PGP SIGNATURE-----

--nextPart5396694.LIL18qlPpU--
