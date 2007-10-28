Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbXJ1Pm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbXJ1Pm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 11:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXJ1Pms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 11:42:48 -0400
Received: from donetsk.donpac.ru ([80.254.111.38]:51759 "EHLO
	donetsk.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbXJ1Pmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 11:42:47 -0400
Date: Sun, 28 Oct 2007 18:42:42 +0300
From: Andrey Panin <pazke@donpac.ru>
To: Chris Bergeron <chris@pcburn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
Message-ID: <20071028154242.GA13166@pazke.donpac.ru>
Mail-Followup-To: Chris Bergeron <chris@pcburn.com>,
	linux-kernel@vger.kernel.org
References: <20071010095432.GC30345@pazke.donpac.ru> <470E5714.4040303@pcburn.com> <20071012120826.GB23378@pazke.donpac.ru> <47150B06.3040306@pcburn.com> <20071017064219.GB1953@pazke.donpac.ru> <471689DA.4070008@pcburn.com> <20071018055755.GA9561@pazke.donpac.ru> <47179116.2070505@pcburn.com> <20071022153323.GA8123@pazke.donpac.ru> <471CDA66.2020004@pcburn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline
In-Reply-To: <471CDA66.2020004@pcburn.com>
X-Uname: Linux 2.6.22-2-amd64 x86_64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--XF85m9dhOBO43t/C
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 295, 10 22, 2007 at 01:14:14 -0400, Chris Bergeron wrote:
> Andrey Panin wrote:
>> On 291, 10 18, 2007 at 01:00:06 -0400, Chris Bergeron wrote:
>>   So the card probably generates screaming interrupt... that's bad.
>> I found some docs for IT887x chips, according to these docs  IT887x
>> have simple interrupt controller inside. Further investigation is needed.
>>
>> Can you post output of lspci -xxx ?
>>
>>  =20
> Full output at=20
> http://pcburn.com/files/Syba_serial_controller/lspci_xxx.out.  The releva=
nt=20
> part for the Syba card is probably:
>
> 01:08.0 Serial controller: PLX Technology, Inc. Unknown device 9016 (rev=
=20
> 01)
> 00: b5 10 16 90 07 00 80 02 01 02 00 07 00 00 00 00
> 10: 01 a4 00 00 01 a8 00 00 01 ac 00 00 00 00 00 f5
> 20: 00 10 00 f5 00 20 00 f5 00 00 00 00 4e 54 08 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 05 01 00 00
> 40: 3f 3f 08 00 00 8c 20 8b 45 54 55 45 00 00 10 d2
> 50: 01 01 71 03 01 03 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 03 00 06 f8 03 f8 02
> 80: 78 03 78 07 00 08 00 07 00 01 20 01 40 01 60 01
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 70 43 25 64
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Can you test an attached patch against 2.6.24-rc1 ?

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-syba-2
Content-Transfer-Encoding: quoted-printable

diff -urdpNX dontdiff linux-2.6.24.vanilla/drivers/serial/8250_pci.c linux-=
2.6.24/drivers/serial/8250_pci.c
--- linux-2.6.24.vanilla/drivers/serial/8250_pci.c	2007-10-28 13:00:14.0000=
00000 +0300
+++ linux-2.6.24/drivers/serial/8250_pci.c	2007-10-28 18:15:12.000000000 +0=
300
@@ -610,45 +610,49 @@ static int pci_netmos_init(struct pci_de
 /* enable IO_Space bit */
 #define ITE_887x_POSIO_ENABLE		(1 << 31)
=20
-static int pci_ite887x_init(struct pci_dev *dev)
+static int pci_ite_887x_allocate_io(struct pci_dev *dev)
 {
-	/* inta_addr are the configuration addresses of the ITE */
-	static const short inta_addr[] =3D { 0x2a0, 0x2c0, 0x220, 0x240, 0x1e0,
-							0x200, 0x280, 0 };
-	int ret, i, type;
-	struct resource *iobase =3D NULL;
-	u32 miscr, uartbar, ioport;
+	static const short inta_addr[] =3D {
+		0x2a0, 0x2c0, 0x220, 0x240, 0x1e0, 0x200, 0x280, 0
+	};
+	int ret, i;
=20
-	/* search for the base-ioport */
-	i =3D 0;
-	while (inta_addr[i] && iobase =3D=3D NULL) {
-		iobase =3D request_region(inta_addr[i], ITE_887x_IOSIZE,
-								"ite887x");
-		if (iobase !=3D NULL) {
+	for (i =3D 0; i < ARRAY_SIZE(inta_addr); i++) {
+		int iobase =3D inta_addr[i];
+
+		if (request_region(iobase, ITE_887x_IOSIZE, "ite887x")) {
 			/* write POSIO0R - speed | size | ioport */
 			pci_write_config_dword(dev, ITE_887x_POSIO0,
 				ITE_887x_POSIO_ENABLE | ITE_887x_POSIO_SPEED |
-				ITE_887x_POSIO_IOSIZE_32 | inta_addr[i]);
+				ITE_887x_POSIO_IOSIZE_32 | iobase);
+
 			/* write INTCBAR - ioport */
-			pci_write_config_dword(dev, ITE_887x_INTCBAR, inta_addr[i]);
-			ret =3D inb(inta_addr[i]);
+			pci_write_config_dword(dev, ITE_887x_INTCBAR, iobase);
+			ret =3D inb(iobase);
 			if (ret !=3D 0xff) {
 				/* ioport connected */
-				break;
+				return iobase;
 			}
-			release_region(iobase->start, ITE_887x_IOSIZE);
-			iobase =3D NULL;
+			release_region(iobase, ITE_887x_IOSIZE);
 		}
-		i++;
 	}
=20
-	if (!inta_addr[i]) {
+	return 0;
+}
+
+static int pci_ite887x_init(struct pci_dev *dev)
+{
+	int i, ret, type, iobase;
+	u32 miscr, uartbar, ioport;
+
+	iobase =3D pci_ite_887x_allocate_io(dev);
+	if (!iobase) {
 		printk(KERN_ERR "ite887x: could not find iobase\n");
 		return -ENODEV;
 	}
=20
 	/* start of undocumented type checking (see parport_pc.c) */
-	type =3D inb(iobase->start + 0x18) & 0x0f;
+	type =3D inb(iobase + 0x18) & 0x0f;
=20
 	switch (type) {
 	case 0x2:	/* ITE8871 (1P) */
@@ -697,7 +701,7 @@ static int pci_ite887x_init(struct pci_d
=20
 	if (ret <=3D 0) {
 		/* the device has no UARTs if we get here */
-		release_region(iobase->start, ITE_887x_IOSIZE);
+		release_region(iobase, ITE_887x_IOSIZE);
 	}
=20
 	return ret;
@@ -712,6 +716,57 @@ static void __devexit pci_ite887x_exit(s
 	release_region(ioport, ITE_887x_IOSIZE);
 }
=20
+#define ITE_887x_IRR0	0
+#define ITE_887x_IRR1	1
+#define ITE_887x_IRR2	2
+#define ITE_887x_IMR0	4
+#define ITE_887x_IMR1	5
+#define ITE_887x_IMR2	6
+#define ITE_887x_IER0	8
+#define ITE_887x_IER1	9
+#define ITE_887x_IER2	10
+#define ITE_887x_ITR0	12
+#define ITE_887x_ITR1	13
+#define ITE_887x_ITR2	14
+
+static int pci_syba_ite887x_init(struct pci_dev *dev)
+{
+	int iobase =3D pci_ite_887x_allocate_io(dev);
+
+	if (!iobase) {
+		printk(KERN_ERR "ite887x: could not find iobase\n");
+		return -ENODEV;
+	}
+
+	/* DEBUG */
+	printk(KERN_INFO "ite887x: io base at %#x\n", iobase);
+	printk(KERN_INFO "ite887x: IRR0=3D%02x IMR0=3D%02x IER0=3D%02x\n",=20
+		inb(iobase + ITE_887x_IRR0), inb(iobase + ITE_887x_IMR0), inb(iobase + I=
TE_887x_IER0));
+	printk(KERN_INFO "ite887x: IRR1=3D%02x IMR1=3D%02x IER1=3D%02x\n",=20
+		inb(iobase + ITE_887x_IRR1), inb(iobase + ITE_887x_IMR1), inb(iobase + I=
TE_887x_IER1));
+	printk(KERN_INFO "ite887x: IRR2=3D%02x IMR2=3D%02x IER2=3D%02x\n",=20
+		inb(iobase + ITE_887x_IRR2), inb(iobase + ITE_887x_IMR2), inb(iobase + I=
TE_887x_IER2));
+
+	/* Clear s/w interrupt genaration register (just in case) */
+	outb(0, iobase + ITE_887x_IER0);
+	outb(0, iobase + ITE_887x_IER1);
+	outb(0, iobase + ITE_887x_IER2);
+
+	/* Clear IRQ latches */
+	outb(0, iobase + ITE_887x_IRR0);
+	outb(0, iobase + ITE_887x_IRR1);
+	outb(0, iobase + ITE_887x_IRR2);
+
+	/* Mask interrupts from on-chip devices (unused on this card) */
+	outb(0xf, iobase + ITE_887x_IMR2);
+
+	/* Set external IRQ mode to level-triggered */
+	outb(0xff, iobase + ITE_887x_IER0);
+	outb(0xff, iobase + ITE_887x_IER1);
+
+	return 8;
+}
+
 static int
 pci_default_setup(struct serial_private *priv, struct pciserial_board *boa=
rd,
 		  struct uart_port *port, int idx)
@@ -797,6 +852,18 @@ static struct pci_serial_quirk pci_seria
 		.exit		=3D __devexit_p(pci_ite887x_exit),
 	},
 	/*
+	 * Syba
+	 */
+	{
+		.vendor		=3D PCI_VENDOR_ID_PLX,
+		.device		=3D 0x9016,
+		.subvendor	=3D 0x544e,
+		.subdevice	=3D 0x0008,
+		.init		=3D pci_syba_ite887x_init,
+		.setup		=3D pci_default_setup,
+		.exit		=3D __devexit_p(pci_ite887x_exit),
+	},
+	/*
 	 * Panacom
 	 */
 	{
@@ -2527,6 +2594,11 @@ static struct pci_device_id serial_pci_t
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b3_8_115200 },
=20
+	/* Syba PCI8871-PR8 8-port serial card */
+	{	PCI_VENDOR_ID_PLX, 0x9016,
+		0x544e, 0x0008, 0, 0,
+		pbn_b0_8_115200 },
+
 	/*
 	 * Exar Corp. XR17C15[248] Dual/Quad/Octal UART
 	 */

--CE+1k2dSO48ffgeK--

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHJK3yIWZCBzwS8mkRApX4AJ0WScHNehlP8gsSc9TZhOhtetk6fACfT8ek
L7YNFvWq2QoWRU8E5xt4uds=
=5Ji1
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
