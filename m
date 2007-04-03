Return-Path: <linux-kernel-owner+w=401wt.eu-S1751121AbXDCDj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbXDCDj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 23:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXDCDj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 23:39:59 -0400
Received: from moa.IfA.Hawaii.Edu ([128.171.168.48]:35595 "EHLO
	moa.ifa.hawaii.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbXDCDjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 23:39:40 -0400
X-Greylist: delayed 1367 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2007 23:39:40 EDT
Date: Mon, 2 Apr 2007 17:21:35 -1000
From: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
To: linux-kernel@vger.kernel.org
Subject: difference between arcmsr (areca) 1.20.0X.13 & 2.6.20 in tree driver?
Message-ID: <20070403032135.GA13622@ifa.hawaii.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Has anyone else noticed this regression?

-J

--
----- Forwarded message from Joshua Hoblitt <jhoblitt@ifa.hawaii.edu> -----

=46rom: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
Date: Thu, 29 Mar 2007 16:38:20 -1000
To: erich@areca.com.tw
Subject: difference between 1.20.0X.13 & 2.6.20 in tree driver?

Hello,

I just attempted to upgrade a system from 2.6.17 (gentoo revision 8) w/
1.20.0X.13 to 2.6.20 (gentoo revision 4) with the in tree arcmsr driver.
On the 2.6.17 kernel there are 2 ~4TB partitions that are visible on
the system as /dev/sdb1 & /dev/sdc1.  When the system is booted with the
2.6.20 kernel /dev/sdc1 is gone and /dev/sdb1 is properly reported as a
4TB EFI partition but fsck rejects the the filesystem as corrupt.  Is
this a regression or has there been a fundamental change in the way
arcmsr represents the array to the block layer?

Here is the info on the RAID card:

    Controller Name     ARC-1170
    Firmware Version    V1.39 2005-12-13
    BOOT ROM Version    V1.39 2005-12-13
    Serial Number   Y605CAAVAR700117
    Unit Serial #   =20
    Main Processor  500MHz IOP331
    CPU ICache Size     32KBytes
    CPU DCache Size     32KBytes / Write Back
    System Memory   256MB / 333MHz

Any idea as to what's going on?

Thanks,

-J

--
Under 2.6.20:

Mar 29 15:41:05 ipp000 ARECA RAID ADAPTER4: FIRMWARE VERSION V1.39 2005-12-=
13
Mar 29 15:41:05 ipp000 scsi4 : Areca SATA Host Adapter RAID Controller( RAI=
D6 capable)
Mar 29 15:41:05 ipp000 Driver Version 1.20.00.13
Mar 29 15:41:05 ipp000 scsi 4:0:0:0: Direct-Access     Areca    ARC-1170-VO=
L#00  R001 PQ: 0 ANSI: 3
Mar 29 15:41:05 ipp000 sdb : very big device. try to use READ CAPACITY(16).
Mar 29 15:41:05 ipp000 SCSI device sdb: 8595693568 512-byte hdwr sectors (4=
400995 MB)=20
Mar 29 15:41:05 ipp000 sdb: Write Protect is off
Mar 29 15:41:05 ipp000 sdb: Mode Sense: cb 00 00 08
Mar 29 15:41:05 ipp000 SCSI device sdb: write cache: enabled, read cache: e=
nabled, doesn't support DPO or FUA=20
Mar 29 15:41:05 ipp000 sdb : very big device. try to use READ CAPACITY(16).=
=20
Mar 29 15:41:05 ipp000 SCSI device sdb: 8595693568 512-byte hdwr sectors (4=
400995 MB)
Mar 29 15:41:05 ipp000 sdb: Write Protect is off
Mar 29 15:41:05 ipp000 sdb: Mode Sense: cb 00 00 08
Mar 29 15:41:05 ipp000 SCSI device sdb: write cache: enabled, read cache: e=
nabled, doesn't support DPO or FUA
Mar 29 15:41:05 ipp000 sdb: sdb1
Mar 29 15:41:05 ipp000 sd 4:0:0:0: Attached scsi disk sdb
Mar 29 15:41:05 ipp000 scsi 4:0:16:0: Processor         Areca    RAID contr=
oller  R001 PQ: 0 ANSI: 0

Under 2.6.17:

Mar 29 15:45:11 ipp000 ARECA RAID ADAPTER0: 64BITS PCI BUS DMA ADDRESSING S=
UPPORTED
Mar 29 15:45:11 ipp000 ARECA RAID ADAPTER0: FIRMWARE VERSION V1.39 2005-12-=
13
Mar 29 15:45:11 ipp000 scsi4 : Areca SATA Host Adapter RAID Controller( RAI=
D6 capable)
Mar 29 15:45:11 ipp000 Driver Version 1.20.0X.13
Mar 29 15:45:11 ipp000 Vendor: Areca     Model: ARC-1170-VOL#00   Rev: R001
Mar 29 15:45:11 ipp000 Type:   Direct-Access                      ANSI SCSI=
 revision: 03
Mar 29 15:45:11 ipp000 sdb : very big device. try to use READ CAPACITY(16).
Mar 29 15:45:11 ipp000 SCSI device sdb: 8595693568 512-byte hdwr sectors (4=
400995 MB)
Mar 29 15:45:11 ipp000 sdb: Write Protect is off
Mar 29 15:45:11 ipp000 sdb: Mode Sense: cb 00 00 08
Mar 29 15:45:11 ipp000 SCSI device sdb: drive cache: write back
Mar 29 15:45:11 ipp000 sdb : very big device. try to use READ CAPACITY(16).
Mar 29 15:45:11 ipp000 SCSI device sdb: 8595693568 512-byte hdwr sectors (4=
400995 MB)
Mar 29 15:45:11 ipp000 sdb: Write Protect is off
Mar 29 15:45:11 ipp000 sdb: Mode Sense: cb 00 00 08
Mar 29 15:45:11 ipp000 SCSI device sdb: drive cache: write back
Mar 29 15:45:11 ipp000 sdb:<4>Alternate GPT is invalid, using primary GPT.
Mar 29 15:45:11 ipp000 sdb1
Mar 29 15:45:11 ipp000 sd 4:0:0:0: Attached scsi disk sdb
Mar 29 15:45:11 ipp000 sd 4:0:0:0: Attached scsi generic sg1 type 0
Mar 29 15:45:11 ipp000 Vendor: Areca     Model: ARC-1170-VOL#01   Rev: R001
Mar 29 15:45:11 ipp000 Type:   Direct-Access                      ANSI SCSI=
 revision: 03
Mar 29 15:45:11 ipp000 sdc : very big device. try to use READ CAPACITY(16).
Mar 29 15:45:11 ipp000 SCSI device sdc: 8595580928 512-byte hdwr sectors (4=
400937 MB)
Mar 29 15:45:11 ipp000 sdc: Write Protect is off
Mar 29 15:45:11 ipp000 sdc: Mode Sense: cb 00 00 08
Mar 29 15:45:11 ipp000 SCSI device sdc: drive cache: write back
Mar 29 15:45:11 ipp000 sdc : very big device. try to use READ CAPACITY(16).
Mar 29 15:45:11 ipp000 SCSI device sdc: 8595580928 512-byte hdwr sectors (4=
400937 MB)
Mar 29 15:45:11 ipp000 sdc: Write Protect is off
Mar 29 15:45:11 ipp000 sdc: Mode Sense: cb 00 00 08
Mar 29 15:45:11 ipp000 SCSI device sdc: drive cache: write back
Mar 29 15:45:11 ipp000 sdc: sdc1
Mar 29 15:45:11 ipp000 sd 4:0:0:1: Attached scsi disk sdc
Mar 29 15:45:11 ipp000 sd 4:0:0:1: Attached scsi generic sg2 type 0
Mar 29 15:45:11 ipp000 Vendor: Areca     Model: RAID controller   Rev: R001
Mar 29 15:45:11 ipp000 Type:   Processor                          ANSI SCSI=
 revision: 00
Mar 29 15:45:11 ipp000 4:0:16:0: Attached scsi generic sg3 type 3
Mar 29 15:45:11 ipp000 arcmsr device major number 254





----- End forwarded message -----

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGEcg/Wa2BU+b7tU0RAi7xAJ9gz5m2BpsgK1ZmMQpczlELc9GHJgCfWItg
08l7U6RHDoEotSBbtLlYf5k=
=zcji
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
