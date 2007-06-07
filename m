Return-Path: <linux-kernel-owner+w=401wt.eu-S933393AbXFGQKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393AbXFGQKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbXFGQKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:10:30 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53347 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbXFGQK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:10:29 -0400
X-Sasl-enc: w6jqglwiYkmeU8Uc4YxDogRWncblY+meU1+kCUso+W8Y 1181232626
Message-ID: <46682E93.1020602@imap.cc>
Date: Thu, 07 Jun 2007 18:13:07 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: serio interface
References: <46667A3B.8070708@gmx.de> <20070606091503.GI2649@lug-owl.de> <46667FB9.70206@gmx.de> <20070606095159.GK2649@lug-owl.de>
In-Reply-To: <20070606095159.GK2649@lug-owl.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEDF13BCD783FC226E4DD8641"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEDF13BCD783FC226E4DD8641
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 06.06.2007 11:51 schrieb Jan-Benedict Glaw:
> On Wed, 2007-06-06 11:34:49 +0200, Lars K.W. Gohlke <lkwg82@gmx.de> wro=
te:

>> I want on the kernelside process data from first uart-hardware interfa=
ce
>> aka ttyS0.
>>
>> I don't understand the structure of e.g. input/mouse/sermouse.c
>>
>> where is said, which hardware is used for reading data from?
>=20
> I'm not entirely sure, but I guess that most of the time, you assign a
> serial port with the help of `inputattach' to a given device driver,
> which expects to find its hardware on that port.
>=20
> OTOH, why do you want to do the serial stuff in kernel land? Isn't it
> a *lot* easier to do it in userspace? What's your specific device you
> want to work on?

May I chime in here, as it's a topic I am interested in too.

Have a look at drivers/isdn/gigaset/ser-gigaset.c if you like,
a driver for an ISDN adapter attached via RS232.

This is currently implemented as a line discipline, but I consider
that a hack. For one thing, it doesn't really fit the concept of a
line discipline because it doesn't transform the serial datastream
but instead diverts it completely to the isdn4linux subsystem. And
second, it means that a userspace daemon is needed which does
nothing but open the serial port, set the line discipline on it,
and go to sleep in order to keep the line discipline loaded.

The serio approach used by input/mouse/sermouse.c might provide a
more sensible way of driving that kind of device.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigEDF13BCD783FC226E4DD8641
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGaC7QMdB4Whm86/kRAiZgAJ9eRGY0Cptm/r3Ke+KVdqqCF8EzHACeIIlZ
fbDGiVdO6Rv04nquhhraMAo=
=/xCM
-----END PGP SIGNATURE-----

--------------enigEDF13BCD783FC226E4DD8641--
