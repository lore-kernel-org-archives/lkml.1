Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbXJ3UXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbXJ3UXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757253AbXJ3UX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:23:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52488 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbXJ3UX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:23:27 -0400
Message-ID: <472792CC.7090009@anagramm.de>
Date: Tue, 30 Oct 2007 21:23:40 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: saeed bishara <saeed.bishara@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: system stops sending IOs for long time
References: <c70ff3ad0710300959t2bb5f1ebp7abb51992738a08c@mail.gmail.com>
In-Reply-To: <c70ff3ad0710300959t2bb5f1ebp7abb51992738a08c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX18u7N75VMHjy08ua4ZCMXSA4opEamVMs9R0XEY
 yNCUZDezpQyk/MqPfaR4GD2Fj2d+OHMJhlVg/2/uyXNrGb2B1l
 aHVW+T6UfkgHINZR+YaaQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

saeed bishara schrieb:
 > Hi,
 > I have a performance issue with my system that runs samba server, once
 > in a while (6 seconds) I see that the throughput falls almost to to
 > zero when doing read for large file. I'm running kernel 2.6.22.10. I
 > don't see this issue when using kernel 2.6.12.
 >
 > when observing the activity leds on my sata controller, I see that it
 > get off for about 1 second meaning no commands sent to the HDD for
 > that long time. I used the blktrace in order to have a look into the
 > IOs, and found that the system really stops sending commands for long
 > periods, here is the section of the blkparse that shows this problem:
 >   8,2    0    12747     5.550000000   328  D   R 108068834 + 512 [smbd]
 >   8,2    0    12748     5.550000000   328  D   R 108069346 + 512 [smbd]
 >   8,2    0    12749     5.550000000   328  D   R 108069858 + 512 [smbd]
 >   8,2    0    12750     5.550000000   328  D   R 108070370 + 512 [smbd]
 >   8,2    0    12751     5.550000000   328  U   N [smbd] 5
 >   8,2    0    12752     5.550000000     0  C   R 108068834 + 512 [0]
 >   8,2    0    12753     5.560000000     0  C   R 108069346 + 512 [0]
 >   8,2    0    12754     5.570000000     0  C   R 108069858 + 512 [0]
 >   8,2    0    12755     5.570000000     0  C   R 108070370 + 512 [0]
 >   8,2    0    12756     6.570000000     0  C   R 108066786 + 512 [0]
 >   8,2    0    12757     6.590000000   328  Q   R 108070882 + 8 [smbd]
 >   8,2    0    12758     6.590000000   328  G   R 108070882 + 8 [smbd]
 >   8,2    0    12759     6.590000000   328  P   N [smbd]
 >   8,2    0    12760     6.590000000   328  I   R 108070882 + 8 [smbd]
 >   8,2    0    12761     6.590000000   328  Q   R 108070890 + 8 [smbd]
 >   8,2    0    12762     6.590000000   328  M   R 108070890 + 8 [smbd]
 >
 > any idea how to fix this issue?


Not really.

I've had a similar looking problem with a md raid-1 set of harddisks
running 2.6.18. md0_raid1 took every 10 seconds all of the cpu blocking other
stuff on the machine for some other 2 secons doing no disk writes.

$ uname -a
Linux rio 2.6.22.9 #1 Mon Oct 1 19:48:54 CEST 2007 i686 pentium3 i386 GNU/Linux

$ lspci
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 03)
00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 03)
00:04.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
00:04.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
00:04.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
00:04.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
00:0a.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
00:0b.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 50)
00:0b.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 50)
00:0b.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 51)
00:0c.0 Mass storage controller: Promise Technology, Inc. 20269 (rev 02)
01:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G100 [Productiva] AGP (rev 01)

The raid is on the Promise PDC20269

$ mdadm --misc --detail /dev/md0
/dev/md0:
         Version : 00.90.03
   Creation Time : Sat Oct 29 20:51:41 2005
      Raid Level : raid1
      Array Size : 293049600 (279.47 GiB 300.08 GB)
   Used Dev Size : 293049600 (279.47 GiB 300.08 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Tue Oct 30 19:20:12 2007
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            UUID : b2d7f60d:008fa0df:136207f1:ae0e7a9e
          Events : 0.432306

     Number   Major   Minor   RaidDevice State
        0      33        1        0      active sync   /dev/hde1
        1      34        1        1      active sync   /dev/hdg1

I didn't dare to report a bug against the old kernel. I moved to
2.6.22.9 and the problem disappeared...
Any ways to debug that (non-intrusive on a production machine)?

Regards,

Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com

