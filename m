Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbYKJHlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbYKJHlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYKJHlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:41:13 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:43885 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYKJHlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:41:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i2r2Sd+RjVniHXdpm79aGxIFpnz5AVIG127JFUvmPPX4RNU2G0xwR72LYVxfpmDcAa
         o3jRGw/YAuLaN2jYZISe/goW5tTNxIem7sc5tyyTtMX55QkHQNR0vA97Lc6cvCqX3oFJ
         OqdeBrlhYdgzQDGYOYSREV1cLOyPTM/108vNs=
Message-ID: <804dabb00811092341i40741745kb915215cc9356e25@mail.gmail.com>
Date: Mon, 10 Nov 2008 15:41:10 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Keith Owens" <kaos@ocs.com.au>
Subject: Re: USB HDD or filesystem bugs?
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1910.1225960244@ocs10w>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <804dabb00811060027j505d155egf4092864d9b44847@mail.gmail.com>
	 <1910.1225960244@ocs10w>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2008 at 4:30 PM, Keith Owens <kaos@ocs.com.au> wrote:
> "Peter Teoh" (on Thu, 6 Nov 2008 16:27:14 +0800) wrote:
>>Aborting journal on device sdi1.
>>Buffer I/O error on device sdi1, logical block 1544
>>lost page write due to I/O error on sdi1
>>journal_bmap: journal block not found at offset 20 on sdh3
>
> To rule out filesystem corruption, as root do 'umount /dev/sdi1' then
> run 'badblocks /dev/sdi1'.  badblocks will find any real I/O problems,
> if there are none then you have a corrupt fs.
>
>

thank you Keith, I just check all my harddisk and there is no
badblocks (nothing is returned after the badblocks complete)

I mounted the two harddisk on a different machine (running linus git's
latest rc version) does not gave error as well.

But coming back to the same original hardware gave error again:

/mnt/download/tmp>df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb1             38456308  33415180   3087628  92% /
udev                   1541888       212   1541676   1% /dev
/dev/hdc1             96132940  65644452  25605132  72% /hdc1
/dev/hdc2             96132968  47080232  44169380  52% /hdc2
/dev/sda1             83222548   5558748  73469632   8% /mnt/test3
/dev/sda3             77507676  12215840  61385632  17% /sda3
/dev/sda3             77507676  12215840  61385632  17% /media/disk
/dev/sdd1             38456308  29907992   6594816  82% /media/disk-2
/dev/sdd2             38456340  29737232   6765604  82% /media/disk-3
/dev/sde4             40631988  28381852  10152852  74% /media/_1
/dev/sde5             14659280  14656544      2736 100% /media/disk-4
/dev/sde2             38448304  29995736   6499468  83% /media/disk-5
/dev/sde1             39381744  11281468  26099784  31% /media/disk-6
/dev/sdf2             38456340  29737232   6765604  82% /media/disk-1
/dev/sdf3             76904380  28664160  44333616  40% /media/disk-7
/dev/sdf1             38456308  29907992   6594816  82% /media/disk-8
/dev/sdg1             39381744  11281468  26099784  31% /media/disk-9
/dev/sdg2             38448304  29995736   6499468  83% /media/disk-10
/dev/sdg4             40631988  28381852  10152852  74% /media/_1_
/dev/sdg5             14659280  14656544      2736 100% /media/disk-11


Noticed how the disk mounted duplicated each other:

/mnt/download/tmp>d /media/disk-11
fffff.txt  ./  vmware/  ../
/mnt/download/tmp>d /media/disk-4
fffff.txt  ./  vmware/  ../
/mnt/download/tmp>

The spurious remounting is recorded in the dmesg output:

