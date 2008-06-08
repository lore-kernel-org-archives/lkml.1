Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbYFHB0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbYFHB0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 21:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbYFHB0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 21:26:21 -0400
Received: from wsip-70-184-212-2.om.om.cox.net ([70.184.212.2]:38944 "EHLO
	hachi.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbYFHB0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 21:26:19 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jun 2008 21:26:19 EDT
From: Luke -Jr <luke@dashjr.org>
Organization: -Jr Family
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: bcm33xx port
Date: Sat, 7 Jun 2008 20:19:38 -0500
User-Agent: KMail/1.9.9
PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
Jabber-ID: luke@dashjr.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_uOzSIX8iAFi1DAh"
Message-Id: <200806072019.42108.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_uOzSIX8iAFi1DAh
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I am working on a port for the bcm33xx platform, which includes a MIPS CPU:
	http://wiki.openwrt.org/BroadcomBCM33xxPort

However, I seem to be hitting problems with memory allocation, as 
load_elf_binary is segfaulting inside padzero/__bzero.

This is my first attempt at real Linux kernel development, so if anyone could 
throw me pointers on how I would approach debugging and fixing this problem, 
I'd really appreciate it. (boot log with early printk is attached)

Thanks,

Luke

--Boundary-00=_uOzSIX8iAFi1DAh
Content-Type: text/x-log;
  charset="us-ascii";
  name="kernel.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kernel.log"

Linux version 2.6.25.4-svn11266-dirty8 (luke-jr@tsuruki) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1)) #105 Fri Jun 6 22:46:18 CDT 2008
Broadcom BCM963xx prom init
Boot loader is : CFEv2
console [early0] enabled
CPU revision is: 00028000 (Broadcom BCM33xx)
Determined physical RAM map:
 memory: 00fa0000 @ 00000000 (usable)
User-defined physical RAM map:
 memory: 007a1200 @ 00000000 (usable)
Initrd not found or empty - disabling initrd
Zone PFN ranges:
  Normal          0 ->     1953
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->     1953
Built 1 zonelists in Zone order, mobility grouping off.  Total pages: 1938
Kernel command line: console=ttyS0,38400 mem=8000000
Primary instruction cache 8kB, VIPT, 2-way, linesize 16 bytes.
Primary data cache 4kB, 2-way, VIPT, no aliases, linesize 16 bytes
Synthesized clear page handler (26 instructions).
Synthesized copy page handler (46 instructions).
PID hash table entries: 32 (order: 5, 128 bytes)
calculating r4koff... 0000fa00(64000)
CPU frequency 32.00 MHz
irq 8: nobody cared (try booting with the "irqpoll" option)
Call Trace:
[<80017124>] dump_stack+0x8/0x34
[<80050a74>] __report_bad_irq+0x44/0xd8
[<80050dcc>] note_interrupt+0x2c4/0x308
[<80051fac>] handle_level_irq+0xfc/0x120
[<80010a18>] plat_irq_dispatch+0x190/0x1c8
[<80011484>] ret_from_irq+0x0/0x4
[<80110b68>] start_kernel+0x228/0x3b4

handlers:
[<8004f8b0>] (no_action+0x0/0x8)
Disabling IRQ #8
console handover: boot [early0] -> real [ttyS0]
Dentry cache hash table entries: 1024 (order: 0, 4096 bytes)
Inode-cache hash table entries: 1024 (order: 0, 4096 bytes)
Memory: 5992k/7812k available (849k kernel code, 1820k reserved, 171k data, 592k init, 0k highmem)
Calibrating delay loop (skipped)... 0.00 BogoMIPS preset
Mount-cache hash table entries: 512
Broadcom BCM963xx Watchdog timer
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
bcm963xx_serial driver v2.0
brd: module loaded
Freeing unused kernel memory: 592k freed
Warning: unable to open an initial console.
Reserved instruction in kernel code[#1]:
Cpu 0
$ 0   : 00000000 10000400 00000000 004e1ffc
$ 4   : 004e014c 00000000 00000ef4 00000ef4
$ 8   : 00000034 004e0fcc 004e010c 801a15c0
$12   : 00080000 9696cd55 0000014a 000058ad
$16   : 004e5cac 801c9600 801ca780 00000000
$20   : 004e010c 801d9e90 004e010c 00000006
$24   : f1c27a83 8001b170
$28   : 801d8000 801d9c88 004e010c 800aa1fc
Hi    : 00000000
Lo    : 00000000
epc   : 800c66f4 __bzero+0x38/0x164     Not tainted
ra    : 800aa1fc padzero+0x5c/0x74
Status: 10000403    KERNEL EXL IE
Cause : 00808028
PrId  : 00028000 (Broadcom BCM33xx)
Process init (pid: 1, threadinfo=801d8000, task=801d7868)
Stack : 800aafcc 800aabec 801ca780 00000080 80083b00 80083ad0 00006012 00000000
        ffffffff 004e010c 004dd2d4 0049d2d4 00400000 00000000 801d7868 8007ffc4
        00000000 00000000 004dd2d4 0049d2d4 00400000 801d9cdc 004e5cac 80495600
        00000001 00000000 00400000 801f6ea0 00000000 8078b980 8010cd70 801ca780
        fffffffe 8010cae0 801d9e90 fffffff8 80110000 00000000 80100000 8007bf54
        ...
Call Trace:
[<800c66f4>] __bzero+0x38/0x164
[<800aa1fc>] padzero+0x5c/0x74
[<800aafcc>] load_elf_binary+0x948/0x145c
[<8007bf54>] search_binary_handler+0x78/0x18c
[<800aa0dc>] load_script+0x25c/0x270
[<8007bf54>] search_binary_handler+0x78/0x18c
[<8007df84>] do_execve+0x18c/0x258
[<8001570c>] sys_execve+0x4c/0x78
[<80018390>] stack_done+0x20/0x3c


Code: 30c8003c  01244821  24840040 <ac85ffc0> ac85ffc4  ac85ffc8  ac85ffcc  ac85ffd0  ac85ffd4
Kernel panic - not syncing: Attempted to kill init!
--Boundary-00=_uOzSIX8iAFi1DAh--
