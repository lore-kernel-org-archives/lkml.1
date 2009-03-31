Return-Path: <linux-kernel-owner+w=401wt.eu-S1762602AbZCaQwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762602AbZCaQwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbZCaQwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:52:08 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:2318 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557AbZCaQwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:52:07 -0400
Message-ID: <49D24A32.9070103@imap.cc>
Date: Tue, 31 Mar 2009 18:52:02 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14 Mnenhy/0.7.6.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Help: tasklet blocked for >8msec - USB mouse related
References: <49CCFEBA.6060009@imap.cc>
In-Reply-To: <49CCFEBA.6060009@imap.cc>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1F334CF453A41779523BD4F9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1F334CF453A41779523BD4F9
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

/me wrote:
> A user of the Gigaset base driver (drivers/isdn/gigaset/bas-gigaset.c)
> reports his connection being dropped exactly every 30 seconds.
> Analysis of his dmesg indicates that when the error occurs, both the
> tasklets read_iso_tasklet and write_iso_tasklet handling the B channel
> data stream (125 USB isochronous packets per second in each direction)
> are at the same time not executed for an entire inter-packet interval,
> ie. 8 msecs.

The user did a bit of ellimination work, and it turned out that if
he disconnected his Logitech Laser Mouse from its USB port and
connected it to the PS2 port instead, the regular blockages ceased.

So we have a workaround, but no explanation.

This is on Debian Lenny with a 2.6.26 kernel. The user claims newer
kernels don't boot on his machine. Btw, he also reports that the
ISDN connection breaks each time he hotplugs any USB device, but
so far has failed to produce a syslog excerpt for that. (sigh)
The Motherboard is a Gigabyte GA-EP45T-EXTREME, advertised as
"Designed for overclocking enthusiasts with overwhelming
overclocking experience", which lets me fear the worst ...


--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig1F334CF453A41779523BD4F9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJ0koyQ3+did9BuFsRAtYcAJ9dESOhwmZjpVxHY8ZgSWgKQRpkJQCgjnnd
1O+rbXFMuDWoS/QXCBDJRWs=
=RfEc
-----END PGP SIGNATURE-----

--------------enig1F334CF453A41779523BD4F9--
