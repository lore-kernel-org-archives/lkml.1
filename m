Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbZC3UUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbZC3UUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760872AbZC3UU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:20:29 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:34636 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760936AbZC3UU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:20:27 -0400
MIME-version: 1.0
X-IronPort-AV: E=Sophos;i="4.38,448,1233529200";   d="asc'?scan'208";a="3250650"
Message-id: <49D12986.6060206@archlinux.org>
Date: Mon, 30 Mar 2009 22:20:22 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
To: Alexander Clouter <alex@digriz.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fastboot/async and initramfs: How am I supposed to know
 when?devices are finished initializing?
References: <49CF9BA1.5030400@archlinux.org>
 <20090329091148.16a618bf@infradead.org> <49CFA436.5080000@archlinux.org>
 <ac3eb2510903291036w13dc34cbi97525e6dd9af1da5@mail.gmail.com>
 <49CFB553.1020800@archlinux.org> <mp05a6-inv.ln1@woodchuck.wormnet.eu>
In-reply-to: <mp05a6-inv.ln1@woodchuck.wormnet.eu>
X-Enigmail-Version: 0.95.6
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enigD091016C4BCE7BFE66DB87E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD091016C4BCE7BFE66DB87E8
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Alexander Clouter schrieb:
> If the user is specifying the boot device, could you not 'teach' them t=
o=20
> LABEL the boot device and live off something slightly more fancy (but=20
> akin to) the following:
>=20
> ----
> while true
> do
>   mount LABEL=3Droot /whatever
>=20
>   if [ $? -eq 0 ]; then
>     break
>   fi
>=20
>   # do some md and lvm magic dance here
>=20
>   sleep 1
> done
> ----
>=20
> Your initramfs could do extra steps everytime the loop...erm...loops.
>=20
> Now of course the downside is LABELing mounted devices, XFS for example=
,=20
> is not an easy thing to do... :-/

We do use UUIDs (or LABELs), but that doesn't solve the LVM problem,=20
because the given device "/dev/somevg/somelv" only appears after LVM has =

been activated! I am thinking about using udev scan for LVM volume=20
groups each time a hard drive appear that contains an LVM device. But=20
that is a topic for another place.


--------------enigD091016C4BCE7BFE66DB87E8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAknRKYYACgkQEda5KzHP/VB6kwCfeGgA3mOw2hgtLXwWR+RcUCf8
v6oAnir20AVwHHNmzA6tZAtsa72wNwqf
=ofg+
-----END PGP SIGNATURE-----

--------------enigD091016C4BCE7BFE66DB87E8--
