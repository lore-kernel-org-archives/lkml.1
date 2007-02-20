Return-Path: <linux-kernel-owner+w=401wt.eu-S1161048AbXBTWqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161048AbXBTWqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161043AbXBTWqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:46:53 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:39730 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161041AbXBTWqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:46:51 -0500
X-Sasl-enc: 3w+Nyk30+uhqkBXV4B0CbNVFCWxDrb2L0vQs6uwvtsnk 1172011677
Message-ID: <45DB7AA2.4010804@imap.cc>
Date: Tue, 20 Feb 2007 23:48:02 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm2: possible recursive locking detected (reiserfs-related)
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <200702202223.54046.rjw@sisk.pl>
In-Reply-To: <200702202223.54046.rjw@sisk.pl>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig014AC67E3EF4E11EC663BF46"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig014AC67E3EF4E11EC663BF46
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 20.02.2007 22:23 schrieb Rafael J. Wysocki:
> Looks like reiserfs has some locking problems:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ INFO: possible recursive locking detected ]
> 2.6.20-mm2 #6
> ---------------------------------------------
> beagled/4786 is trying to acquire lock:
>  (&inode->i_mutex){--..}, at: [<ffffffff80479df9>] mutex_lock+0x19/0x20=

>=20
> but task is already holding lock:
>  (&inode->i_mutex){--..}, at: [<ffffffff80479df9>] mutex_lock+0x19/0x20=

>=20
> other info that might help us debug this:
> 3 locks held by beagled/4786:
>  #0:  (&inode->i_mutex){--..}, at: [<ffffffff80479df9>] mutex_lock+0x19=
/0x20
>  #1:  (&REISERFS_I(inode)->xattr_sem){----}, at: [<ffffffff80304c99>] r=
eiserfs_setxattr+0x79/0x150
>  #2:  (&REISERFS_SB(s)->xattr_dir_sem){----}, at: [<ffffffff80304cc0>] =
reiserfs_setxattr+0xa0/0x150

This looks like the same I have been seeing in every release
since 2.6.18. I reported it a couple of times, and Srinivasa Ds
tried a few fixes on me during 2.6.19-rc4, but we never got to
the bottom of it.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig014AC67E3EF4E11EC663BF46
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF23qiMdB4Whm86/kRAn6YAJ9RtV41xX4V5ONFQVwNT6vrYoYKEwCeOeZC
T88Ch6N/r053H0p1jZdXJws=
=HG/h
-----END PGP SIGNATURE-----

--------------enig014AC67E3EF4E11EC663BF46--
