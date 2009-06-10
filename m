Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbZFJQmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbZFJQmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 12:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZFJQmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 12:42:36 -0400
Received: from mailout01.t-online.de ([194.25.134.80]:45597 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbZFJQmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 12:42:35 -0400
Message-ID: <4A2FE268.60505@t-online.de>
Date: Wed, 10 Jun 2009 18:42:16 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: how to stop kernel nfsd?
References: <1MDcTI-1elcES0@fwd00.aul.t-online.de> <alpine.DEB.2.01.0906091907340.6439@bogon>
In-Reply-To: <alpine.DEB.2.01.0906091907340.6439@bogon>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB64D28201FCD4B4E2526622F"
X-ID: T5Pcw-ZTgh-TYmZv0u2VjfqSt-Bj6nFc1MMYlROkGOPkbRU1hQbjY5IFxllD9v2gBQ
X-TOI-MSGID: 2d10e458-d723-491c-9320-dd59205caa26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB64D28201FCD4B4E2526622F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Christian Kujau wrote:
> On Mon, 8 Jun 2009, harald.dunkel@t-online.de wrote:
>> Which signal would be correct to gracefully kill the kernel nfs daemon=
s?
>=20
> What are you trying to achieve? "killing", "terminating" or "graceful=20
> reloading", as in "re-exporting the shares", which can be done with=20
> exportfs(8).
>=20

Its a HA setup. Heartbeat is supposed to terminate the nfs service, umoun=
t
the local filesystem, set the drbd resources to "secondary", and release
the shared IP address (in this sequence).

To terminate the nfs service Lenny's /etc/init.d/nfs-kernel-server tries

	kill -INT <pid>

for all nfs daemons. Even though nfs is not active the nfs daemons don't
go away and keep the local mount point busy. If I patch the nfs runlevel
script to use SIGQUIT or SIGHUP instead, then the nfs daemons terminate.

Lenny's kernel is 2.6.26 plus patches.

Surely I am not asking for support for Lenny's kernel. But it would be
interesting to know what the kernel nfs daemons are supposed to do when
they receive a signal. AFAICS this is not documented.


Regards

Harri



--------------enigB64D28201FCD4B4E2526622F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkov4m0ACgkQUTlbRTxpHjdQSACfWpCez2bkYrpnzJ3XuxeIgnud
AWAAoIRpQMALRCuh3JhruE3MBnr+99ii
=Jr6Y
-----END PGP SIGNATURE-----

--------------enigB64D28201FCD4B4E2526622F--
