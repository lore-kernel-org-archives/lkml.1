Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbYBSI6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbYBSI6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYBSI6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:58:02 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:3901 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYBSI6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:58:00 -0500
Message-ID: <47BA99B6.5010005@imap.cc>
Date: Tue, 19 Feb 2008 09:56:22 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alasdair G Kergon <agk@redhat.com>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Tilman Schmidt <tilman@imap.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "Alexey Dobriyan" <adobriyan@gmail.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Linux 2.6.25-rc2 regression: LVM cannot find volume group
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <47B73616.9050303@imap.cc> <20080216201206.1452cfe7@core> <47B765B1.1030709@gmail.com> <20080219015344.GA4066@agk.fab.redhat.com>
In-Reply-To: <20080219015344.GA4066@agk.fab.redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2C205F00F0D4812043079FDE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2C205F00F0D4812043079FDE
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

[added CCs from the other thread on this topic]

Alasdair G Kergon schrieb:
> On Sat, Feb 16, 2008 at 11:37:37PM +0100, Jiri Slaby wrote:
>> # CONFIG_SYSFS_DEPRECATED is not set
>=20
> IMHO That should be *set* by default until everyone has had time to
> update their userspace software to cope with the changed sysfs layout.

It *is* set by default.

The root cause of the trouble is that its semantics are changing.
At one point in time (sorry, don't remember which kernel release
exactly) I tested whether the openSUSE 10.3 userspace supported
a CONFIG_SYSFS_DEPRECATED=3Dn kernel and found that it did. From
then on, "make oldconfig" would carry that setting over to every
new kernel I built, which was fine while the meaning of this
setting - ie. the difference in sysfs layout it controlled -
stayed the same.

With commit edfaa7c36574f1bf09c65ad602412db9da5f96bf however, the
sysfs layout changed again, so the same CONFIG_SYSFS_DEPRECATED
setting now controls a different difference (argh) in sysfs
layout. That kind of situation is not handled very well by
"make oldconfig", which basically starts from the assumption
that a setting that was ok for the previous kernel version is
still ok for the new one.

I see two ways of avoiding that problem: either create a new
backward compatibility config setting for that new sysfs change,
or create a way of telling "make oldconfig" that the semantics of
CONFIG_SYSFS_DEPRECATED have changed and it should ask the user
for that again even if there is a previous setting.

HTH
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig2C205F00F0D4812043079FDE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHupnBQ3+did9BuFsRAn5QAJ4+mWgVuZ9EZVA4nrx+OmxEbz/e/wCcDkiT
4ToefVL3P0C6nBLB1+wkGRo=
=6ws6
-----END PGP SIGNATURE-----

--------------enig2C205F00F0D4812043079FDE--
