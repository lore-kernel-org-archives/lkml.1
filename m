Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZICThK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZICThK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbZICThJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:37:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57564 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbZICThI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:37:08 -0400
Date: Thu, 3 Sep 2009 21:37:09 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Frans Pop <elendil@planet.nl>
Cc: Christian =?iso-8859-15?Q?Kr=E4mer?= <christian@kraemer-eu.de>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Message-ID: <20090903193709.GA11097@pengutronix.de>
References: <200909021856.29565.christian@kraemer-eu.de> <200909021953.02190.elendil@planet.nl> <200909030042.45081.christian@kraemer-eu.de> <200909031927.19590.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <200909031927.19590.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Original message with lspci and dmesg output for .24 is at:
> http://lkml.org/lkml/2009/9/2/199

For a start:

That line

pcmcia: Detected deprecated PCMCIA ioctl usage from process: hwsetup.

has not much to do with pcmcia_cs. It is just that hwsetup uses a deprecated
interface (new one is sysfs). Is this message still showing up with the new=
er
gentoo-version? I seem to recall that hwsetup got fixed meanwhile, but I ma=
y be
wrong here.

What about these lines?

PCI: Probing PCI hardware
sysfs: duplicate filename 'bridge' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Pid: 1, comm: swapper Not tainted 2.6.24-gentoo-r7 #1
 [<c0187ceb>] sysfs_add_one+0x54/0xb8
 [<c01888da>] sysfs_create_link+0xaf/0xfd
 [<c02c8020>] pci_bus_add_devices+0xba/0xff
 [<c037ac1d>] pcibios_scan_root+0x25/0x80
 [<c011ab3d>] printk+0x1b/0x1f
 [<c052822f>] pci_legacy_init+0x53/0xe1
 [<c0505769>] kernel_init+0x154/0x2b6
 [<c0102546>] ret_from_fork+0x6/0x20
 [<c0505615>] kernel_init+0x0/0x2b6
 [<c0505615>] kernel_init+0x0/0x2b6
 [<c0103877>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
pci 0000:00:02.0: Error creating sysfs bridge symlink, continuing...
sysfs: duplicate filename 'bridge' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Pid: 1, comm: swapper Not tainted 2.6.24-gentoo-r7 #1
 [<c0187ceb>] sysfs_add_one+0x54/0xb8
 [<c01888da>] sysfs_create_link+0xaf/0xfd
 [<c02c8020>] pci_bus_add_devices+0xba/0xff
 [<c052822f>] pci_legacy_init+0x53/0xe1
 [<c0505769>] kernel_init+0x154/0x2b6
 [<c0102546>] ret_from_fork+0x6/0x20
 [<c0505615>] kernel_init+0x0/0x2b6
 [<c0505615>] kernel_init+0x0/0x2b6
 [<c0103877>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
pci 0000:00:02.1: Error creating sysfs bridge symlink, continuing...

Do they still show up with the latest kernel? Is this a known problem with =
this
laptop?

So much for a glimpse, maybe I'll have a bit more time tomorrow...

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqgGuUACgkQD27XaX1/VRvRwACcCz4RITh3XWu3HbW1+Z/S+7TL
HoIAoMaMAZaDb9QoqqHxkznMpMTlgJzw
=mXC+
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
