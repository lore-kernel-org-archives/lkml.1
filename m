Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0AOBi6 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863Ab0AOBiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:38:51 -0500
Received: from kroah.org ([198.145.64.141]:50992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab0AOBiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:38:50 -0500
Subject: patch staging-make-pci-device-id-constant.patch added to gregkh-2.6 tree
To: nm127@freemail.hu, gregkh@suse.de, julia@diku.dk,
        linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 14 Jan 2010 17:36:47 -0800
In-Reply-To: <4B490EC2.7050703@freemail.hu>
Message-ID: <1263519407130@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: staging: make PCI device id constant

to my gregkh-2.6 tree.  Its filename is

    staging-make-pci-device-id-constant.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From nm127@freemail.hu  Thu Jan 14 17:08:52 2010
From: Németh Márton <nm127@freemail.hu>
Date: Sun, 10 Jan 2010 00:18:26 +0100
Subject: staging: make PCI device id constant
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Julia Lawall <julia@diku.dk>, LKML <linux-kernel@vger.kernel.org>, cocci@diku.dk
Message-ID: <4B490EC2.7050703@freemail.hu>


From: Németh Márton <nm127@freemail.hu>

The id_table field of the struct pci_driver is constant in <linux/pci.h>
so it is worth to make the initialization data also constant.

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

Signed-off-by: Németh Márton <nm127@freemail.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/phison/phison.c            |    2 +-
 drivers/staging/rar/rar_driver.c           |    2 +-
 drivers/staging/sep/sep_driver.c           |    2 +-
 drivers/staging/sm7xx/smtcfb.c             |    2 +-
 drivers/staging/vme/bridges/vme_ca91cx42.c |    2 +-
 drivers/staging/vme/bridges/vme_tsi148.c   |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/staging/phison/phison.c
+++ b/drivers/staging/phison/phison.c
@@ -69,7 +69,7 @@ static int phison_init_one(struct pci_de
 	return ret;
 }
 
-static struct pci_device_id phison_pci_tbl[] = {
+static const struct pci_device_id phison_pci_tbl[] = {
 	{ PCI_VENDOR_ID_PHISON, PCI_DEVICE_ID_PS5000, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_IDE << 8, 0xffff00, 0 },
 	{ 0, },
--- a/drivers/staging/rar/rar_driver.c
+++ b/drivers/staging/rar/rar_driver.c
@@ -71,7 +71,7 @@ static void __exit rar_exit_handler(void
 static int __devinit rar_probe(struct pci_dev *pdev,
 			       const struct pci_device_id *ent);
 
-static struct pci_device_id rar_pci_id_tbl[] = {
+static const struct pci_device_id rar_pci_id_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4110) },
 	{ 0 }
 };
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -2587,7 +2587,7 @@ end_function:
 	return error;
 }
 
-static struct pci_device_id sep_pci_id_tbl[] = {
+static const struct pci_device_id sep_pci_id_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080c)},
 	{0}
 };
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -1103,7 +1103,7 @@ static int __init smtcfb_pci_probe(struc
 
 
 /* Jason (08/11/2009) PCI_DRV wrapper essential structs */
-static struct pci_device_id smtcfb_pci_table[] = {
+static const struct pci_device_id smtcfb_pci_table[] = {
 	{0x126f, 0x710, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0x126f, 0x712, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0x126f, 0x720, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -61,7 +61,7 @@ static struct mutex vme_int;	/*
 
 static char driver_name[] = "vme_ca91cx42";
 
-static struct pci_device_id ca91cx42_ids[] = {
+static const struct pci_device_id ca91cx42_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_TUNDRA, PCI_DEVICE_ID_TUNDRA_CA91C142) },
 	{ },
 };
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -81,7 +81,7 @@ static struct mutex vme_int;	/*
 
 static char driver_name[] = "vme_tsi148";
 
-static struct pci_device_id tsi148_ids[] = {
+static const struct pci_device_id tsi148_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_TUNDRA, PCI_DEVICE_ID_TUNDRA_TSI148) },
 	{ },
 };

