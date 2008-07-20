Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbYGTTHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbYGTTHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 15:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYGTTHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 15:07:47 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:45238 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbYGTTHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 15:07:46 -0400
X-Greylist: delayed 1912 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2008 15:07:46 EDT
Message-ID: <48838593.8020007@dolphinics.no>
Date: Sun, 20 Jul 2008 20:36:03 +0200
From: Simen Timian Thoresen <simentt@dolphinics.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Simen Thoresen <simentt@dolphinics.no>
Subject: Misidentification and failing revalidations of ide dvd-roms with
 libata
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have a curious issue on an NForce4, x86_64 system. After reinstalling 
it with a new distro (Ubuntu 8.04-based MythBuntu 8 - 2.6.24-19-generic, 
i686), I am experiencing failing revalidations of my IDE DVD-rom drives;

[  152.874745] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
frozen
[  152.874753] ata4.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 
pio 8 in
[  152.874754]          cdb 4a 01 00 00 10 00 00 00  08 00 00 00 00 00 00 00
[  152.874755]          res 68/00:01:00:08:00/00:00:00:00:00/a0 Emask 
0x2 (HSM violation)
[  152.874758] ata4.00: status: { DRDY DF DRQ }
[  152.874775] ata4: soft resetting link
[  153.124616] ata4.00: model number mismatch 'Pioneer DVD-ROM 
ATAPIModel DVD-116  0109' != 'Pioïeer¡DVD­ROM¡ATAñIMoåel åVD-±16 ¡010¹'
[  153.124621] ata4.00: revalidation failed (errno=-19)
[  153.124624] ata4: failed to recover some devices, retrying in 5 secs
[  155.206856] ata4: soft resetting link
[  155.457098] ata4.00: model number mismatch 'Pioneer DVD-ROM 
ATAPIModel DVD-116  0109' != 'Pioïeer¡DVD­ROM¡ATAñIMoåel åVD-±16 ¡010¹'
[  155.457103] ata4.00: revalidation failed (errno=-19)
[  155.457106] ata4.00: disabled
[  155.666359] ata4: soft resetting link
[  155.916202] ata4.00: ATAPI: Pioïeer¡DVD­ROM¡ATAñIMoåel åVD-±16 ¡010¹, 
E1.±9  ¡, max UDMA7
[  155.919834] ata4.00: failed to set xfermode (err_mask=0x1)
[  155.919837] ata4: failed to recover some devices, retrying in 5 secs
[  158.002170] ata4: soft resetting link
[  158.255648] ata4.00: failed to set xfermode (err_mask=0x1)
[  158.255653] ata4.00: limiting speed to UDMA/100:PIO3
[  158.255655] ata4: failed to recover some devices, retrying in 5 secs
[  160.338395] ata4: soft resetting link
[  160.591046] ata4.00: failed to set xfermode (err_mask=0x1)
[  160.591050] ata4.00: disabled
[  160.800818] sr 3:0:0:0: rejecting I/O to offline device
[  160.800827] ata4: EH complete
[  160.801023] ata4.00: detaching (SCSI 3:0:0:0)
[  160.801192] scsi 3:0:0:0: rejecting I/O to dead device
[  160.801205] scsi 3:0:0:0: rejecting I/O to dead device
[  160.801208] scsi 3:0:0:0: rejecting I/O to dead device

As I understand, this would most commonly indicate that the drive has 
gone bad, but this also occurs on the /other/ drive (same make/model) in 
the system. Also, it occurs on one of them, and then so far not on the 
other (until I reboot the system). This has only occurred while the 
drives have been in use (ripping audio-CDs), and seems to occur fairly 
quickly when a drive is in use (during the first few CDs). If only one 
drive is in use, it will still fail.

This behaviour was never seen on the previous distro, CentOS4, 
2.6.9-something). On this system, the drives were accessed as /dev/hda 
and /dev/hdc

Also, I notice that the kernel inconsistently identifies the capabilites 
of the drives;
[   24.048722] Driver 'sr' needs updating - please use bus_type methods
[   24.053214] sr0: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
[   24.053220] Uniform CD-ROM driver Revision: 3.20
[   24.053268] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   24.081327] sr1: scsi3-mmc drive: 12x/40x cd/rw xa/form2 cdda tray
[   24.081379] sr 3:0:0:0: Attached scsi CD-ROM sr1

Here, the speed-ratings are inconsistent. Both drives are same 
make/model, and the speed-rating is either seen as 40x/40x, 12x/40x or 
125x/40x. These vary, seemingly at random, between boots. I believe I've 
never seen one of them /not/ be 40x/40x. It is possible that the one 
that is not 40x/40x is the one that fails, but I'm in no way certain 
about this.

I'm not sure what to make of this, as this is my first system that uses 
libata for ATAPI-devices like these.

The drives themselves are identified correctly.

[   18.452227] ata3.00: ATAPI: Pioneer DVD-ROM ATAPIModel DVD-116  0109, 
E1.09, max UDMA/66
[   18.623964] ata3.00: configured for UDMA/66
[   19.221877] ata4.00: ATAPI: Pioneer DVD-ROM ATAPIModel DVD-116  0109, 
E1.09, max UDMA/66
[   19.393614] ata4.00: configured for UDMA/66
[   19.395336] scsi 2:0:0:0: CD-ROM            PIONEER  DVD-ROM DVD-116 
  1.09 PQ: 0 ANSI: 5
[   19.395413] scsi 2:0:0:0: Attached scsi generic sg2 type 5
[   19.396657] scsi 3:0:0:0: CD-ROM            PIONEER  DVD-ROM DVD-116 
  1.09 PQ: 0 ANSI: 5
[   19.396702] scsi 3:0:0:0: Attached scsi generic sg3 type 5


Yours,
-S
-- 
Simen Thoresen, Dolphin ICS
Systems Administration and Wulfkit Support

