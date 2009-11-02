Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbZKBKki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbZKBKki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbZKBKkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:40:37 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41861 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754246AbZKBKkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:40:36 -0500
X-Sasl-enc: Vy+TOoOEN0/uYuY8Xgmjc2u2pyOa+KsU1quIuRNKxVpP 1257158440
Message-ID: <4AEEB71B.2070502@imap.cc>
Date: Mon, 02 Nov 2009 11:40:27 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Thiago Farina <tfransosi@gmail.com>
CC: Randy Dunlap <rdunlap@xenotime.net>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       =?UTF-8?B?QW5kcsOpIEdvZGRhcmQgUm9zYQ==?= <andre.goddard@gmail.com>,
       trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Subject: ARRAY_SIZE (was: [PATCH 03/16] trivial: fix assorted "through" typos)
References: <b8bf37780910310240u4aecdf89hb938df7952b572e@mail.gmail.com>	 <4AEC0EBE.2040308@crca.org.au> <4AEC2971.8050105@imap.cc>	 <20091101095208.10d57e8f.rdunlap@xenotime.net> <a4c8a6d00911011313k39a6805dr590967cc8fc3a204@mail.gmail.com>
In-Reply-To: <a4c8a6d00911011313k39a6805dr590967cc8fc3a204@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0D98CA65E68EA5D890A8E0F9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0D98CA65E68EA5D890A8E0F9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 01.11.2009 22:13 schrieb Thiago Farina:
>=20
> Talking about cleanup, there are many definitions of ARRAY_SIZE, found
> using cscope:
> 0 spidev_test.c  24 #define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
> 1 page-types.c  194 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> 2 types.h         4 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> 3 user.h         17 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> 4 boot.h         35 #define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
> 5 relocs.c       13 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> 6 kernel.h       46 #define ARRAY_SIZE(arr) (sizeof(arr) /
> sizeof((arr)[0]) + __must_be_array(arr))
> 7 dtc.h          83 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> 8 genksyms.c    314 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)=
[0]))
> 9 kallsyms.c     27 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0=
]))
> a file2alias.c  520 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> b util.h         28 #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))

You should have included the files' directory paths. That would have
shown that seven of these aren't in actual kernel source files at all:
two in the Documentation tree, four in scripts, and one in tools.
Four are in the arch tree, and are needed for boot or userspace code.
There only remains one: the definition in include/linux/kernel.h which
is the "official" one for regular kernel code.

Now the number of places which could use that macro but open-code it
instead is a completely different story. See
http://www.crashcourse.ca/wiki/index.php/The_style_script
for a list of candidates.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enig0D98CA65E68EA5D890A8E0F9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFK7rcmQ3+did9BuFsRAmCKAJ0c1mZ3EygHNlDVtP4OmRAnsxY7WQCfcNK3
XYlpH6RlyYcEzvxYl0OnpxA=
=FMFh
-----END PGP SIGNATURE-----

--------------enig0D98CA65E68EA5D890A8E0F9--
