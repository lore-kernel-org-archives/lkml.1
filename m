Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYE3Ef6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYE3Ef6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYE3Efu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:35:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:30011 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYE3Eft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=kEzWQO825smGMraOw5UaCH6ErSCPWfUSGSIUWXVXdk0OTn3YAHDzvevkjWhdm9+0HQdUnmW3mmcxi8t7sINioOFezCPy078I6fnPq3BHExPNOBdn1uP8W+eI1p7y/QOMEq1oz5z8krI1jwE2Y0w+11OsYMDKXMUQHvN/1rCHSck=
Subject: Re: linux/a.out.h is not exported to userspace
From: Khem Raj <raj.khem@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: k.shutemov@gmail.com, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20080523003256.3ff82660.akpm@linux-foundation.org>
References: <1210983237.8550.28.camel@isis>
	 <20080523003256.3ff82660.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RWm4XrTOWc+3w950efY1"
Date: Thu, 29 May 2008 21:35:44 -0700
Message-Id: <1212122144.32524.8.camel@isis>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RWm4XrTOWc+3w950efY1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-23 at 00:32 -0700, Andrew Morton wrote:
> On Fri, 16 May 2008 17:13:57 -0700 Khem Raj <raj.khem@gmail.com> wrote:

>=20
> This breaks `make headerscheck' on s390:
>=20
> /usr/src/devel/usr/include/linux/a.out.h requires asm/a.out.h, which does=
 not exist in exported headers
>=20
> which might be an s390 problem.

The attached patch from David is a replacement patch. I have tested this
patch by running make headers_install on every architecture under arch/
It works for all (except 'um' and 'ppc' which do not export headers)

Thanks

-Khem


Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Khem Raj <raj.khem@gmail.com>

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 93b9885..b6fbb25 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -166,6 +166,9 @@ unifdef-y +=3D acct.h
 unifdef-y +=3D adb.h
 unifdef-y +=3D adfs_fs.h
 unifdef-y +=3D agpgart.h
+ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.=
out.h)
+unifdef-y +=3D a.out.h
+endif
 unifdef-y +=3D apm_bios.h
 unifdef-y +=3D atalk.h
 unifdef-y +=3D atmdev.h


--=-RWm4XrTOWc+3w950efY1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIP4QgHnJKy6V6em4RAtPKAKCAAUrH/JvS+YC4SPz0tPhf89H+oACfU9hA
ZhjlltQY8dl+x0v+XtqEZsU=
=9Qct
-----END PGP SIGNATURE-----

--=-RWm4XrTOWc+3w950efY1--

