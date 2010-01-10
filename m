Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660Ab0AJOdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab0AJOdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420Ab0AJOdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:33:23 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:58671 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab0AJOdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:33:22 -0500
X-Authuid: nmarci
Message-ID: <4B49E524.1090404@freemail.hu>
Date: Sun, 10 Jan 2010 15:33:08 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
CC: linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH] i2c: make PCI device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01a.mail.t-online.hu 32721; Body=6 Fuz1=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct pci_driver is constant in <linux/pci.h>
so it is worth to make initialization data also constant.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
disable decl_init,const_decl_init;
identifier I1, I2, x;
@@
	struct I1 {
	  ...
	  const struct I2 *x;
	  ...
	};
@s@
identifier r.I1, y;
identifier r.x, E;
@@
	struct I1 y = {
	  .x = E,
	};
@c@
identifier r.I2;
identifier s.E;
@@
	const struct I2 E[] = ... ;
@depends on !c@
identifier r.I2;
identifier s.E;
@@
+	const
	struct I2 E[] = ...;
// </smpl>

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk
---
diff -u -p a/drivers/i2c/busses/i2c-pasemi.c b/drivers/i2c/busses/i2c-pasemi.c
--- a/drivers/i2c/busses/i2c-pasemi.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/i2c/busses/i2c-pasemi.c 2010-01-08 17:51:26.000000000 +0100
@@ -400,7 +400,7 @@ static void __devexit pasemi_smb_remove(
 	kfree(smbus);
 }

-static struct pci_device_id pasemi_smb_ids[] = {
+static const struct pci_device_id pasemi_smb_ids[] = {
 	{ PCI_DEVICE(0x1959, 0xa003) },
 	{ 0, }
 };
diff -u -p a/drivers/i2c/busses/i2c-via.c b/drivers/i2c/busses/i2c-via.c
--- a/drivers/i2c/busses/i2c-via.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/i2c/busses/i2c-via.c 2010-01-08 17:51:33.000000000 +0100
@@ -89,7 +89,7 @@ static struct i2c_adapter vt586b_adapter
 };


-static struct pci_device_id vt586b_ids[] __devinitdata = {
+static const struct pci_device_id vt586b_ids[] __devinitconst = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_3) },
 	{ 0, }
 };
diff -u -p a/drivers/i2c/busses/i2c-isch.c b/drivers/i2c/busses/i2c-isch.c
--- a/drivers/i2c/busses/i2c-isch.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/i2c/busses/i2c-isch.c 2010-01-08 17:51:42.000000000 +0100
@@ -256,7 +256,7 @@ static struct i2c_adapter sch_adapter =
 	.algo		= &smbus_algorithm,
 };

-static struct pci_device_id sch_ids[] = {
+static const struct pci_device_id sch_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_LPC) },
 	{ 0, }
 };
diff -u -p a/drivers/i2c/busses/i2c-sis5595.c b/drivers/i2c/busses/i2c-sis5595.c
--- a/drivers/i2c/busses/i2c-sis5595.c 2010-01-07 19:08:40.000000000 +0100
+++ b/drivers/i2c/busses/i2c-sis5595.c 2010-01-08 17:51:50.000000000 +0100
@@ -369,7 +369,7 @@ static struct i2c_adapter sis5595_adapte
 	.algo		= &smbus_algorithm,
 };

-static struct pci_device_id sis5595_ids[] __devinitdata = {
+static const struct pci_device_id sis5595_ids[] __devinitconst = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_503) },
 	{ 0, }
 };
diff -u -p a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
--- a/drivers/i2c/busses/i2c-piix4.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/i2c/busses/i2c-piix4.c 2010-01-08 17:52:27.000000000 +0100
@@ -472,7 +472,7 @@ static struct i2c_adapter piix4_adapter
 	.algo		= &smbus_algorithm,
 };

-static struct pci_device_id piix4_ids[] = {
+static const struct pci_device_id piix4_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443MX_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_EFAR, PCI_DEVICE_ID_EFAR_SLC90E66_3) },
diff -u -p a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
--- a/drivers/i2c/busses/i2c-i801.c 2010-01-07 19:08:40.000000000 +0100
+++ b/drivers/i2c/busses/i2c-i801.c 2010-01-08 17:52:37.000000000 +0100
@@ -561,7 +561,7 @@ static struct i2c_adapter i801_adapter =
 	.algo		= &smbus_algorithm,
 };

-static struct pci_device_id i801_ids[] = {
+static const struct pci_device_id i801_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AA_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AB_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801BA_2) },
diff -u -p a/drivers/i2c/busses/i2c-ali1535.c b/drivers/i2c/busses/i2c-ali1535.c
--- a/drivers/i2c/busses/i2c-ali1535.c 2010-01-07 19:08:40.000000000 +0100
+++ b/drivers/i2c/busses/i2c-ali1535.c 2010-01-08 17:52:54.000000000 +0100
@@ -480,7 +480,7 @@ static struct i2c_adapter ali1535_adapte
 	.algo		= &smbus_algorithm,
 };

-static struct pci_device_id ali1535_ids[] = {
+static const struct pci_device_id ali1535_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101) },
 	{ },
 };
diff -u -p a/drivers/i2c/busses/i2c-hydra.c b/drivers/i2c/busses/i2c-hydra.c
--- a/drivers/i2c/busses/i2c-hydra.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/i2c/busses/i2c-hydra.c 2010-01-08 17:53:13.000000000 +0100
@@ -105,7 +105,7 @@ static struct i2c_adapter hydra_adap = {
 	.algo_data	= &hydra_bit_data,
 };

