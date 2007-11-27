Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbXK0DGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbXK0DGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 22:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbXK0DGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 22:06:07 -0500
Received: from www.poetrypoetry.com ([64.135.207.42]:46254 "EHLO
	www.poetrypoetry.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbXK0DGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 22:06:06 -0500
X-Greylist: delayed 1773 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2007 22:06:06 EST
Message-ID: <41877.67.173.156.207.1196130992.squirrel@www.techfinesse.net>
Date: Mon, 26 Nov 2007 20:36:32 -0600 (CST)
Subject: Dynticks Causing High Context Switch Rate in ksoftirqd
From: bdupree@techfinesse.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Question: Why is ksoftirqd eating about 5 to 10 percent of my CPU on an idle
system? The problem occurs if I config the kernel with tickless
support (i.e. CONFIG_TICK_ONESHOT=y).  (Thanks to "oprofile" for putting me
onto this.)

I have noted this same problem on kernel versions: 2.6.23.1, 2.6.23.8 and
2.6.23.9

**************************************************************************
*** Output from "vmstat -n 1 10" -- Note very high context switch rate ***
*** This is on a idle machine!                                         ***
**************************************************************************

procs -----------memory---------- ---swap-- -----io---- --system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy
id wa
 0  0      0 1925556   4768 116104    0    0   124     2    6  7538  1  2
96  1
 0  0      0 1925556   4768 116104    0    0     0     0    2 147329  0  1
99  0
 0  0      0 1925548   4768 116104    0    0     0     0    0 154515  0  1
99  0
 0  0      0 1925548   4768 116104    0    0     0     0    1 153898  0  2
98  0
 0  0      0 1925548   4780 116104    0    0     0    16    3 155216  0  1
99  0
 0  0      0 1925548   4780 116104    0    0     0     0    1 161718  0  1
99  0
 0  0      0 1925548   4780 116104    0    0     0     0    0 147587  0  2
98  0
 0  0      0 1925548   4780 116104    0    0     0     0    1 153524  0  2
98  0
 0  0      0 1925448   4780 116104    0    0     0     0    0 153434  0  1
99  0
 0  0      0 1925448   4792 116092    0    0     0    16    4 153527  0  2
98  0

********************
*** System Stats ***
********************

 Distro: Slackware 10.2
 Mobo:   MSI MasterX FA6R E7210
 CPUs:   Dual 2.4 GHz P4 Xeons 400 MHz FSB - Hyperthreading enabled
 Mem:    2 GB ECC DDR PC 266


******************
*** PCI Config ***
******************

00:00.0 Host bridge: Intel Corporation 82875P/E7210 Memory Controller Hub
(rev 02)
00:03.0 PCI bridge: Intel Corporation 82875P/E7210 Processor to PCI to CSA
Bridge (rev 02)
00:06.0 System peripheral: Intel Corporation 82875P/E7210 Processor to I/O
Memory Interface (rev 02)
00:1c.0 PCI bridge: Intel Corporation 6300ESB 64-bit PCI-X Bridge (rev 02)
00:1d.0 USB Controller: Intel Corporation 6300ESB USB Universal Host
Controller (rev 02)
00:1d.1 USB Controller: Intel Corporation 6300ESB USB Universal Host
Controller (rev 02)
00:1d.4 System peripheral: Intel Corporation 6300ESB Watchdog Timer (rev 02)
00:1d.5 PIC: Intel Corporation 6300ESB I/O Advanced Programmable Interrupt
Controller (rev 02)
00:1d.7 USB Controller: Intel Corporation 6300ESB USB2 Enhanced Host
Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 0a)
00:1f.0 ISA bridge: Intel Corporation 6300ESB LPC Interface Controller
(rev 02)
00:1f.1 IDE interface: Intel Corporation 6300ESB PATA Storage Controller
(rev 02)
00:1f.2 IDE interface: Intel Corporation 6300ESB SATA Storage Controller
(rev 02)
00:1f.3 SMBus: Intel Corporation 6300ESB SMBus Controller (rev 02)
01:01.0 Ethernet controller: Intel Corporation 82547GI Gigabit Ethernet
Controller
02:02.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X
Fusion-MPT Dual Ultra320 SCSI (rev 08)
03:09.0 Mass storage controller: Silicon Image, Inc. SiI 3114
[SATALink/SATARaid] Serial ATA Controller (rev 02)
03:0a.0 Ethernet controller: Intel Corporation 82541GI/PI Gigabit Ethernet
Controller
03:0c.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)


