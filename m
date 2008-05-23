Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYEWQCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYEWQCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbYEWQCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:02:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:56439 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbYEWQCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:02:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=BAvnrFSe193Hb90SKX4Fq1hn26zmYl+vAtmL+0vs6BBBM7yroWqt/0eaT1eEBA66AtzV6ALW5UXDz4G2lneMdFc1Q4E4Y06TnNqj+kitUGeCwWsOOznI7TrUAcZBbb5tfCCpT3KycibPEmk7Y1wTuqVcD20PrqT6nzRfXYrPhfI=
Subject: Re: linux/a.out.h is not exported to userspace
From: Khem Raj <raj.khem@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: k.shutemov@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080523003256.3ff82660.akpm@linux-foundation.org>
References: <1210983237.8550.28.camel@isis>
	 <20080523003256.3ff82660.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HccnTWIXZ0vQAsyLv1wc"
Date: Fri, 23 May 2008 09:02:42 -0700
Message-Id: <1211558562.10806.22.camel@isis>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HccnTWIXZ0vQAsyLv1wc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-23 at 00:32 -0700, Andrew Morton wrote:

>=20
> This breaks `make headerscheck' on s390:
>=20
> /usr/src/devel/usr/include/linux/a.out.h requires asm/a.out.h, which does=
 not exist in exported headers
>=20
> which might be an s390 problem.

There was also this patch that David proposed here

http://lkml.org/lkml/2008/5/18/46

this patch also takes care of the architectures that do not have
asm/a.out.h. I tried this patch on s390 and arm one with and one without
asm/a.out.h

Thanks

-Khem



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


--=-HccnTWIXZ0vQAsyLv1wc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBINuqiHnJKy6V6em4RAqGEAJ4k3eYsdbdrdTKZFhPsSIJ2hDsptACglvGo
HWFvPVIMe1z9fjkBREDRRA8=
=HbeB
-----END PGP SIGNATURE-----

--=-HccnTWIXZ0vQAsyLv1wc--

