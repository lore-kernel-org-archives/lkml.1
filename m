Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841Ab0AWOt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab0AWOt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 09:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747Ab0AWOtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 09:49:53 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:58649 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab0AWOtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 09:49:52 -0500
Message-ID: <4B5B0C8A.7090603@web.de>
Date: Sat, 23 Jan 2010 15:49:46 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: isdn@linux-pingi.de, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       i4ldeveloper@listserv.isdn4linux.de, isdn4linux@listserv.isdn4linux.de,
       netdev@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 31/31] CAPI: Officially claim char major 191
References: <cover.1264201406.git.jan.kiszka@web.de>	 <20100123122430.5a078b4a@lxorguk.ukuu.org.uk>	 <1264250892.3469.52.camel@violet>  <201001231432.09918.isdn@linux-pingi.de> <1264256908.3469.58.camel@violet>
In-Reply-To: <1264256908.3469.58.camel@violet>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigADE235F96C9AA14D4A6B8704"
X-Provags-ID: V01U2FsdGVkX1/n6PFodOlKmKRjDtIMmvKMLaNMtQwAhYHQlR69
	KsFHEwS/MbQ/yE9Z2aCJeiVtLCZ2nbRy3R/tbwVPWhbHZ1tGOZ
	uMWhXXKVg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigADE235F96C9AA14D4A6B8704
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Marcel Holtmann wrote:
> Hi Karsten,
>=20
>>>>> I found no trace of this mysterious "pcl181" device, neither in-tre=
e
>>>>> nor out there in the wild. At the same time, the in-tree CAPI
>>>>> middleware is using major 191 for many years now and obviously with=
out
>>>>> any conflict. Let's officially claim this major number.
>>>> This is not the way it should have been done but whoever needs spank=
ing
>>>> got away with it years ago. Given that this seems the best way forwa=
rd.
>>>>
>>>> With LANANA hat on
>>> actually in the days of udev, the capifs is not really needed anymore=
=2E
>>> The right choice would be to remove it. I haven't been enabling it si=
nce
>>> years.
>>>
>> So far I understand, the pppd capiplugin is the only user of it, so it=
 could=20
>> be disabled for most users without any problems, as long they are not =
using
>> PPP connections via CAPI.
>=20
> PPP connection via CAPI works just fine without capifs. You just need
> udev to create the device nodes.
>=20
>> I never understand capifs very well, I think that it can be dropped be=
cause of=20
>> udev, but maybe need some adjustment in user space as well (make sure =
that
>> udev did create the node before  open it).
>=20
> I am pretty sure that I send a patch for that a long long time ago. I
> haven been using CAPI + PPP without capifs.
>=20
>> I f I remember correctly, here was some proposal  to replace the /dev/=
capi/=20
>> nodes with  devpts, this would remove the complete capi_tty device maj=
or
>> as well.
>=20
> Don't remember anything like this. However extending the kernel code
> with a CAPI PPP channel type would be better actually.

Not sure how much of pppdcapiplugin would have to be moved into the
kernel then, but if it allows us to even drop that thing, it might be
worth it.

In any case, I think we first need a solution for existing user space.
So if pppdcapiplugin can be safely considered the only user of
/dev/capi/*, I will rework my series to use a dynamic major and will
file a patch to first deprecate and then remove capifs. What would be a
reasonable warning period? Something like 3 kernel releases?

Jan


--------------enigADE235F96C9AA14D4A6B8704
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAktbDI4ACgkQitSsb3rl5xRIXwCgsZtRjhq2zCohGg0y90nv4NEy
t5QAoIJMEM6RmSHz+2B+ZQYM8FA50swO
=Ha6D
-----END PGP SIGNATURE-----

--------------enigADE235F96C9AA14D4A6B8704--
