Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbXKYKWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbXKYKWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 05:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXKYKWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 05:22:16 -0500
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:37329 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbXKYKWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 05:22:15 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: "peerchen" <peerchen@gmail.com>
Subject: Re: [PATCH 1/2] msi: set 'En' bit of MSI Mapping Capability on HT platform
Date: Sun, 25 Nov 2007 11:21:45 +0100
User-Agent: KMail/1.9.7
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "pchen" <pchen@nvidia.com>,
       "acurrid" <acurrid@nvidia.com>
References: <200711251121445151346@gmail.com>
In-Reply-To: <200711251121445151346@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1568241.mAmby6MDJZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711251121.49585.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1568241.mAmby6MDJZ
Content-Type: text/plain;
  charset="gb2312"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

> According to the HyperTransport spec, 'En' indicate if the MSI Mapping is
> active. So it should be set when enable the MSI.

Great! This is what I needed to get MSI going on my MCP51 board. I added so=
me=20
ids, but I think there were not necessary, as I only got

PCI: 0000:00:00.0: enabled HT MSI mapping
PCI: 0000:00:10.1: enabled HT MSI mapping

were those devices are:
00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81c0
        Flags: bus master, 66MHz, fast devsel, latency 0
        Capabilities: [44] HyperTransport: Slave or Primary Interface
        Capabilities: [e0] HyperTransport: MSI Mapping Enable+ Fixed-
00: de 10 f0 02 06 00 b0 00 a2 00 00 05 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 00 00 00

According to your patch, you named this device
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC0   0x02F0
So is the lspci database not correct or your naming? lspci lists some=20
memcontrollers for me, but they don't seem to have MSI specific items.


00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a=
2)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81cb
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 319
        Memory at fe024000 (32-bit, non-prefetchable) [size=3D16K]
        Capabilities: [44] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+=20
Queue=3D0/0 Enable+
        Capabilities: [6c] HyperTransport: MSI Mapping Enable+ Fixed+
00: de 10 6c 02 06 04 b0 00 a2 00 03 04 00 00 80 00
10: 00 40 02 fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 cb 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 05 02 02 05

Yay:
cat /proc/interrupts
319:         26       9357   PCI-MSI-edge      HDA Intel


So, now sata_nv and nvidia binary graphics driver could activate MSI, as=20
well. :-)

One thing I noticed in the patch:
+		if (((bridge_dev =3D pci_find_slot(0, 0)) !=3D NULL) &&

You rather want to use pci_get_bus_and_slot instead, as pci_find_slot is=20
deprecated.

Thanks!
=2D-=20
(=A1=E3=3D                 =3D=A1=E3)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart1568241.mAmby6MDJZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHSUy9xU2n/+9+t5gRAnmTAKCvkKgRIuWK2wbf43w/T/Un9Mvv0gCghdPa
jwfdx44G4NPBMjEKHgnrgNE=
=G5NF
-----END PGP SIGNATURE-----

--nextPart1568241.mAmby6MDJZ--
