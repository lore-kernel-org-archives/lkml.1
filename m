Return-Path: <linux-kernel-owner+w=401wt.eu-S933395AbXFEVid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbXFEVid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932215AbXFEViX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:38:23 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56082 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758706AbXFEViW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:38:22 -0400
X-Sasl-enc: eBTZS21BNpKP3fHGRu+xHjoQoE8MuGJEnGE8IWl2ni+b 1181079500
Message-ID: <4665D89E.8080408@imap.cc>
Date: Tue, 05 Jun 2007 23:41:50 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: "Lars K.W. Gohlke" <lkwg82@gmx.de>
CC: huang ying <huang.ying.caritas@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de>	 <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr>	 <4648E9F7.5090908@imap.cc> <851fc09e0705162315w3380ddabh9b9f0b2198cb8457@mail.gmail.com> <465366CB.7090608@imap.cc> <46632489.9070107@gmx.de>
In-Reply-To: <46632489.9070107@gmx.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6C503B6224696C9D49BA7D9D"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6C503B6224696C9D49BA7D9D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 03.06.2007 22:28 schrieb Lars K.W. Gohlke:
> Tilman Schmidt schrieb:
>> Am 17.05.2007 08:15 schrieb huang ying:
>>> I think the "serio" (through drivers/input/serio/serport.c) may be a
>>> choice too, like that in linux/drivers/input/mouse/sermouse.c, which
>>> is an example to program serial port in kernel space.
>> Interesting. I wonder if that would have been a better choice for
>> the Gigaset M101 driver. It seems even to have a probe mechanism
>> so one could try to determine if the expected device is really
>> connected to the port.
>=20
>> Is there any documentation on this interface? I find the source a
>> bit hard to understand, sparsely commented as it is.
>=20
> how can I open ttyS1 with major=3D4 and minor=3D65?

a) With "my" approach, ie. writing a line discipline, you open
/dev/ttyS1 in a user space program and then push your line discipline
onto it using ioctl(,TIOCSETD,).

b) With the "serio" approach, if the probe mechanism is really what
I think it is, you register your probe function and wait for it to
be called for each active serial port, then do your thing to determine
whether this is a/the port you want to use.

> Does anybody have some code to read from it the first e.g. 2bytes?

That's not how things work in the kernel. You don't "read the first
<n> bytes" at will. You have to provide means to process whatever
data happens to arrive on the serial port, as it arrives.

a) With a line discipline, you provide a callback function
".receive_buf" which will be called by the serial driver if some
data has been received, and has to process that data then and there.
You might just stow it away in a buffer of course, provided you
are sure to get around to processing it later.

b) With the "serio" interface, it seems the ".interrupt" function
serves the same purpose - though, as I said, I am not really
competent on that topic.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enig6C503B6224696C9D49BA7D9D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGZdinMdB4Whm86/kRAgSFAJ4xOZmmSq8z5JvqAhskXxwm3IpsnwCeIAap
Uhv3qAsO0mGxBy7Ljl8XDr0=
=0La8
-----END PGP SIGNATURE-----

--------------enig6C503B6224696C9D49BA7D9D--