/mnt/download/tmp>dmesg |tail -100
scsi 6:0:0:0: rejecting I/O to dead device
Buffer I/O error on device sdd3, logical block 1545
lost page write due to I/O error on sdd3
scsi 6:0:0:0: rejecting I/O to dead device
Buffer I/O error on device sdd3, logical block 1545
lost page write due to I/O error on sdd3
scsi 6:0:0:0: rejecting I/O to dead device
Buffer I/O error on device sdd3, logical block 0
lost page write due to I/O error on sdd3
hub 2-0:1.0: over-current change on port 8
hub 2-0:1.0: over-current change on port 7
hub 2-0:1.0: over-current change on port 8
usb 2-5: new high speed USB device using ehci_hcd and address 5
usb 2-5: new device found, idVendor=0d49, idProduct=7350
usb 2-5: new device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-5: Product: OneTouch
usb 2-5: Manufacturer: Maxtor
usb 2-5: SerialNumber: 2HAPXD2T
usb 2-5: configuration #1 chosen from 1 choice
scsi8 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 5
usb-storage: waiting for device to settle before scanning
  Vendor: Maxtor    Model: OneTouch          Rev: 0125
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sdf: 625142448 512-byte hdwr sectors (320073 MB)
sdf: Write Protect is off
sdf: Mode Sense: 2d 08 00 00
sdf: assuming drive cache: write through
SCSI device sdf: 625142448 512-byte hdwr sectors (320073 MB)
sdf: Write Protect is off
sdf: Mode Sense: 2d 08 00 00
sdf: assuming drive cache: write through
 sdf: sdf1 sdf2 sdf3
sd 8:0:0:0: Attached scsi disk sdf
sd 8:0:0:0: Attached scsi generic sg3 type 0
usb-storage: device scan complete
(fs/jbd/recovery.c, 255): journal_recover: JBD: recovery, exit status
0, recovered transactions 4560 to 4561
(fs/jbd/recovery.c, 257): journal_recover: JBD: Replayed 39 and
revoked 0/0 blocks
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdf2, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
(fs/jbd/recovery.c, 255): journal_recover: JBD: recovery, exit status
0, recovered transactions 732 to 733
(fs/jbd/recovery.c, 257): journal_recover: JBD: Replayed 14 and
revoked 0/0 blocks
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdf3, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
(fs/jbd/recovery.c, 255): journal_recover: JBD: recovery, exit status
0, recovered transactions 3832 to 3833
(fs/jbd/recovery.c, 257): journal_recover: JBD: Replayed 14 and
revoked 0/0 blocks
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdf1, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
usb 2-6: new high speed USB device using ehci_hcd and address 6
usb 2-6: new device found, idVendor=1058, idProduct=1010
usb 2-6: new device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-6: Product: External HDD
usb 2-6: Manufacturer: Western Digital
usb 2-6: SerialNumber: 575845383037353330303332
usb 2-6: configuration #1 chosen from 1 choice
scsi9 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
  Vendor: WD        Model: 1600BEAExternal   Rev: 1.02
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sdg: 312581808 512-byte hdwr sectors (160042 MB)
sdg: Write Protect is off
sdg: Mode Sense: 00 00 00 00
sdg: assuming drive cache: write through
SCSI device sdg: 312581808 512-byte hdwr sectors (160042 MB)
sdg: Write Protect is off
sdg: Mode Sense: 00 00 00 00
sdg: assuming drive cache: write through
 sdg: sdg1 sdg2 sdg3 < sdg5 > sdg4
sd 9:0:0:0: Attached scsi disk sdg
sd 9:0:0:0: Attached scsi generic sg4 type 0
usb-storage: device scan complete
(fs/jbd/recovery.c, 255): journal_recover: JBD: recovery, exit status
0, recovered transactions 1134 to 1135
(fs/jbd/recovery.c, 257): journal_recover: JBD: Replayed 4 and revoked
0/0 blocks
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sdg1, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
(fs/jbd/recovery.c, 255): journal_recover: JBD: recovery, exit status
0, recovered transactions 30883 to 30884
(fs/jbd/recovery.c, 257): journal_recover: JBD: Replayed 9 and revoked
0/0 blocks
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sdg2, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
(fs/jbd/recovery.c, 255): journal_recover: JBD: recovery, exit status
0, recovered transactions 11165 to 11166
(fs/jbd/recovery.c, 257): journal_recover: JBD: Replayed 20 and
revoked 0/0 blocks
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdg4, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
NTFS volume version 3.1.
NTFS-fs error (device sdg5): load_system_files(): Volume is dirty.
Mounting read-only.  Run chkdsk and mount in Windows.

So.....I suspect it to be hardware error?  (since it does not happened
on other machine)

-- 
Regards,
Peter Teoh
