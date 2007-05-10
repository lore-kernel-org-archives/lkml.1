Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbXEJMGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbXEJMGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758449AbXEJMG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:06:27 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:57875 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbXEJMG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:06:26 -0400
Message-ID: <46430A49.9090803@drzeus.cx>
Date: Thu, 10 May 2007 14:04:25 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-32320-1178798785-0001-2"
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Flush mmc workqueue late in the boot sequence
References: <117879333788-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <117879333788-git-send-email-hskinnemoen@atmel.com>
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-32320-1178798785-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Haavard Skinnemoen wrote:
> At some point before 2.6.20, the mmc subsystem moved the card
> detection code to its own workqueue. One consequence of this change
> is that when using an mmc card as a root device, the card may get
> detected after the init task attempts to mount the root filesystem,
> causing a kernel panic because the root device could not be opened.
>=20
> This patch adds a call to mmc_flush_scheduled_work() late in the boot
> sequence so that we can be sure the mmc card detection scans are
> complete before attempting to use an mmc device as a root device.
>=20
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

NAK. This is still hackish and not a reliable, controlled way of handling=
 the
issue of rootfs on removable media.

For reference, how is this handled in USB (which is conceptually identica=
l)? The
normal case for removable media is usually an initrd that can wait for ho=
tplug
events.

Rgds
Pierre


--=_hera.drzeus.cx-32320-1178798785-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGQwqQ7b8eESbyJLgRApMrAKCUF+pq36TZxxbJwqUckqUquBowHwCg8b4P
3DXPS+ZUvy1wBJXKy5yWnJg=
=XyzY
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-32320-1178798785-0001-2--
