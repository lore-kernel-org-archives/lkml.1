Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbYEQAOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbYEQAOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 20:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYEQAOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 20:14:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:3581 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbYEQAN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 20:13:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer;
        b=XrQLWP2SIOUnhxssS9Tir3M9wJoRzkjJbQGOvSZg6jsoYZV51bivVnniGn4pV6cs27Av0WYhxUiL+qn9idEc8yczed0HiWPXl5LQrnAQy2TNlM3WiOFycpoFS3+tfGKTdqaDNx7JrTqNZxe8Uod7RNrKcqao+z1u+9yRT77ODcs=
Subject: linux/a.out.h is not exported to userspace
From: Khem Raj <raj.khem@gmail.com>
To: k.shutemov@gmail.com, Khem Raj <raj.khem@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0ZBul+WFpOuasrDEz7i8"
Date: Fri, 16 May 2008 17:13:57 -0700
Message-Id: <1210983237.8550.28.camel@isis>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0ZBul+WFpOuasrDEz7i8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Looking for a compile failure for a package on uclibc system using
kernel-headers from 2.6.25 I found that linux/a.out.h is no more
exported to userland anymore.

This commit below has disabled it from being exported. The commit Do not
export asm/page.h during make headers_install so I was wondering if it
was intended to unexport linux/a.out.h or not.

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
itdiff;h=3Ded7b1889da256977574663689b598d88950bbd23


Looking at the patch from lkml post

http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-10/msg08913.html

second hunk to include/linux/Kbuild was not applied which caused this
problem.

I think I do not fall into Signed-off-by definition. I tested the
following patch on 2.6.25.

Thanks

-Khem

Tested-by: Khem Raj <raj.khem@gmail.com>

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index b7d81b2..8a3d93e 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -168,6 +168,7 @@ unifdef-y +=3D acct.h
 unifdef-y +=3D adb.h
 unifdef-y +=3D adfs_fs.h
 unifdef-y +=3D agpgart.h
+unifdef-y +=3D a.out.h
 unifdef-y +=3D apm_bios.h
 unifdef-y +=3D atalk.h
 unifdef-y +=3D atmdev.h


--=-0ZBul+WFpOuasrDEz7i8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBILiNFHnJKy6V6em4RAg/WAJ9VBqV7ZFpQ6EYCInzhoPR9TXrZlACbBvA3
UesiFxCcy9zI2hvFts5ofIE=
=/Y4D
-----END PGP SIGNATURE-----

--=-0ZBul+WFpOuasrDEz7i8--

