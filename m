Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbZJ1NgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbZJ1NgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 09:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbZJ1NgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 09:36:03 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47602 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbZJ1NgC (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Wed, 28 Oct 2009 09:36:02 -0400
Message-ID: <4AE848BC.6020202@novell.com>
Date: Wed, 28 Oct 2009 09:35:56 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [patch] Re: Zillions of warnings in -next
References: <20091027152530.75ca60e4@lxorguk.ukuu.org.uk>	<4AE7258D0200005A000576F6@sinclair.provo.novell.com>	<20091027222112.74058162@lxorguk.ukuu.org.uk> <20091027153651.6d636fe8.randy.dunlap@oracle.com>
In-Reply-To: <20091027153651.6d636fe8.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0840A36F06C503A34D49A782"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0840A36F06C503A34D49A782
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Randy Dunlap wrote:
> On Tue, 27 Oct 2009 22:21:12 +0000 Alan Cox wrote:
>=20
>>> I just did a 32-bit build and indeed reproduced the warnings.  Howeve=
r, the warnings
>>> appear to be dubious as the code is properly (afaict) annotated with =
explicit casts, and
>>> I believe they are doing what I intended.
>>>
>>> Basically I have structures that are always 64 bit (so we can have a =
mixed-mode 32-bit
>>> guest talk to a 64-bit hypervisor, for instance).  Therefore I am cas=
ting between native
>>> and u64, but the compiler doesn't like this.  Does anyone have any su=
ggestions on ways
>>> to fix this so the compiler is happy?
>> 	foo =3D (void *)(unsigned long)x
>>
>> works for the general case because Linux assumes ptr fits ulong
>>
>> Similarly in the other direction.

Thank you, Alan.  Your tip was spot on.

>=20
> Yes, I already had this done for venet and pci-bridge.  Patch below.
>=20
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Eliminate all cast warnings in vbus-enet.c and pci-bridge.c.
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Thank you, Randy.  Applied.

Kind Regards,
-Greg



--------------enig0840A36F06C503A34D49A782
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkroSLwACgkQP5K2CMvXmqG9DACeMDiVfLZN8GqhGkbgno1iLdfY
kakAnjsLCFlOEWOY1F+ejGVDb0itlGpC
=kRqq
-----END PGP SIGNATURE-----

--------------enig0840A36F06C503A34D49A782--
