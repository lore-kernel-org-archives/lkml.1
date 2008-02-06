Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbYBFRwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbYBFRwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbYBFRwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:52:31 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:41856 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYBFRwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:52:30 -0500
Message-ID: <47A9F3D7.5000903@web.de>
Date: Wed, 06 Feb 2008 18:52:23 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Jason Wessel <jason.wessel@windriver.com>,
       kgdb-bugreport@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Kgdb-bugreport] [PATCH 4/5] KGDB-8250: refactor configuration
References: <479FBAE8.3070809@web.de> <479FC57D.5030104@web.de> <47A325BC.6030305@ru.mvista.com> <47A38AD9.1060305@web.de> <47A9B340.2020603@ru.mvista.com>
In-Reply-To: <47A9B340.2020603@ru.mvista.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig02A0C13BF170C9A397D835C6"
X-Provags-ID: V01U2FsdGVkX1/Dj/48KqUEIodhgBvJmh87aGfp2R7+YwKlAEgy
	9JsBu+Ae+mwn+jrlMykiGYx9e2MouRd/CbgYxobGLcS1QNVVKV
	X+ID9SVno=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig02A0C13BF170C9A397D835C6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Sergei Shtylyov wrote:
>>>   You left powerpc-lite.patch broken with this change as it has
>>> multiple calls to kgdb8250_add_port()...
>=20
>> I see. But I wonder if there ever was a real need for these hooks (in
>> 2.4 times?): If I look at bamboo_early_serial_map() e.g., I find it
>> calling into early_serial_setup() which fills serial8250_ports[] - and=

>> that content is now retrieved via serial8250_get_port_def() when we
>> parse the runtime or build-time provided parameters (port number &
>> baudrate).
>=20
>    Of course. But now the kgdb8250_add_port() calls need to be removed.=


For sure. Most arch patches need to go through some refactoring anyway
when preparing them for upstream. Cleaning up no longer required hooks
should be no problem at this chance.

If you want to accelerate this process, please check out Jason's
linux-2.6-kgdb.git for 2.6.25 and start rebasing the powerpc patch. He
just recently said that support around kgdb for non-x86 would be highly
welcome. And if you stumble over ppc-related issues that cannot be
solved with latest kgdb design, please let us know. The sooner, the bette=
r.

Jan


--------------enig02A0C13BF170C9A397D835C6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHqfPcniDOoMHTA+kRAlDaAJ9jpKM9ePo6JV9K6Lp55Lvdpq9I1ACggJeD
RZ8UOaLv+G8cHEWg2kZJ4yw=
=b3S2
-----END PGP SIGNATURE-----

--------------enig02A0C13BF170C9A397D835C6--
