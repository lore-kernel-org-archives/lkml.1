Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbYKDQCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbYKDQCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYKDQCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:02:05 -0500
Received: from mx33.mail.ru ([194.67.23.194]:3337 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506AbYKDQCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:02:04 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.28-rc3: usb_hcd_poll_rh_status: array subscript is above array bounds
Date: Tue, 4 Nov 2008 19:01:54 +0300
User-Agent: KMail/1.9.10
Cc: USB list <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0811030952080.2454-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0811030952080.2454-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1323241.D7nTJNSOnU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811041901.55808.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1323241.D7nTJNSOnU
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 03 November 2008, Alan Stern wrote:
> On Mon, 3 Nov 2008, Andrey Borzenkov wrote:
>=20
> >   CC [M]  drivers/usb/core/hcd.o
> > /home/bor/src/linux-git/drivers/usb/core/hcd.c: In function =E2=80=98us=
b_hcd_poll_rh_status=E2=80=99:
> > /home/bor/src/linux-git/arch/x86/include/asm/string_32.h:75: warning: a=
rray subscript is above array bounds
> >=20
> > It is likely that issue is actually in string_32.h as similar errors are
> > in oher places as well.
>=20
> I think this is actually a compiler bug.  It certainly has nothing to
> do with USB.  There was a discussion about it a month or so ago on
> LKML.
>=20



Yes this really looks like a compiler bug, "length" hardly can be considered
constant expression even using very broad definition of "constant".

What is interesting though, it appears that compiler believes length has
value of 5. So it will copy one extra byte; and possibly pass incorrect
length to the caller. I cannot judge whether this garbage can do any harm.

Dp you know if it was ever reported to gcc folks?

--nextPart1323241.D7nTJNSOnU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkQcfMACgkQR6LMutpd94wzvgCfRXhkRPBJJaBJAke+TZtAJrzB
m9MAn037YqX++0X/62OCy/5iCdEI54Y9
=r31F
-----END PGP SIGNATURE-----

--nextPart1323241.D7nTJNSOnU--
