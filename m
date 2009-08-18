Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbZHRRa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbZHRRa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758720AbZHRRa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:30:57 -0400
Received: from mailout08.t-online.de ([194.25.134.20]:33593 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbZHRRa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:30:56 -0400
Message-ID: <4A8AE52F.6030606@t-online.de>
Date: Tue, 18 Aug 2009 19:30:23 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090623)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: =?ISO-8859-2?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>
Subject: Re: [Bug #13374] reiserfs blocked for more than 120secs
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera> <200908032113.46588.rjw@sisk.pl> <4A83296E.6010700@t-online.de> <200908122315.09420.rjw@sisk.pl>
In-Reply-To: <200908122315.09420.rjw@sisk.pl>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8C516E9575354B07B888A04A"
X-ID: EY4PgoZGrhvPqCiNJKbZO-aT3I1onvmyj7jlKaQK7esid9+R1+sKoT60NDF6ETCZai
X-TOI-MSGID: 2d970e91-619c-4822-af04-dfbf9ffa2df7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8C516E9575354B07B888A04A
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

I haven't seen the 120secs timeout yet, but using 2.6.31-rc5 there _are_
some delays that I am not sure of. Sometimes it takes about 30 secs till
the XWindow server comes up, for example. (I use xinit on the command lin=
e
at login. / and /home are both reiserfs.) For 2.6.30.4 and older I haven'=
t
seen this delay yet, AFAIR.

Most recent event: I tried to format a 4 GByte USB stick with reiserfs.
Here is the screen output:

	# device=3D/dev/sdf
	# parted $device mklabel gpt
	Warning: The existing disk label on /dev/sdf will be destroyed and
	all data on this disk will be lost. Do you want to continue?
	Yes/No? Yes
	Information: You may need to update /etc/fstab.

	# parted -- $device mkpart primary 0s -1s
	Warning: You requested a partition from 0.00B to 4127MB.
	The closest location we can manage is 17.4kB to 4127MB.
	Is this still acceptable to you?
	Yes/No? Yes
	Information: You may need to update /etc/fstab.

	# mkreiserfs -l usbstick /dev/sdf1
	mkreiserfs 3.6.21 (2009 www.namesys.com)
	:
	:
	UUID: 154d66cc-02ac-4979-9a39-163e3cf80623
	LABEL: usbstick
	ATTENTION: YOU SHOULD REBOOT AFTER FDISK!
	        ALL DATA WILL BE LOST ON '/dev/sdf1'!
	Continue (y/n):y
	Initializing journal - 0%....20%....40%....60%....80%....100%
	Syncing..ok
	ReiserFS is successfully created on /dev/sdf1.

It took about 2 to 3 minutes till the "ok" in the "Syncing" line
was shown. /var/log/messages was silent. When I tried to reproduce
the delay it was gone, of course.

Since I would like to try 2.6.31-rc6 anyway, maybe you could post
some hints about what debugging options to set in the config file?


Many thanx

Harri



--------------enig8C516E9575354B07B888A04A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqK5TQACgkQUTlbRTxpHjeHNgCdG+RVIBC34nz8ePvFFlONBMVp
l1MAn3phSPnUpJT3E+ivFynqXJwpEAZq
=2D/U
-----END PGP SIGNATURE-----

--------------enig8C516E9575354B07B888A04A--
