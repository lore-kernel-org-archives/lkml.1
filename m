Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbXEJNrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbXEJNrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbXEJNqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:46:53 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:49956 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbXEJNqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:46:53 -0400
Message-ID: <46432212.9070008@drzeus.cx>
Date: Thu, 10 May 2007 15:45:54 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-1324-1178804805-0001-2"
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Flush mmc workqueue late in the boot sequence
References: <117879333788-git-send-email-hskinnemoen@atmel.com>	<46430A49.9090803@drzeus.cx> <20070510143737.54969394@dhcp-252-105.norway.atmel.com>
In-Reply-To: <20070510143737.54969394@dhcp-252-105.norway.atmel.com>
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-1324-1178804805-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Haavard Skinnemoen wrote:
>=20
> What exactly makes this unreliable? This is done almost exactly the
> same way for SCSI. See drivers/scsi/scsi_wait_scan.c.
>=20

I am not against the function of waiting for an initial scan, what I oppo=
se is
using side effects to achieve that function. I do not want to take
responsibility for something that easily breaks because we use a kernel
subsystem for something it wasn't meant for.

That said, if there is a precedent for achieving this function a certain =
way, I
might be convinced to let it in. I'll have a look at that scsi example.

>=20
> I don't know about USB, but root=3D/dev/mmcblk0p1 used to work before
> 2.6.20 and it doesn't work anymore. Doesn't that make this a regression=
?
>=20

Yes and no. It depends on if it was an official function, or just an effe=
ct of
how things currently were implemented. As far as I can see, it's the latt=
er. The
MMC layer goes through several steps that could very well get delayed or =
happen
in parallel. So the fact that it happened to work the way you wanted it t=
o was
sheer luck.

Rgds
Pierre



--=_hera.drzeus.cx-1324-1178804805-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGQyIX7b8eESbyJLgRAmrFAKDpBCD/ttT/gBUO0n4bHy8zSLYv3ACeIjYI
TWFT5uNvUDUl3PpwcnENM7g=
=V/2a
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-1324-1178804805-0001-2--
