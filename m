Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbYI2X5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbYI2X5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYI2X5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:57:38 -0400
Received: from smtp2.ono.com ([62.42.230.20]:24526 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751713AbYI2X5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:57:37 -0400
Date: Tue, 30 Sep 2008 01:57:33 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Strange mtrrs in Aspire One
Message-ID: <20080930015733.5c6ea984@werewolf.home>
X-Mailer: Claws Mail 3.5.0cvs138 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

My aspire one is giving some strange MTRR settings with rc7-git5 (and
prevous kernels, but that is what I run now...):

one:~> cat /proc/mtrr
reg00: base=0xfffe0000 (4095MB), size= 128KB: write-protect, count=1
reg01: base=0xfffc0000 (4095MB), size= 128KB: uncachable, count=1
reg02: base=0x00000000 (   0MB), size= 256MB: write-back, count=1
reg03: base=0x10000000 ( 256MB), size= 256MB: write-back, count=1
reg04: base=0x1f800000 ( 504MB), size=   8MB: uncachable, count=1
reg05: base=0x1f600000 ( 502MB), size=   2MB: uncachable, count=1
reg06: base=0x1f500000 ( 501MB), size=   1MB: uncachable, count=1
reg07: base=0x00000000 (   0MB), size= 128KB: uncachable, count=1

Therefor, intel x11 driver can not set its own MTRRs, no space left.

For example, could not this two

reg02: base=0x00000000 (   0MB), size= 256MB: write-back, count=1
reg03: base=0x10000000 ( 256MB), size= 256MB: write-back, count=1

in one

reg02: base=0x00000000 (   0MB), size= 512MB: write-back, count=1

??

And some people (google :)) say that this:

reg04: base=0x1f800000 ( 504MB), size=   8MB: uncachable, count=1

is a failed attempt to set up video memory.
(http://bbs.archlinux.org/viewtopic.php?pid=412972)

Add what are these ?

reg05: base=0x1f600000 ( 502MB), size=   2MB: uncachable, count=1
reg06: base=0x1f500000 ( 501MB), size=   1MB: uncachable, count=1

And, btw, could MTRR display be ordered by base address ? This would make
things much clear to understand...:

one:~> cat /proc/mtrr | cut -d' ' -f2- | sort
base=0x00000000 (   0MB), size= 128KB: uncachable, count=1
base=0x00000000 (   0MB), size= 256MB: write-back, count=1
base=0x10000000 ( 256MB), size= 256MB: write-back, count=1
base=0x1f500000 ( 501MB), size=   1MB: uncachable, count=1
base=0x1f600000 ( 502MB), size=   2MB: uncachable, count=1
base=0x1f800000 ( 504MB), size=   8MB: uncachable, count=1
base=0xfffc0000 (4095MB), size= 128KB: uncachable, count=1
base=0xfffe0000 (4095MB), size= 128KB: write-protect, count=1

TIA.

dmesg:

Linux version 2.6.27-desktop-0.rc7.5.1mnb
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001f376000 (usable)
 BIOS-e820: 000000001f376000 - 000000001f3bf000 (reserved)
 BIOS-e820: 000000001f3bf000 - 000000001f46d000 (usable)
 BIOS-e820: 000000001f46d000 - 000000001f4bf000 (ACPI NVS)
 BIOS-e820: 000000001f4bf000 - 000000001f4f0000 (usable)
 BIOS-e820: 000000001f4f0000 - 000000001f4ff000 (ACPI data)
 BIOS-e820: 000000001f4ff000 - 000000001f500000 (usable)
 BIOS-e820: 000000001f500000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
last_pfn = 0x1f500 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 1f500000 @ 7000-d000
RAMDISK: 1f099000 - 1f365ea7
...
0MB HIGHMEM available.
501MB LOWMEM available.
  mapped low ram: 0 - 1f500000
  low ram: 00000000 - 1f500000
  bootmap 00002000 - 00005ea0
(9 early reservations) ==> bootmem [0000000000 - 001f500000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 0000590800]    TEXT DATA BSS ==> [0000100000 - 0000590800]
  #4 [001f099000 - 001f365ea7]          RAMDISK ==> [001f099000 - 001f365ea7]
  #5 [0000591000 - 0000594000]    INIT_PG_TABLE ==> [0000591000 - 0000594000]
  #6 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #7 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #8 [0000002000 - 0000006000]          BOOTMAP ==> [0000002000 - 0000006000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x0001f500
  HighMem  0x0001f500 -> 0x0001f500
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0001f376
    0: 0x0001f3bf -> 0x0001f46d
    0: 0x0001f4bf -> 0x0001f4f0
    0: 0x0001f4ff -> 0x0001f500
On node 0 totalpages: 127989
free_area_init_node: node 0, pgdat c049a000, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 123020 pages, LIFO batch:31

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
