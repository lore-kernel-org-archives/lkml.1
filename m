Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbXDAACH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbXDAACH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 20:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXDAACG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 20:02:06 -0400
Received: from mail.t-c-c.at ([82.150.200.3]:37537 "HELO mail.t-c-c.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752773AbXDAACF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 20:02:05 -0400
X-Greylist: delayed 1038 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Mar 2007 20:02:05 EDT
Message-ID: <460EF263.7020505@gmx.at>
Date: Sat, 31 Mar 2007 23:44:35 +0000
From: "Florian D." <flockmock@gmx.at>
User-Agent: Thunderbird 1.5.0.10 (X11/20070304)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: cannot add device to partitioned raid6 array
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi list!

in short:
I created a partitioned raid6 array with 2 missing drives. Now, I want to add a device. It fails with:
flockmock ~ # mdadm -a /dev/md_d4 /dev/sdb2
mdadm: add new device failed for /dev/sdb2 as 4: Invalid argument

I think it is the same problem as in:
http://marc.info/?l=linux-raid&m=115316147716600&w=2



details:
kernel 2.6.20.4
mdadm-2.6.1
the raid6 array:

flockmock ~ # mdadm --detail /dev/md_d4
/dev/md_d4:
         Version : 00.90.03
   Creation Time : Sat Mar 31 19:48:58 2007
      Raid Level : raid6
      Array Size : 490030464 (467.33 GiB 501.79 GB)
   Used Dev Size : 245015232 (233.66 GiB 250.90 GB)
    Raid Devices : 4
   Total Devices : 2
Preferred Minor : 4
     Persistence : Superblock is persistent

     Update Time : Sat Mar 31 23:28:37 2007
           State : clean, degraded
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

      Chunk Size : 32K

            UUID : dfb5e536:2447b984:b7699fd8:8ba37cbf
          Events : 0.2972

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       34        1      active sync   /dev/sdc2
        2       0        0        2      removed
        3       0        0        3      removed

the device, which I want to add:
flockmock ~ # mdadm -E /dev/sdb2
/dev/sdb2:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : dfb5e536:2447b984:b7699fd8:8ba37cbf
   Creation Time : Sat Mar 31 19:48:58 2007
      Raid Level : raid6
   Used Dev Size : 245015232 (233.66 GiB 250.90 GB)
      Array Size : 490030464 (467.33 GiB 501.79 GB)
    Raid Devices : 4
   Total Devices : 2
Preferred Minor : 4

     Update Time : Sat Mar 31 23:29:23 2007
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 2
   Spare Devices : 0
        Checksum : 8aeeef56 - correct
          Events : 0.2974

      Chunk Size : 32K

       Number   Major   Minor   RaidDevice State
this     4       8       18       -1      spare   /dev/sdb2

    0     0       8        2        0      active sync   /dev/sda2
    1     1       8       34        1      active sync   /dev/sdc2
    2     2       0        0        2      faulty removed
    3     3       0        0        3      faulty removed

dmesg shows such error mesgs:
[  220.681135] md: sdb2 has invalid sb, not importing!
[  220.681186] md: md_import_device returned -22
[  220.681435] md: sdb2 has invalid sb, not importing!
[  220.681463] md: md_import_device returned -22

any idea how to resolve this? thanks,
florian

PS: please cc me in replies, thanks.
