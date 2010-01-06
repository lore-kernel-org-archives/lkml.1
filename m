Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608Ab0AFJhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0AFJhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 04:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877Ab0AFJhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 04:37:32 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:64696 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab0AFJhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 04:37:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=H5RiB3ErNO6n2bcceOoPUBojRo678vx9L/mO+lxbeQ1qkLYgHFZ2ZTsQYM2Hmbfe+C
         fZYYpgsGKuxSATJGCTzVZk/nj40KpJt+xtmQGygIZt+8M3lln1uDseyzqHDEJnoojQaq
         JSfxAee5L6Fm4d+7y/VdWCvw8aXyf4oFhXioY=
MIME-Version: 1.0
Date: Wed, 6 Jan 2010 10:37:29 +0100
Message-ID: <64bb37e1001060137h597322e8s4305b7cc1c91527e@mail.gmail.com>
Subject: New MSI support in sata_sil24 still broken in 2.6.33-rc3
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vivek Mahajan <vivek.mahajan@freescale.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After activating the MSI support by adding sata_sil24.msi=1 to the
kernel command line, the first write to a drive attached to the SiI
3132 controller results in the following errors:

[  138.950074] ata2.00: exception Emask 0x0 SAct 0xf SErr 0x0 action 0x6 frozen
[  138.961023] ata2.00: failed command: WRITE FPDMA QUEUED
[  138.970034] ata2.00: cmd 61/00:00:a5:95:4a/04:00:01:00:00/40 tag 0
ncq 524288 out
[  138.970037]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  138.992467] ata2.00: status: { DRDY }
[  138.999864] ata2.00: failed command: WRITE FPDMA QUEUED
[  139.008830] ata2.00: cmd 61/00:08:a5:91:4a/04:00:01:00:00/40 tag 1
ncq 524288 out
[  139.008833]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  139.031370] ata2.00: status: { DRDY }
[  139.038906] ata2.00: failed command: WRITE FPDMA QUEUED
[  139.048055] ata2.00: cmd 61/00:10:a5:8d:4a/04:00:01:00:00/40 tag 2
ncq 524288 out
[  139.048058]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  139.070828] ata2.00: status: { DRDY }
[  139.078383] ata2.00: failed command: WRITE FPDMA QUEUED
[  139.087506] ata2.00: cmd 61/00:18:a5:99:4a/04:00:01:00:00/40 tag 3
ncq 524288 out
[  139.087509]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  139.110281] ata2.00: status: { DRDY }
[  139.117877] ata2: hard resetting link
[  141.310057] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  146.310037] ata2.00: qc timeout (cmd 0xec)
[  146.318032] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  146.328027] ata2.00: revalidation failed (errno=-5)
[  146.336815] ata2: hard resetting link
[  148.530055] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  158.530035] ata2.00: qc timeout (cmd 0xec)
[  158.538066] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  158.548122] ata2.00: revalidation failed (errno=-5)
[  158.556955] ata2: limiting SATA link speed to 1.5 Gbps
[  158.566052] ata2: hard resetting link
[  160.760071] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  190.760046] ata2.00: qc timeout (cmd 0xec)
[  190.768137] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  190.778219] ata2.00: revalidation failed (errno=-5)
[  190.787085] ata2.00: disabled
[  190.794002] ata2.00: device reported invalid CHS sector 0
[  190.803368] ata2.00: device reported invalid CHS sector 0
[  190.812704] ata2.00: device reported invalid CHS sector 0
[  190.821965] ata2.00: device reported invalid CHS sector 0
[  190.831231] ata2: hard resetting link
[  193.030050] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  193.030073] ata2: EH complete
[  193.030112] sd 1:0:0:0: [sdb] Unhandled error code
[  193.030120] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  193.030127] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 4a 99 a5 00 04 00 00
[  193.030141] end_request: I/O error, dev sdb, sector 21666213
[  193.039854] sd 1:0:0:0: [sdb] Unhandled error code
[  193.039857] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  193.039862] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 4a 8d a5 00 04 00 00
[  193.039874] end_request: I/O error, dev sdb, sector 21663141
[  193.040083] sd 1:0:0:0: [sdb] Unhandled error code

This repeats for a large number of times, then the XFS filesystem gets
shut down.

More information about my system are in my first report:
http://lkml.org/lkml/2009/12/19/82

lspci -vv for both the normal, working and the broken MSI case are in
my second try to report this:
http://lkml.org/lkml/2009/12/25/12

Please ask, if you need more information.

Torsten
