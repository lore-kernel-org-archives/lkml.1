Return-Path: <linux-kernel-owner+w=401wt.eu-S932537AbXIJJyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbXIJJyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbXIJJyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:54:14 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:22717 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745AbXIJJyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:54:12 -0400
X-IronPort-AV: i="4.20,230,1186372800"; 
   d="scan'208"; a="39247412:sNHT46517618"
Subject: Re: [PATCH try #2] Blackfin on-chip NAND Flash Controller driver
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: dedekind@infradead.org
Cc: bryan.wu@analog.com, David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1189144341.14370.77.camel@sauron>
References: <1188885450.7074.7.camel@roc-laptop>
	 <1189144341.14370.77.camel@sauron>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 10 Sep 2007 17:50:37 +0800
Message-Id: <1189417837.28956.9.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 10 Sep 2007 09:54:10.0338 (UTC) FILETIME=[890AE020:01C7F390]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-07 at 13:52 +0800, Artem Bityutskiy wrote:
> On Tue, 2007-09-04 at 13:57 +0800, Bryan Wu wrote: 
> > This is the driver for latest Blackfin on-chip nand flash
> controller 
> > 
> >  - use nand_chip and mtd_info common nand driver interface 
> >  - provide both PIO and dma operation 
> >  - compiled with ezkit bf548 configuration 
> >  - use hardware 1-bit ECC 
> >  - tested with YAFFS2 and can mount YAFFS2 filesystem as rootfs 
> > 
> > ChangeLog from try#1 
> >  - use hweight32() instead of count_bits() 
> >  - replace bf54x with bf5xx and BF54X with BF5XX 
> >  - compare against plat->page_size in 2 cases when enable hardware
> ECC 
> > 
> > Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> 
> Bryan,
> 
> I'd suggest you to test your NAND driver with the following NAND
> tests:
> 
> git://git.infradead.org/~ahunter/nand-tests.git
> 
> (http://git.infradead.org/?p=users/ahunter/nand-tests.git;a=summary)
> 

Thanks Artem, I got the code and did some test on my EZKIT548 with this
driver.

Here is the test log, only 2 errors in oobtest. After digging into the
mtd-nand driver code, it should be no relation to my bf5xx_nand driver.
Maybe somethings wrong in the mtd-nand code. I intend to get some help
from you, please see my test log below:

1. boot message:
---
Linux version 2.6.22.6-ADI-2007R2-pre-svn3643 (roc@roc-desktop) (gcc
version 4.1.2 (ADI svn)) #38 Mon Sep 10 17:35:51 CST 2007
Hardware Trace Active and Enabled
Blackfin support (C) 2004-2007 Analog Devices, Inc.
Compiled for ADSP-BF549 Rev 0.0
Blackfin Linux support by http://blackfin.uclinux.org/
Processor Speed: 525 MHz core clock and 131 Mhz System Clock
Board Memory: 64MB
Kernel Managed Memory: 64MB
Memory map:
  text      = 0x00001000-0x00117820
  rodata    = 0x00118000-0x001630dc
  data      = 0x00164000-0x00178000
    stack   = 0x00164000-0x00166000
  init      = 0x00178000-0x002c4c4d
  bss       = 0x002c4c50-0x002d4890
  available = 0x002d4890-0x03eff000
  DMA Zone  = 0x03f00000-0x04000000
Instruction Cache Enabled
Data Cache Enabled (write-through)
Built 1 zonelists.  Total pages: 16002
Kernel command line: root=/dev/mtdblock0 rw
ip=192.168.0.66:192.168.0.55:192.168.0.1:255.255.255.0:BF548:eth0:off
Configuring Blackfin Priority Driven Interrupts
PID hash table entries: 256 (order: 8, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Physical pages: 3eff
Memory available: 60968k/64112k RAM, (1331k init code, 1114k kernel
code, 63k data, 1024k dma)
Blackfin Scratchpad data SRAM: 4 KB
Blackfin Data A SRAM: 16 KB (15 KB free)
Blackfin Data B SRAM: 16 KB (16 KB free)
Blackfin Instruction SRAM: 48 KB (42 KB free)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
NET: Registered protocol family 16
Blackfin GPIO Controller
Blackfin DMA Controller
stamp_init(): registering device resources
SCSI subsystem initialized
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 2048 (order: 2, 16384 bytes)
TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 2048 bind 2048)
TCP reno registered
yaffs Sep 10 2007 15:04:46 Installing. 
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler cfq registered
Serial: Blackfin serial driver
bfin-uart.1: ttyBF0 at MMIO 0xffc02000 (irq = 48) is a BFIN-UART
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
BF5xx on-chip NAND FLash Controller Driver, Version 1.2 (c) 2007 Analog
Devices, Inc.
bf5xx-nand bf5xx-nand.0: page_size=256, data_width=8, wr_dly=3, rd_dly=3
NAND device: Manufacturer ID: 0x20, Chip ID: 0xda (ST Micro NAND 256MiB
3,3V 8-bit)
Creating 2 MTD partitions on "NAND 256MiB 3,3V 8-bit":
0x00000000-0x00400000 : "Linux Kernel"
mtd: Giving out device 0 to Linux Kernel
0x00400000-0x10000000 : "File System"
mtd: Giving out device 1 to File System
rtc-bfin rtc-bfin: rtc core: registered rtc-bfin as rtc0
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
rtc-bfin rtc-bfin: setting the system clock to 2004-06-25 05:06:29
(1088139989)
eth0: SMSC911x/921x identified at 0x24000000, IRQ: 175
eth0: SMSC911x MAC Address: 32:3b:f3:01:26:4a
eth0: link down
IP-Config: Complete:
      device=eth0, addr=192.168.0.66, mask=255.255.255.0,
gw=192.168.0.1,
     host=BF548, domain=, nis-domain=(none),
     bootserver=192.168.0.55, rootserver=192.168.0.55, rootpath=
Freeing unused kernel memory: 1331k freed
---

2. oobtest:
root:~> insmod oobtest.ko 

=========================================================================================
oobtest: dev = 0
oobtest: oob available per page = 38
oobtest: scanning for bad blocks
oobtest: scanned 0
oobtest: Block 5 is bad
oobtest: Block 27 is bad
oobtest: scanned 32
oobtest: Test 1 of 5
oobtest: erasing
oobtest: erased 0
oobtest: erased 32
oobtest: writing
oobtest: written 0
oobtest: written 32
oobtest: verifying
oobtest: verified 0
oobtest: verified 32
oobtest: Test 2 of 5
oobtest: erasing
oobtest: erased 0
oobtest: erased 32
oobtest: writing
oobtest: written 0
oobtest: written 32
oobtest: verifying
oobtest: verified 0
oobtest: verified 32
oobtest: Test 3 of 5
oobtest: erasing
oobtest: erased 0
oobtest: erased 32
oobtest: writing
oobtest: written 0
oobtest: written 32
oobtest: verifying
oobtest: verified 0
oobtest: verified 32
oobtest: Test 4 of 5
oobtest: erasing
oobtest: erased 0
oobtest: erased 32
oobtest: Attempting to start write past end of oob
oobtest: An error is expected...
nand_write_oob: Attempt to write past end of page
oobtest: Error occurred as expected
oobtest: Attempting to start read past end of oob
oobtest: An error is expected...
nand_read_oob: Attempt to start read outside oob
oobtest: Error occurred as expected
oobtest: Attempting to write past end of device
oobtest: An error is expected...
nand_write_oob: Attempt to write past end of page
oobtest: Error occurred as expected
oobtest: Attempting to read past end of device
oobtest: An error is expected...
oobtest: error: read past end of device
oobtest: Attempting to write past end of device
oobtest: An error is expected...
nand_write_oob: Attempt to write past end of page
oobtest: Error occurred as expected
oobtest: Attempting to read past end of device
oobtest: An error is expected...
oobtest: error: read past end of device
oobtest: Test 5 of 5
oobtest: erasing
oobtest: erased 0
oobtest: erased 32
oobtest: writing
oobtest: written 0
oobtest: written 0
oobtest: written 31
oobtest: verifying
oobtest: verified 0
oobtest: verified 31
oobtest: oobtest finished with 2 errors
=========================================================================================

3. pagetest
root:~> insmod pagetest.ko 

=========================================================================================
pagetest: dev = 0
pagetest: scanning for bad blocks
pagetest: scanned 0
pagetest: Block 5 is bad
pagetest: Block 27 is bad
pagetest: scanned 32
pagetest: erasing
pagetest: erased 0
pagetest: erased 32
pagetest: writing
pagetest: written 0
pagetest: written 32
pagetest: verifying
pagetest: verified 0
pagetest: verified 32
pagetest: crosstest
pagetest: reading page at 0x00000000
pagetest: reading page at 0x003ff800
pagetest: reading page at 0x00000000
pagetest: verifying pages read at 0x00000000 match
pagetest: crosstest ok
pagetest: erasecrosstest
pagetest: erasing block 0
pagetest: writing 1st page of block 0
pagetest: reading 1st page of block 0
pagetest: verifying 1st page of block 0
pagetest: erasing block 0
pagetest: writing 1st page of block 0
pagetest: erasing block 31
pagetest: reading 1st page of block 0
pagetest: verifying 1st page of block 0
pagetest: erasecrosstest ok
pagetest: erasetest
pagetest: erasing block 0
pagetest: writing 1st page of block 0
pagetest: erasing block 0
pagetest: reading 1st page of block 0
pagetest: verifying 1st page of block 0 is all 0xff
pagetest: erasetest ok
pagetest: pagetest finished with 0 errors
=========================================================================================

4. subpagetest

root:~> insmod subpagetest.ko 

=========================================================================================
subpagetest: dev = 0
sub-page size is: 512
subpagetest: scanning for bad blocks
subpagetest: scanned 0
subpagetest: Block 5 is bad
subpagetest: Block 27 is bad
subpagetest: scanned 32
subpagetest: erasing
subpagetest: erased 0
subpagetest: erased 32
subpagetest: writing
subpagetest: written 0
subpagetest: written 32
subpagetest: verifying
subpagetest: verified 0
subpagetest: verified 32
subpagetest: erasing
subpagetest: erased 0
subpagetest: erased 32
subpagetest: verifying 0xff
subpagetest: verified 0
subpagetest: verified 32
subpagetest: writing
subpagetest: written 0
subpagetest: written 32
subpagetest: verifying
subpagetest: verified 0
subpagetest: verified 32
subpagetest: erasing
subpagetest: erased 0
subpagetest: erased 32
subpagetest: verifying 0xff
subpagetest: verified 0
subpagetest: verified 32
subpagetest: subpagetest finished with 0 errors
=========================================================================================

> You may want to avoid the torture test, but it is useful to run it
> with 
> limited amount of erase cycles to make sure your flash/driver
> survives 
> really high I/O load.For example, we caught occasional DMA transfer 
> problems while running the torture test for few days.
> 
I plan to do the torture test after this oobtest passed. And this
nand_test suites are intended to integrated into our Blackfin
uClinux-dist testsuites.

Thanks a lot
Best Regards,
- Bryan Wu
