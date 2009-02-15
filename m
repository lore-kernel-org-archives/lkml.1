Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbZBOT7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbZBOT7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbZBOT7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:59:09 -0500
Received: from mx5.mail.ru ([94.100.176.19]:7316 "EHLO mx5.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbZBOT7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:59:09 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [Bug #12617] unable to compile e100 firmware into kernel
Date: Sun, 15 Feb 2009 22:58:52 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-1avb; KDE/4.2.0; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.05E.3r0lJB@chimera> <1234719496.4738.19.camel@macbook.infradead.org>
In-Reply-To: <1234719496.4738.19.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3692789.pINsVtWJVG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200902152259.00244.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3692789.pINsVtWJVG
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 15 of February 2009 20:38:15 David Woodhouse wrote:
> On Sat, 2009-02-14 at 21:38 +0100, Rafael J. Wysocki wrote:
> >  This message has been generated automatically as a part of a
> > report of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me
> > know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=3D12617
> > Subject         : unable to compile e100 firmware into kernel
> > Submitter       : Andrey Borzenkov <arvidjaar@mail.ru>
> > Date            : 2009-01-31 15:59 (15 days old)
> > References      :
> > http://marc.info/?l=3Dlinux-kernel&m=3D123341764915181&w=3D4
>
> I thought this was resolved?

I guess it has to be closed. This was caused by config options mismatch=20
and I do not see how we can programmatically express "this device could=20
be required before any (even early) user space is available, so make=20
sure everything that this device needs is built in".

One possibility is following:

=2D-- drivers/base/Kconfig.orig 2009-01-17 14:46:28.000000000 +0300
+++ drivers/base/Kconfig        2009-02-15 22:57:02.000000000 +0300
@@ -37,7 +37,7 @@ config FW_LOADER

 config FIRMWARE_IN_KERNEL
        bool "Include in-kernel firmware blobs in kernel binary"
=2D       depends on FW_LOADER
+       depends on FW_LOADER =3D y
        default y
        help
          The kernel source tree includes a number of firmware 'blobs'

On assumption that compiling firmware in kernel makes no sense as long=20
as kernel does not even have facility to actually access it.

Does it make sense?

--nextPart3692789.pINsVtWJVG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmYc/4ACgkQR6LMutpd94y4WQCeJgB3iNs1blBYnqs52qAhjZTe
qdgAnjWJMdSbhA+QJqJHeVeWB50AY4e/
=GOhH
-----END PGP SIGNATURE-----

--nextPart3692789.pINsVtWJVG--
