Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbXD0Cbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbXD0Cbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 22:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbXD0Cbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 22:31:39 -0400
Received: from h80ad2741.async.vt.edu ([128.173.39.65]:58039 "EHLO
	h80ad2741.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbXD0Cbi (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 22:31:38 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc7-mm2 breaks 'lvm vgscan'.
In-Reply-To: Your message of "Wed, 25 Apr 2007 22:57:16 PDT."
             <20070425225716.8e9b28ca.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1177641075_3785P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 26 Apr 2007 22:31:15 -0400
Message-ID: <8526.1177641075@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1177641075_3785P
Content-Type: text/plain; charset=us-ascii

On Wed, 25 Apr 2007 22:57:16 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/

This addition in -rc7-mm1 breaks my laptop (Dell Latitude D820, x86_64 kernel)

gregkh-driver-sysfs-fix-i_ino-handling-in-sysfs.patch

The initrd on my system does an 'lvm vgscan' to get the root filesystem
accessible.  Under -rc5-mm2, this works fine.  For -rc7-mm[12], it finds the disk:

ata_piix 0000:00:1f.2: version 2.11
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001bfa0 irq 14
ata2: PATA max UDMA/100 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001bfa8 irq 15
ata1.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata1.00: ATA-7: ST980825AS, 8.04, max UDMA/133
ata1.00: 156301488 sectors, multi 8: LBA48 NCQ (depth 0/32)
ata1.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata1.00: configured for UDMA/133
ata2.00: ATAPI, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      ST980825AS       8.04 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk

sda1 is an ext3 /boot, sda2 is an LVM space covering the rest of the disk, so
we're doing well so far.

The 'lvm vgscan' fails and says 'No volume groups found, with no useful kernel
messages issued.  Then we get the infamous "Kernel panic - not syncing:
Attempted to kill init!" when it can't find the root file system and we fall
off the end of the initrd.

Any ideas?

--==_Exmh_1177641075_3785P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGMWBzcC3lWbTT17ARAn0UAJ9Tc8m9CgTnP+Fv/seBkuDM6E7YAgCfYxDJ
M2Qu//RK74X/QIipC6n6vcY=
=hvxX
-----END PGP SIGNATURE-----

--==_Exmh_1177641075_3785P--
