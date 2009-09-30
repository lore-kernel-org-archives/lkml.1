Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZI3LXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZI3LXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 07:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZI3LXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 07:23:13 -0400
Received: from smtp4.ono.com ([62.42.230.177]:65070 "EHLO resmaa15.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753424AbZI3LXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 07:23:12 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2009 07:23:12 EDT
Date: Wed, 30 Sep 2009 13:17:26 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Missing MTRR ?
Message-ID: <20090930131726.2e5f6160@werewolf.home>
X-Mailer: Claws Mail 3.7.2cvs41 (GTK+ 2.18.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I'm using 2.6.31.1 on a box like this:
- Intel(R) Core(TM)2 CPU 6420  @ 2.13GHz (dual core)
- 4Gb RAM

I find that MTRR setup is this:
lorelei:/proc# cat mtrr
reg00: base=0x0cff00000 ( 3327MB), size=    1MB, count=1: uncachable
reg01: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: uncachable
reg02: base=0x0e0000000 ( 3584MB), size=  512MB, count=1: uncachable
reg03: base=0x0cfea6000 ( 3326MB), size=    4KB, count=1: write-back

I have no mtrr for my main memory, is this a problem for speed ?

dmesg:

BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
 BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cee2a000 (usable)
 BIOS-e820: 00000000cee2a000 - 00000000ceeb1000 (ACPI NVS)
 BIOS-e820: 00000000ceeb1000 - 00000000cfe00000 (usable)
 BIOS-e820: 00000000cfe00000 - 00000000cfe0d000 (reserved)
 BIOS-e820: 00000000cfe0d000 - 00000000cfe94000 (usable)
 BIOS-e820: 00000000cfe94000 - 00000000cfee9000 (ACPI NVS)
 BIOS-e820: 00000000cfee9000 - 00000000cfeec000 (usable)
 BIOS-e820: 00000000cfeec000 - 00000000cfef1000 (ACPI data)
 BIOS-e820: 00000000cfef1000 - 00000000cfef2000 (usable)
 BIOS-e820: 00000000cfef2000 - 00000000cfeff000 (ACPI data)
 BIOS-e820: 00000000cfeff000 - 00000000cff00000 (usable)
 BIOS-e820: 00000000cff00000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f8000000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
DMI 2.4 present.
last_pfn = 0x12c000 max_arch_pfn = 0x400000000
MTRR default type: write-back
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0CFF00000 mask FFFF00000 uncachable
  1 base 0D0000000 mask FF0000000 uncachable
  2 base 0E0000000 mask FE0000000 uncachable
  3 base 0CFEA6000 mask FFFFFF000 write-back
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xcff00 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000cff00000
 0000000000 - 00cfe00000 page 2M
 00cfe00000 - 00cff00000 page 4k
kernel direct mapping tables up to cff00000 @ 8000-e000
init_memory_mapping: 0000000100000000-000000012c000000
 0100000000 - 012c000000 page 2M
kernel direct mapping tables up to 12c000000 @ c000-12000
...
No NUMA configuration found
Faking a node at 0000000000000000-000000012c000000
Bootmem setup node 0 0000000000000000-000000012c000000
  NODE_DATA [0000000000001000 - 0000000000005fff]
  bootmap [000000000000d000 -  00000000000327ff] pages 26
(8 early reservations) ==> bootmem [0000000000 - 012c000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 0001873430]    TEXT DATA BSS ==> [0001000000 - 0001873430]
  #3 [0037c64000 - 0037fef32c]          RAMDISK ==> [0037c64000 - 0037fef32c]
  #4 [000009e000 - 0000100000]    BIOS reserved ==> [000009e000 - 0000100000]
  #5 [0001874000 - 000187415e]              BRK ==> [0001874000 - 000187415e]
  #6 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
  #7 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]
found SMP MP-table at [ffff8800000fe200] fe200
 [ffffea0000000000-ffffea00043fffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x0012c000
Movable zone start PFN for each node
early_node_map[8] active PFN ranges
    0: 0x00000000 -> 0x0000008f
    0: 0x00000100 -> 0x000cee2a
    0: 0x000ceeb1 -> 0x000cfe00
    0: 0x000cfe0d -> 0x000cfe94
    0: 0x000cfee9 -> 0x000cfeec
    0: 0x000cfef1 -> 0x000cfef2
    0: 0x000cfeff -> 0x000cff00
    0: 0x00100000 -> 0x0012c000
On node 0 totalpages: 1031572
  DMA zone: 56 pages used for memmap
  DMA zone: 106 pages reserved
  DMA zone: 3821 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 833085 pages, LIFO batch:31
  Normal zone: 2464 pages used for memmap
  Normal zone: 177760 pages, LIFO batch:31

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2010.0 (Cooker) for x86_64
Linux 2.6.29.3-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed May
