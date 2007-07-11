Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbXGKBmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbXGKBmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 21:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbXGKBmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 21:42:43 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51497 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbXGKBmm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 21:42:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: SCSI link power management patches - a question..
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1184118159_3928P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Jul 2007 21:42:39 -0400
Message-ID: <11044.1184118159@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1184118159_3928P
Content-Type: text/plain; charset=us-ascii

I refitted the 4 patches you posted to a 22-rc6-mm1 kernel, and tried it on
my Dell Latitude D820 laptop, using the libata driver for the disk and DVD.
I got this:

[    0.702000] scsi0 : ata_piix
[    0.702000] scsi1 : ata_piix
[    0.702000] ata1: SATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x
000000000001bfa0 irq 14
[    0.702000] ata2: PATA max UDMA/100 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x
000000000001bfa8 irq 15
[    0.857000] ata1.00: ATA-7: ST980825AS, 8.04, max UDMA/133
[    0.857000] ata1.00: 156301488 sectors, multi 8: LBA48 NCQ (depth 0/32)
[    0.864000] ata1.00: configured for UDMA/133
[    1.169000] ata2.00: ATAPI: PHILIPS DVD+/-RW SDVD8820, AD15, max UDMA/33
[    1.342000] ata2.00: configured for UDMA/33
....
[    1.342000]  sda: sda1 sda2
[    1.433000] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.435000] scsi 1:0:0:0: CD-ROM            PHILIPS  DVD+-RW SDVD8820 AD15 PQ: 0 ANSI: 5
[    1.454000] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    1.454000] Uniform CD-ROM driver Revision: 3.20
[    1.454000] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.454000] ata2.00: Unable to set Link PM policy

and /sys/class/scsi_host/host[01]/link_power_management_policy are both
stuck at 'max_performance'.  After reading the code,it *appears* that this
is because:

host0 - the 2 ports on the first ATA chain, and it's stuck because the DVD
doesn't support the required power management, and *all* devices on the chain
need to support it (as it didnt complain on ata1, the hard drive).

host1 - the second ATA chain, not connected to anything, so no PM available.

How do I double-check my analysis? Neither hdparm nor sdparm gave me anything
on /dev/dvd that told me either way, and I'd like to verify that the base
problem is "screwed by the hardware" before I give up....



--==_Exmh_1184118159_3928P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGlDWPcC3lWbTT17ARAvFuAKDiC+Owl5gRLtUVhJfcpHIL8gOZsgCdG7ST
o4XgiGcB3Y5WAa09AE03BfI=
=zRgu
-----END PGP SIGNATURE-----

--==_Exmh_1184118159_3928P--
