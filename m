Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYJNXjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYJNXjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 19:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYJNXjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 19:39:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:43646 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751510AbYJNXjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 19:39:31 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/aHA0nT7XamDTGtjUIlGwyYCbq5xHzSd60rQPG7+
	jl3zDWSpT+l++F
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: Linux 2.6.27-git3: rtl8169 oops and wireless missing symbols
Date: Wed, 15 Oct 2008 01:39:28 +0200
User-Agent: KMail/1.9.9
Cc: "J.A. =?utf-8?q?Magall=C3=B3n?=" <jamagallon@ono.com>
References: <20081014010202.71d13eaf@werewolf.home> <20081014023003.07b6d745@werewolf.home> <20081014193316.GA8223@electric-eye.fr.zoreil.com>
In-Reply-To: <20081014193316.GA8223@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2249291.EKuV8zXoLW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810150139.28935.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2249291.EKuV8zXoLW
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

On Dienstag, 14. Oktober 2008, Francois Romieu wrote:
> J.A. Magall=C3=B3n <jamagallon@ono.com> :
> [...]
> > Oct 14 02:27:45 one kernel: r8169 Gigabit Ethernet driver 2.3LK-NAPI lo=
aded
> > Oct 14 02:27:45 one kernel: r8169 0000:02:00.0: PCI INT A -> GSI 17 (le=
vel, low) -> IRQ 17
> > Oct 14 02:27:45 one kernel: r8169 0000:02:00.0: setting latency timer t=
o 64
> > Oct 14 02:27:45 one kernel: eth0: RTL8102e at 0xdfffe000, 00:00:00:00:0=
0:00, XID 24a00000 IRQ 219
>=20
> The MAC address does not look sane. Does the revert below cure it ?

I can confirm this behaviour on 2.6.27 + all r8169 related updates cherry=20
picked from linux-2.6 git[1]:

This is the relevant diff between the non-working[2] (all current updates=20
applied on top of 2.6.27) and the working[3] variant including your revert
below. With that revert, everything seems to work well again.

 r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
 r8169 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 r8169 0000:03:00.0: setting latency timer to 64
=2Deth0: RTL8168c/8111c at 0xffffc20000c44000, 00:00:00:00:00:00, XID 3c400=
0c0 IRQ 1274
+eth0: RTL8168c/8111c at 0xffffc20000c42000, 00:1f:d0:88:4b:2f, XID 3c4000c=
0 IRQ 1274
 r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
 r8169 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
 r8169 0000:04:00.0: setting latency timer to 64
=2Deth1: RTL8168c/8111c at 0xffffc20000c46000, 00:00:00:00:00:00, XID 3c400=
0c0 IRQ 1273
+eth1: RTL8168c/8111c at 0xffffc20000c44000, 00:1f:d0:80:86:25, XID 3c4000c=
0 IRQ 1273


lspci output taken from the working variant:

03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B =
PCI Express Gigabit Ethernet controller (rev 02)
        Subsystem: Giga-byte Technology Device e000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 1274
        Region 0: I/O ports at c000 [size=3D256]
        Region 2: Memory at e8010000 (64-bit, prefetchable) [size=3D4K]
        Region 4: Memory at e8000000 (64-bit, prefetchable) [size=3D64K]
        [virtual] Expansion ROM at e8020000 [disabled] [size=3D64K]
        Capabilities: <access denied>
        Kernel driver in use: r8169
        Kernel modules: r8169

04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B =
PCI Express Gigabit Ethernet controller (rev 02)
        Subsystem: Giga-byte Technology Device e000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 1273
        Region 0: I/O ports at d000 [size=3D256]
        Region 2: Memory at e8110000 (64-bit, prefetchable) [size=3D4K]
        Region 4: Memory at e8100000 (64-bit, prefetchable) [size=3D64K]
        [virtual] Expansion ROM at e8120000 [disabled] [size=3D64K]
        Capabilities: <access denied>
        Kernel driver in use: r8169
        Kernel modules: r8169

> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> index c821da2..5b8f8ba 100644
> --- a/drivers/net/r8169.c
> +++ b/drivers/net/r8169.c
> @@ -1911,74 +1911,6 @@ static void rtl_disable_msi(struct pci_dev *pdev, =
struct rtl8169_private *tp)
>  	}
>  }
> =20
> -static int rtl_eeprom_read(struct pci_dev *pdev, int cap, int addr, __le=
32 *val)
[...]
> -}
> -
> -static void rtl_init_mac_address(struct rtl8169_private *tp,
> -				 void __iomem *ioaddr)
> -{
[...]
> -}
> -
>  static int __devinit
>  rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  {
> @@ -2156,8 +2088,6 @@ rtl8169_init_one(struct pci_dev *pdev, const struct=
 pci_device_id *ent)
> =20
>  	tp->mmio_addr =3D ioaddr;
> =20
> -	rtl_init_mac_address(tp, ioaddr);
> -
>  	/* Get MAC address */
>  	for (i =3D 0; i < MAC_ADDR_LEN; i++)
>  		dev->dev_addr[i] =3D RTL_R8(MAC0 + i);

Regards
	Stefan Lippers-Hollmann

[1]	http://sidux.com/slh/r8169/patches/ (cherry picked r8169 from=20
	linux-2.6 HEAD)
[2]	http://sidux.com/slh/r8169/dmesg.not-working.log
[3]	http://sidux.com/slh/r8169/dmesg.working.log

--nextPart2249291.EKuV8zXoLW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkj1LbAACgkQORbEMfgJlPaAYwCcCjLwHaZ3Oui1A9JZztJD1t3+
x5IAoIUbGPzHHu29z/+rRCRCjethwhaY
=wKJs
-----END PGP SIGNATURE-----

--nextPart2249291.EKuV8zXoLW--
