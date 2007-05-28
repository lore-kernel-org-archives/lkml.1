Return-Path: <linux-kernel-owner+w=401wt.eu-S1762686AbXE1RB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762686AbXE1RB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 13:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbXE1RBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 13:01:49 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34307 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbXE1RBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 13:01:48 -0400
X-Sasl-enc: 46fHyC3ISWMB3NMEvL86utFkmkDlIE2S86WuOGt11qvk 1180371706
Message-ID: <465B0BC9.2040502@imap.cc>
Date: Mon, 28 May 2007 19:05:13 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: "Lars K.W. Gohlke" <lkwg82@gmx.de>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de> <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr> <4648E9F7.5090908@imap.cc> <Pine.LNX.4.61.0705151020310.9570@yvahk01.tjqt.qr> <46536C0F.50101@imap.cc> <4655676A.1000102@gmx.de> <4655C554.7030000@imap.cc> <4655C93D.40005@gmx.de> <Pine.LNX.4.61.0705241927410.31549@yvahk01.tjqt.qr> <4655E463.7000201@gmx.de>
In-Reply-To: <4655E463.7000201@gmx.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig04B0724A189B80F4DE3EF3C7"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig04B0724A189B80F4DE3EF3C7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 24.05.2007 21:15 schrieb Lars K.W. Gohlke:
> Jan Engelhardt schrieb:
[code proposal]
>> [I've warned about it... ;-) ]
>=20
> is it the way to access from kernelspace the userspace fs?
> the not-correct-way?

Yes, indeed.

> If it is so, I will wait for another solution ;)

I'm not sure waiting will help. The roasted pigeons will not come
flying into your mouth.

The possible solutions have been sketched out for you:

a) open the device file from the kernel (described by Jan):
   actively discouraged by the kernelnewbies.org FAQ document,
   and probably won't even work IMHO

b) program the serial port directly (described by Jan):
   will work only with one type of hardware and you'll have to
   disable the regular serial driver first; frowned upon by kernel
   gurus as "reinventing the wheel"

c) abuse the line discipline interface (described by me):
   moderately well documented, and there's precedent for using it
   that way in the well-accepted PPP module as well as my humble
   contribution, the ser_gigaset driver; requires a userspace
   daemon for pushing the line discipline module on the serial
   port and keeping it there

d) use the serio interface (described by Ying Huang):
   potentially cleaner conceptually and seems to work without a
   userspace daemon, but apparently not documented anywhere
   except in the source files drivers/input/serio/serport.c
   and linux/drivers/input/mouse/sermouse.c

Now it's your turn to decide.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig04B0724A189B80F4DE3EF3C7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGWwvJMdB4Whm86/kRAhRIAJ4mgeu7J/BCv/lejUPFcq54rIMMTACdEno/
ma7zFiINN9U0FFIHFoqYi5Q=
=hJT1
-----END PGP SIGNATURE-----

--------------enig04B0724A189B80F4DE3EF3C7--
