Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbYBYUla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbYBYUla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbYBYUlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:41:22 -0500
Received: from aun.it.uu.se ([130.238.12.36]:51988 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbYBYUlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:41:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18371.10207.58819.188510@alkaid.it.uu.se>
Date: Mon, 25 Feb 2008 21:41:03 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: davem@davemloft.net
Subject: [BUG] 2.6.25-rc3 hangs in early boot on Sun Ultra5
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting 2.6.25-rc3 on my Ultra5 causes a hang before or as
the console is switched over to the framebuffer. The console
output is (extrapolated from dmesg in -rc2 and handwritten
notes, as I don't have a serial cable to my U5):

PROMLIB: Sun IEEE Boot Prom 'OBP 3.25.3 2000/06/29 14:12'
PROMLIB: Root node compatible: 
*** the following line can't be seen in dmesg after rc2 has booted
console [earlyprom0] enabled
Linux version 2.6.25-rc3 (mikpe@sparge) (gcc version 4.2.3) #1 Mon Feb 25 18:49:41 CET 2008
ARCH: SUN4U
Ethernet address: 08:00:20:fd:ec:1f
[0000000200000000-fffff80000400000] page_structs=262144 node=0 entry=0/0
[0000000200000000-fffff80000800000] page_structs=262144 node=0 entry=1/0
[0000000200000000-fffff80000c00000] page_structs=262144 node=0 entry=2/0
[0000000200000000-fffff80001000000] page_structs=262144 node=0 entry=3/0
OF stdout device is: /pci@1f,0/pci@1,1/SUNW,m64B@2
PROM: Built device tree with 46617 bytes of memory.
On node 0 totalpages: 32299
  Normal zone: 335 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 31964 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 31964
Kernel command line: ro root=/dev/sda5
PID hash table entries: 1024 (order: 10, 8192 bytes)
clocksource: mult[28000] shift[16]
clockevent: mult[66666666] shift[32]
Console: colour dummy device 80x25
*** the following line can't be seen in dmesg after rc2 has booted
console handover: boot [earlyprom0] -> real [tty0]

At this point rc3 hangs hard and won't even respond to sysrq.

Another difference is that with rc2 the first few lines of kernel
output while the console is still in OF mode either aren't shown
or disappear quickly since the switch to the framebuffer occurs
within a fraction of a second after the kernel has been loaded.
With rc3 the kernel output (the text shown above) in the OF-mode
console is very very slow.

(I should have quoted my .config here but I forgot to bring it.
It's exactly the same in rc2 and rc3, however.)

I'll try some rc2->rc3 bisecting later.

/Mikael
