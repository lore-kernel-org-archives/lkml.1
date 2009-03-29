Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbZC2QoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbZC2QoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZC2QjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:39:23 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:48231 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758688AbZC2QjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:39:22 -0400
MIME-version: 1.0
X-IronPort-AV: E=Sophos;i="4.38,442,1233529200";   d="asc'?scan'208";a="6430082"
Message-id: <49CFA436.5080000@archlinux.org>
Date: Sun, 29 Mar 2009 18:39:18 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
To: Arjan van de Ven <arjan@infradead.org>
Cc: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
       linux-kernel@vger.kernel.org
Subject: Re: fastboot/async and initramfs: How am I supposed to know when
 devices are finished initializing?
References: <49CF9BA1.5030400@archlinux.org>
 <20090329091148.16a618bf@infradead.org>
In-reply-to: <20090329091148.16a618bf@infradead.org>
X-Enigmail-Version: 0.95.6
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enig0CEB592EF2B5833454B860C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0CEB592EF2B5833454B860C7
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Arjan van de Ven schrieb:
>> Among other things, this loads the ata_piix on my machine. On older=20
>> kernels I could assume that after these commands, /dev/sda* existed
>=20
> not if you have CONFIG_SCSI_SCAN_ASYNC set though..
>=20
>> and I could immediately access them (in my case, I run cryptsetup on=20
>> /dev/sda6). But now, the devices don't exist here, but are only
>> created a second or so later. As a result, the initramfs script has
>> already bailed out as it couldn't find /dev/sda6 and assumed that the
>> hard drive didn't exist.
>=20
> the CONFIG_SCSI_WAIT_SCAN method (basically loading that module to wait=

> for the scans to finish) will work for you......

Thanks, I will integrate that into our initramfs. Will that also work=20
for USB mass storage (which was already problematic with older kernels,=20
you load the module you don't know how long it takes until the sdX=20
devices are created)?
Can I load that module before loading the actual SCSI/SATA/PATA driver?


--------------enig0CEB592EF2B5833454B860C7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAknPpDYACgkQEda5KzHP/VBjogCfRu8M0isfZZPBwk7jhrUuWxXK
5koAoLsQYNf7VreqLkRTFbGKww8ugI5r
=IqcK
-----END PGP SIGNATURE-----

--------------enig0CEB592EF2B5833454B860C7--
