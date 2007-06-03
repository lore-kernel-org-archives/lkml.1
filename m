Return-Path: <linux-kernel-owner+w=401wt.eu-S1762901AbXFCIQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762901AbXFCIQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 04:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760642AbXFCIQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 04:16:13 -0400
Received: from mx33.mail.ru ([194.67.23.194]:15712 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760186AbXFCIQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 04:16:10 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: samuel@sortiz.org
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Sun, 3 Jun 2007 12:16:05 +0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       bjorn.helgaas@hp.com
References: <200706031200.07514.arvidjaar@mail.ru>
In-Reply-To: <200706031200.07514.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1391804.U08qHT9hhM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706031216.06172.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1391804.U08qHT9hhM
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 03 June 2007, Andrey Borzenkov wrote:
> Under 2.6.22-rc I lost irda0 interface - smsc claims no device present.
> Nothing was changed in setup except kernel version.
>
> 2.6.21:
>
> Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC IrDA chip,
> pre-configuring device.
> Activated ALi 1533 ISA bridge port 0x02e8.
> Activated ALi 1533 ISA bridge port 0x02f8.
> found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e): LPC47N227
> smsc_superio_flat(): IrDA not enabled
> smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7, mode: 0x02
> SMsC IrDA Controller found
>  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3, irq=3D7
> No transceiver found. Defaulting to Fast pin select
> IrDA: Registered device irda0
>
>
> 2.6.22-rc3:
> Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC IrDA chip,
> pre-configuring device.
> Activated ALi 1533 ISA bridge port 0x02e8.
> Activated ALi 1533 ISA bridge port 0x02f8.
> pnp: Device 00:0a activated.
> smsc_ircc_present(), addr 0x02e8 - no device found!
> pnp: Device 00:0a disabled.
>
> I Cc Adam because of pnp messages in this case - they were not present in
> 2.6.21 so something is being done differently now.
>
> Some more info:
>
> {pts/1}% cat /sys/bus/pnp/devices/00:0a/id
> SMCf010
> {pts/1}% lspci -nn
> 00:00.0 Host bridge [0600]: ALi Corporation M1644/M1644T
> Northbridge+Trident [10b9:1644] (rev 01)
> 00:01.0 PCI bridge [0604]: ALi Corporation PCI to AGP Controller
> [10b9:5247] 00:02.0 USB Controller [0c03]: ALi Corporation USB 1.1
> Controller [10b9:5237] (rev 03)
> 00:04.0 IDE interface [0101]: ALi Corporation M5229 IDE [10b9:5229] (rev
> c3) 00:06.0 Multimedia audio controller [0401]: ALi Corporation M5451 PCI
> AC-Link Controller Audio Device [10b9:5451] (rev 01)
> 00:07.0 ISA bridge [0601]: ALi Corporation M1533/M1535 PCI to ISA Bridge
> [Aladdin IV/V/V+] [10b9:1533]
> 00:08.0 Bridge [0680]: ALi Corporation M7101 Power Management Controller
> [PMU] [10b9:7101]
> 00:0a.0 Ethernet controller [0200]: Intel Corporation 82557/8/9 [Ethernet
> Pro 100] [8086:1229] (rev 08)
> 00:10.0 CardBus bridge [0607]: Texas Instruments PCI1410 PC card Cardbus
> Controller [104c:ac50] (rev 01)
> 00:11.0 CardBus bridge [0607]: Toshiba America Info Systems ToPIC100 PCI =
to
> Cardbus Bridge with ZV Support [1179:0617] (rev 32)
> 00:11.1 CardBus bridge [0607]: Toshiba America Info Systems ToPIC100 PCI =
to
> Cardbus Bridge with ZV Support [1179:0617] (rev 32)
> 00:12.0 System peripheral [0880]: Toshiba America Info Systems SD TypA
> Controller [1179:0805] (rev 03)
> 01:00.0 VGA compatible controller [0300]: Trident Microsystems CyberBlade
> XPAi1 [1023:8820] (rev 82)
>
> config from 2.6.22-rc3 attached.
>

Adding "nopnp" parameters finds device just fine so it is apparently result=
 of=20
this commit:

commit d0d4f69bb65a8c1c1430c577a583632709b874c6
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue May 8 00:36:05 2007 -0700

    smsc-ircc2: add PNP support

What information is needed to debug it further?

=2Dandrey

--nextPart1391804.U08qHT9hhM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGYnjGR6LMutpd94wRApALAJsH2yYE7HjRqSjmdMuhYpyznLjgggCgzaIw
YvAxIK+I3bjcewohF93NG3s=
=C0Mw
-----END PGP SIGNATURE-----

--nextPart1391804.U08qHT9hhM--