-static struct pci_device_id hydra_ids[] = {
+static const struct pci_device_id hydra_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, PCI_DEVICE_ID_APPLE_HYDRA) },
 	{ 0, }
 };
diff -u -p a/drivers/i2c/busses/i2c-sis630.c b/drivers/i2c/busses/i2c-sis630.c
--- a/drivers/i2c/busses/i2c-sis630.c 2010-01-07 19:08:40.000000000 +0100
+++ b/drivers/i2c/busses/i2c-sis630.c 2010-01-08 17:53:24.000000000 +0100
@@ -468,7 +468,7 @@ static struct i2c_adapter sis630_adapter
 	.algo		= &smbus_algorithm,
 };

-static struct pci_device_id sis630_ids[] __devinitdata = {
+static const struct pci_device_id sis630_ids[] __devinitconst = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_503) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_LPC) },
 	{ 0, }
diff -u -p a/drivers/i2c/busses/i2c-viapro.c b/drivers/i2c/busses/i2c-viapro.c
--- a/drivers/i2c/busses/i2c-viapro.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/i2c/busses/i2c-viapro.c 2010-01-08 17:54:14.000000000 +0100
@@ -444,7 +444,7 @@ release_region:
 	return error;
 }

-static struct pci_device_id vt596_ids[] = {
+static const struct pci_device_id vt596_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C596_3),
 	  .driver_data = SMBBA1 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C596B_3),
diff -u -p a/drivers/i2c/busses/i2c-sis96x.c b/drivers/i2c/busses/i2c-sis96x.c
--- a/drivers/i2c/busses/i2c-sis96x.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/i2c/busses/i2c-sis96x.c 2010-01-08 17:55:25.000000000 +0100
@@ -245,7 +245,7 @@ static struct i2c_adapter sis96x_adapter
 	.algo		= &smbus_algorithm,
 };

-static struct pci_device_id sis96x_ids[] = {
+static const struct pci_device_id sis96x_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_SMBUS) },
 	{ 0, }
 };
diff -u -p a/drivers/i2c/busses/i2c-amd756.c b/drivers/i2c/busses/i2c-amd756.c
--- a/drivers/i2c/busses/i2c-amd756.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/i2c/busses/i2c-amd756.c 2010-01-08 17:56:57.000000000 +0100
@@ -308,7 +308,7 @@ static const char* chipname[] = {
 	"nVidia nForce", "AMD8111",
 };

-static struct pci_device_id amd756_ids[] = {
+static const struct pci_device_id amd756_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_VIPER_740B),
 	  .driver_data = AMD756 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_VIPER_7413),
diff -u -p a/drivers/i2c/busses/i2c-tiny-usb.c b/drivers/i2c/busses/i2c-tiny-usb.c
--- a/drivers/i2c/busses/i2c-tiny-usb.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/i2c/busses/i2c-tiny-usb.c 2010-01-08 17:57:06.000000000 +0100
@@ -136,7 +136,7 @@ static const struct i2c_algorithm usb_al
  * Future Technology Devices International Ltd., later a pair was
  * bought from EZPrototypes
  */
-static struct usb_device_id i2c_tiny_usb_table [] = {
+static const struct usb_device_id i2c_tiny_usb_table[] = {
 	{ USB_DEVICE(0x0403, 0xc631) },   /* FTDI */
 	{ USB_DEVICE(0x1c40, 0x0534) },   /* EZPrototypes */
 	{ }                               /* Terminating entry */
diff -u -p a/drivers/i2c/busses/i2c-amd8111.c b/drivers/i2c/busses/i2c-amd8111.c
--- a/drivers/i2c/busses/i2c-amd8111.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/i2c/busses/i2c-amd8111.c 2010-01-08 17:57:27.000000000 +0100
@@ -351,7 +351,7 @@ static const struct i2c_algorithm smbus_
 };


-static struct pci_device_id amd8111_ids[] = {
+static const struct pci_device_id amd8111_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8111_SMBUS2) },
 	{ 0, }
 };
diff -u -p a/drivers/i2c/busses/i2c-ali15x3.c b/drivers/i2c/busses/i2c-ali15x3.c
--- a/drivers/i2c/busses/i2c-ali15x3.c 2010-01-07 19:08:40.000000000 +0100
+++ b/drivers/i2c/busses/i2c-ali15x3.c 2010-01-08 17:57:39.000000000 +0100
@@ -477,7 +477,7 @@ static struct i2c_adapter ali15x3_adapte
 	.algo		= &smbus_algorithm,
 };

-static struct pci_device_id ali15x3_ids[] = {
+static const struct pci_device_id ali15x3_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101) },
 	{ 0, }
 };
diff -u -p a/drivers/i2c/busses/i2c-ali1563.c b/drivers/i2c/busses/i2c-ali1563.c
--- a/drivers/i2c/busses/i2c-ali1563.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/i2c/busses/i2c-ali1563.c 2010-01-08 17:58:34.000000000 +0100
@@ -417,7 +417,7 @@ static void __devexit ali1563_remove(str
 	ali1563_shutdown(dev);
 }

-static struct pci_device_id __devinitdata ali1563_id_table[] = {
+static const struct pci_device_id ali1563_id_table[] __devinitconst = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1563) },
 	{},
 };
diff -u -p a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
--- a/drivers/i2c/busses/i2c-nforce2.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/i2c/busses/i2c-nforce2.c 2010-01-08 17:58:43.000000000 +0100
@@ -308,7 +308,7 @@ static struct i2c_algorithm smbus_algori
 };


-static struct pci_device_id nforce2_ids[] = {
+static const struct pci_device_id nforce2_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2S_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE3_SMBUS) },
