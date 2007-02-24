Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbXBXPTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbXBXPTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 10:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933007AbXBXPTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 10:19:31 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:52123 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932911AbXBXPTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 10:19:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=arlott.org;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:OpenPGP:Content-Type;
	b=YqrJltxzIpMUtmyz1J1QZIK2p81f+Pafnezqfj85wUJfJjYAeBDE39eBPHL25tW/YlqLRmroURnplRaHrku+QsYyThoV5N0q+QxaOTAyz2PHdtszHcjT++ebiVvFbedK;
Message-ID: <45E0577C.9020409@simon.arlott.org.uk>
Date: Sat, 24 Feb 2007 15:19:24 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: round_jiffies and load average
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig060245FB56C06C2B3F4E9F80"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig060245FB56C06C2B3F4E9F80
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I've modified the driver of an USB device (cxacru) to schedule the next p=
oll for status every 1s using round_jiffies_relative instead of just wait=
ing 1s since the last poll was completed. This process takes on average 1=
1ms to complete and while it is waiting for a response it's considered ru=
nning.

The load average is calculated every 5 seconds equivalent to round_jiffie=
s, so I have a problem with the load average always tending towards 1.00:=


 14:26:19 up 6 days, 14:45,  5 users,  load average: 1.10, 1.04, 1.02
 14:27:19 up 6 days, 14:46,  5 users,  load average: 1.03, 1.03, 1.01
 14:28:19 up 6 days, 14:47,  5 users,  load average: 0.95, 1.01, 1.00
 14:29:19 up 6 days, 14:48,  5 users,  load average: 0.90, 0.97, 0.99
 14:30:19 up 6 days, 14:49,  5 users,  load average: 0.93, 0.96, 0.98
 14:31:19 up 6 days, 14:50,  5 users,  load average: 0.90, 0.94, 0.97
 14:32:20 up 6 days, 14:51,  5 users,  load average: 0.96, 0.95, 0.97
 14:33:20 up 6 days, 14:52,  5 users,  load average: 0.98, 0.95, 0.97
 14:34:20 up 6 days, 14:53,  5 users,  load average: 1.09, 0.99, 0.98
 14:35:20 up 6 days, 14:54,  5 users,  load average: 1.03, 0.99, 0.98
 14:36:20 up 6 days, 14:55,  5 users,  load average: 1.01, 0.99, 0.98
 14:37:20 up 6 days, 14:56,  5 users,  load average: 1.00, 0.99, 0.98
 14:38:21 up 6 days, 14:57,  5 users,  load average: 1.22, 1.05, 1.00
 14:39:21 up 6 days, 14:58,  5 users,  load average: 1.08, 1.04, 1.00
 14:40:21 up 6 days, 14:59,  5 users,  load average: 1.03, 1.03, 1.00
 14:41:21 up 6 days, 15:00,  5 users,  load average: 0.95, 1.01, 0.99
 14:42:21 up 6 days, 15:01,  5 users,  load average: 0.90, 0.97, 0.98
 14:43:21 up 6 days, 15:02,  5 users,  load average: 0.99, 0.99, 0.99
 14:44:22 up 6 days, 15:03,  5 users,  load average: 0.86, 0.94, 0.97
 14:45:22 up 6 days, 15:04,  5 users,  load average: 0.97, 0.95, 0.97
 14:46:22 up 6 days, 15:05,  5 users,  load average: 1.08, 0.99, 0.98
 14:47:22 up 6 days, 15:06,  5 users,  load average: 1.03, 0.99, 0.98
 14:48:22 up 6 days, 15:07,  5 users,  load average: 1.32, 1.07, 1.01

Perhaps the load average count could be run just before or in the middle =
of a second instead?

--=20
Simon Arlott


--------------enig060245FB56C06C2B3F4E9F80
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBReBXf6Rtx1WjQ8ihAQpYpA//X1rV1a3c/zZXc+bUr3ykExEdo9bpNac0
MD2uDBcvmCkwhLCQHHUUtlMNDU5KjrefnFEc/oE5G6qB9G6kuD0KZBwMU6/ioxof
fgjxk8pAveJmSAQmtHGz9P1oNJPvh80/Jh8th48I26aQbeKOPUdxLxeF6h+x/ii8
NQ22etriDduQjYDrpF7eSSgfbZw4YAXmkSuc6nkg8i9TzfIuY1EbIE//nyLBHt2A
NuIh4vWOhZRQTePbVWE3LCwh39Z9KWYba0vPofCa0WdBaFgoJfzeR4LwI39+DVom
QH0fGR5wlzVjiPKaK85TV8JHFn/GpezPokIFbiP9NguH94EqoP2T5ME5C89frtfV
l5cNev5vcWehpw/XVGjnVHs3O/RKMNepr5XFO6DB1zQ3nc0w2+5mQQ7Me/Q5ZDFO
56tRfqenEElWGXQUFTKHgn9W3laA0CDwu4hcqzUXiN/N7/dLdx8r97JN7pNzF+mI
reSC6aHq9x3+BtS1L9ZifQRlCUF4dZMoE/aiNrcDjFXJwlF9jwFH+Iu8vDU62iCq
jzkwbSaHypqLK6WuU3uoYC8wzcSp9CEyyWhGN9KV6eaCpseJ0WHnwf5WS0+sVVQz
VMBfvv0R0St7kqD/qjAbHibWNLUcyxWFfud3M1ARihGxjA7e6CraCexAlNsSrRN9
popPaW6gT/k=
=zt4E
-----END PGP SIGNATURE-----

--------------enig060245FB56C06C2B3F4E9F80--
