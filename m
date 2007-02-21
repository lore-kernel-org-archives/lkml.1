Return-Path: <linux-kernel-owner+w=401wt.eu-S1161237AbXBUOCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161237AbXBUOCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 09:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161243AbXBUOCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 09:02:50 -0500
Received: from smtp23.orange.fr ([193.252.22.30]:28781 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161237AbXBUOCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 09:02:49 -0500
X-ME-UUID: 20070221140202463.7113F700009F@mwinf2352.orange.fr
X-ME-User-Auth: jean-luc.coulon
Date: Wed, 21 Feb 2007 15:01:54 +0100
From: "Jean-Luc Coulon (f5ibh)" <jean-luc.coulon@wanadoo.fr>
Subject: 2.6.20-git and 2.6.21-rc1, failed to boot on sata_via
To: linux-kernel@vger.kernel.org
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAGFBMVEV7e3v8/Pzy8vKqqqr/
	//9AQEDV1dUSEhK4Ewz8AAACVElEQVQ4jWWUTW/bMAyGiRpuzlaNnhO11VmtFu2cQD/AWKDp
	2kqtei1QePr7e0k7yYDxZj4iX35IpkFsH1MTmzN/Kq1J/NsY22qnHYNhAapP7WI3S4iA7dnP
	cV87IQzU/uzvLI68MJCIu1Vg9tngzO8FjIP6EDDH292oSlpzUYB0ZHfsHkM4IGR+W8Fdohhp
	Yn84GqhIXUj19FWIrN/BHwbj0iIC8PldnS85CLiHyJ9hOCCV2pyKq1UCoFF6Vgc4qDQ5n/P4
	H7hvAHXJFAIDlBUAtgDuAlijAQQB3RVwVe05XIEOq4bbtPZrBTNHjGsq169gAGB1Lvega3UW
	Y5SIBwZoROvqKFLn0nwrwCQuyznveBk4lCY/MtCbNlGcp67w9Gdym5MXDf2zyRU5GVyVOZHr
	6QJk5V/adkTQsFRFQ38ymOO3crZDecX6LEAxiFM/aV+402KrRAT11FKciKbsa81aF6pmAdsW
	kZum6qveYSa0RBzUgwA7Gef1eESXVao6DCZFcs6eAPKoqiX/skSYNK/A5Z0GqO8L0D3adnZy
	PGRTlzbQoDI9RBw1St0C3sIasWd1rDqecjXF2vczeMVMARr5XGtxK8AbqT0a7FPsPN88RyvA
	guo+9pF35MgVSz+u4EMALHaO/gWvsW/LU8DQ6VmA1gaKkRIKsGgUG3m5ghqniPNxwkosahgF
	wA91rJczsb60SOKHCBsJ8K8RKyTxQwR52A0NLPJ+PIMq5Yq/q+Xm+HgBNvJ6O0vxNpv3g76A
	kmYmGA7+AiGo8QI23B8Mo8f9Pua/poMbvka+1JsAAAAASUVORK5CYII=
X-Mailer: Balsa 2.3.14
Message-Id: <1172066520l.8209l.0l@tangerine>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	protocol="application/pgp-signature"; boundary="=-Av7uNOmjaYtESKZPsAlE"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-Av7uNOmjaYtESKZPsAlE
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I've an ASUS A8V motherboard with a via chipset:

[jean-luc@tangerine] % lspci
00:00.0 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
00:00.1 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
00:00.2 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
00:00.3 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
00:00.4 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
00:00.7 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge =20
[K8T800/K8T890 South]

2 SATA drives are on this chipset, using lvm over a raid1.

I've a X86-64 architecture on an amd64.

Since 2.6.20-git<somewhere before 10>, the system refuses to boot, I've =20
the same problem with 2.6.21-rc1.

I've opened a bug, see: http://bugzilla.kernel.org/show_bug.cgi?id=3D8025
but I'm not sure it was the appropriate way.

At boot time, I've the following messages:

ACPI: PCI Interrupt 0000:00:0f.0[B] GSI 20(level, low) -> IRQ 20
sata_via 0000:00:0f.0: failed on iomap PCI BAR 0
sata_via 0000:00:0f.0: out of memory
ACPI: PCI interrupt for device 0000:00:0f.0 is disabled
sata_via: probe of 0000:00:0f.0 failed with error -12

Then the raid is not assembled and the system wont boot.

These are the options (parts of] enabled in my config file:

#
# ATA/ATAPI/MFM/RLL support
#
CONFIG_IDE=3Dm
CONFIG_BLK_DEV_IDE=3Dm

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=3Dm
CONFIG_IDEDISK_MULTI_MODE=3Dy
CONFIG_BLK_DEV_IDECD=3Dm
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
...
#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEPCI=3Dy
# CONFIG_IDEPCI_SHARE_IRQ is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=3Dy
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
CONFIG_IDEDMA_PCI_AUTO=3Dy
# CONFIG_IDEDMA_ONLYDISK is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=3Dm
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_IDE_ARM is not set
CONFIG_BLK_DEV_IDEDMA=3Dy
CONFIG_IDEDMA_IVB=3Dy
CONFIG_IDEDMA_AUTO=3Dy



#
# Serial ATA (prod) and Parallel ATA (experimental) drivers
#
CONFIG_ATA=3Dm
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
CONFIG_SATA_PROMISE=3Dm
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=3Dm
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACPI=3Dy
...


I've found a quite similar problem in the archive but which seems to =20
have been fixed in the meantime, in this thread:
http://www.ussg.iu.edu/hypermail/linux/kernel/0702.1/1580.html

[I'm not subscribed to the list]


Regards

Jean-Luc

--=-Av7uNOmjaYtESKZPsAlE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF3FDYUdGGXzzGnNARAiA0AJ9ui9Mr3uFw0TSh5GroXippo0JILQCdHG+9
poJZzuctS1aTqpV6ovd9yFM=
=q93O
-----END PGP SIGNATURE-----

--=-Av7uNOmjaYtESKZPsAlE--

