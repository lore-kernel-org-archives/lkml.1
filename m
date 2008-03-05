Return-Path: <linux-kernel-owner+w=401wt.eu-S1760730AbYCEJGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730AbYCEJGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 04:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYCEJGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 04:06:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:45879 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbYCEJGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 04:06:11 -0500
Date: Wed, 5 Mar 2008 10:06:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.25-rc3: 34TB vmalloc total -- overflow in /proc/meminfo?
Message-ID: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

leet:~ # uname -a
Linux leet 2.6.25-rc3 #189 SMP Mon Mar 3 13:16:59 CET 2008 x86_64
x86_64 x86_64
GNU/Linux
leet:~ #

32-bit distro on 64-bit kernel.

leet:~ # cat /proc/meminfo
MemTotal:      4055780 kB
MemFree:       3972400 kB
Buffers:          4892 kB
Cached:          29844 kB
SwapCached:          0 kB
Active:          23140 kB
Inactive:        20800 kB
SwapTotal:     2104472 kB
SwapFree:      2104472 kB
Dirty:            1300 kB
Writeback:           0 kB
AnonPages:        9152 kB
Mapped:           8684 kB
Slab:            18336 kB
SReclaimable:     7448 kB
SUnreclaim:      10888 kB
PageTables:        676 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   4132360 kB
Committed_AS:    27684 kB
VmallocTotal: 34359738367 kB
VmallocUsed:     18112 kB
VmallocChunk: 34359720115 kB
leet:~ # /etc/init.d/gpm start

Linux version 2.6.25-rc3 (pavel@amd) (gcc version 4.1.3 20071209
(prerelease) (Debian 4.1.2-18)) #189 SMP Mon Mar 3 13:16:59 CET 2008
Command line: root=/dev/sda2 vga=6    resume=/dev/sda1 splash=silent
nosmp no_console_suspend 3
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bfed0000 (usable)
 BIOS-e820: 00000000bfed0000 - 00000000bfee2000 (ACPI data)
 BIOS-e820: 00000000bfee2000 - 00000000bfeee000 (ACPI NVS)
 BIOS-e820: 00000000bfeee000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec03000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Entering add_active_range(0, 256, 786128) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 1310720) 2 entries of 3200 used
end_pfn_map = 1310720
DMI present.
ACPI: RSDP 000F8010, 0024 (r2 PTLTD )
ACPI: XSDT BFEDBF8C, 0064 (r1 BRCM   Anaheim   6040000 PTL   2000001)
ACPI: FACP BFEDC064, 00F4 (r3 BRCM   EXPLOSN   6040000 MSFT  2000001)
ACPI Warning (tbfadt-0442): Optional field "Pm2ControlBlock" has zero
address or length: 0000000000000000/C [20070126]
ACPI: DSDT BFEDC158, 4777 (r2 AMD    Anaheim   6040000 MSFT  2000002)
ACPI: FACS BFEEDFC0, 0040
ACPI: TCPA BFEE08CF, 0032 (r1 BRCM   Anaheim   6040000 PTL  20000001)
ACPI: SRAT BFEE0901, 0128 (r1 AMD    HAMMER    6040000 AMD         1)
ACPI: SSDT BFEE0A29, 143C (r1 AMD    POWERNOW  6040000 AMD         1)
ACPI: HPET BFEE1E65, 0038 (r1 BRCM   Anaheim   6040000 BRCM  2000001)
ACPI: SSDT BFEE1E9D, 0049 (r1 BRCM   PRT0      6040000 BRCM  2000001)
ACPI: SPCR BFEE1EE6, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
ACPI: APIC BFEE1F36, 00CA (r1 BRCM   Anaheim   6040000 PTL   2000001)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 0 -> APIC 2 -> Node 0
SRAT: PXM 0 -> APIC 3 -> Node 0
SRAT: PXM 1 -> APIC 4 -> Node 1
SRAT: PXM 1 -> APIC 5 -> Node 1
SRAT: PXM 1 -> APIC 6 -> Node 1
SRAT: PXM 1 -> APIC 7 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 157) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-c0000000
Entering add_active_range(0, 0, 157) 1 entries of 3200 used
Entering add_active_range(0, 256, 786128) 1 entries of 3200 used
SRAT: Node 0 PXM 0 0-140000000
Entering add_active_range(0, 0, 157) 2 entries of 3200 used
Entering add_active_range(0, 256, 786128) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 1310720) 2 entries of 3200 used
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000140000000
  NODE_DATA [000000000000e000 - 0000000000014fff]
  bootmap [0000000000015000


(If I try to suspend to disk, I get a rather nasty oops; goes away
with mem=3G. Related?)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
