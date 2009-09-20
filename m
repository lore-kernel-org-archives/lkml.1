Return-Path: <linux-kernel-owner+w=401wt.eu-S1751220AbZITL0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbZITL0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 07:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZITL0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 07:26:13 -0400
Received: from mail-a04.ithnet.com ([217.64.83.99]:55714 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750828AbZITL0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 07:26:11 -0400
X-Sender-Authentication: net64
Date: Sun, 20 Sep 2009 13:26:09 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel@vger.kernel.org
Cc: jesse.brandeburg@gmail.com, khc@pm.waw.pl, jeffrey.t.kirsher@intel.com,
       gregkh@suse.de, davem@davemloft.net, linux-mm@kvack.org
Subject: What about this message (2.6.31) ?
Message-Id: <20090920132609.c9021d36.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

today - after several hangs without any messages - we finally got this one:

Sep 20 12:10:48 box2 kernel: ------------[ cut here ]------------
Sep 20 12:10:48 box2 kernel: WARNING: at include/linux/skbuff.h:1382 skb_trim+0x1a/0x2b()
Sep 20 12:10:48 box2 kernel: Hardware name:  
Sep 20 12:10:48 box2 kernel: Modules linked in: speedstep_lib freq_table nfs lockd sunrpc e100 mii e1000
Sep 20 12:10:48 box2 kernel: Pid: 0, comm: swapper Not tainted 2.6.31 #1
Sep 20 12:10:48 box2 kernel: Call Trace:
Sep 20 12:10:48 box2 kernel:  [<c011c652>] ? warn_slowpath_common+0x5e/0x71
Sep 20 12:10:48 box2 kernel:  [<c011c69a>] ? warn_slowpath_null+0xa/0xd
Sep 20 12:10:48 box2 kernel:  [<c0283801>] ? skb_trim+0x1a/0x2b
Sep 20 12:10:48 box2 kernel:  [<f81399c6>] ? e1000_alloc_rx_buffers+0x70/0x299 [e1000]
Sep 20 12:10:48 box2 kernel:  [<f813992b>] ? e1000_clean_rx_irq+0x38a/0x3b5 [e1000]
Sep 20 12:10:48 box2 kernel:  [<f8139266>] ? e1000_clean+0x43/0x87 [e1000]
Sep 20 12:10:48 box2 kernel:  [<c028ab37>] ? net_rx_action+0x5e/0xfe
Sep 20 12:10:48 box2 kernel:  [<c011fb04>] ? __do_softirq+0x5f/0xc8
Sep 20 12:10:48 box2 kernel:  [<c011fb8f>] ? do_softirq+0x22/0x26
Sep 20 12:10:48 box2 kernel:  [<c01042fa>] ? do_IRQ+0x66/0x76
Sep 20 12:10:48 box2 kernel:  [<c0102ea9>] ? common_interrupt+0x29/0x30
Sep 20 12:10:48 box2 kernel:  [<c011007b>] ? nmi_watchdog_tick+0x109/0x117
Sep 20 12:10:48 box2 kernel:  [<c02e007b>] ? schedule+0x1eb/0x280
Sep 20 12:10:48 box2 kernel:  [<c010714d>] ? default_idle+0x28/0x3f
Sep 20 12:10:48 box2 kernel:  [<c0101524>] ? cpu_idle+0x1a/0x2e
Sep 20 12:10:48 box2 kernel:  [<c03e7626>] ? start_kernel+0x1dc/0x1de
Sep 20 12:10:48 box2 kernel: ---[ end trace 94392a5ad56b9fbd ]---

The hardware looks like this:

0000:00:00.0 Host bridge: Intel Corp. 82875P Memory Controller Hub (rev 02)
0000:00:01.0 PCI bridge: Intel Corp. 82875P Processor to AGP Controller (rev 02)
0000:00:03.0 PCI bridge: Intel Corp. 82875P Processor to PCI to CSA Bridge (rev 02)
0000:00:06.0 System peripheral: Intel Corp. 82875P Processor to I/O Memory Interface (rev 02)
0000:00:1d.0 USB Controller: Intel Corp. 82801EB USB (rev 02)
0000:00:1d.1 USB Controller: Intel Corp. 82801EB USB (rev 02)
0000:00:1d.2 USB Controller: Intel Corp. 82801EB USB (rev 02)
0000:00:1d.3 USB Controller: Intel Corp. 82801EB USB (rev 02)
0000:00:1d.7 USB Controller: Intel Corp. 82801EB USB2 (rev 02)
0000:00:1e.0 PCI bridge: Intel Corp. 82801BA/CA/DB/EB PCI Bridge (rev c2)
0000:00:1f.0 ISA bridge: Intel Corp. 82801EB LPC Interface Controller (rev 02)
0000:00:1f.1 IDE interface: Intel Corp. 82801EB Ultra ATA Storage Controller (rev 02)
0000:00:1f.3 SMBus: Intel Corp. 82801EB SMBus Controller (rev 02)
0000:02:01.0 Ethernet controller: Intel Corp. 82547EI Gigabit Ethernet Controller (LOM)
0000:03:02.0 Ethernet controller: Intel Corp. 82541EI Gigabit Ethernet Controller (Copper)
0000:03:07.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
0000:03:08.0 Ethernet controller: Intel Corp.: Unknown device 1051 (rev 02)

The kernel is 32bit, CPU:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Pentium(R) 4 CPU 2.66GHz
stepping        : 9
cpu MHz         : 2672.905
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid xtpr
bogomips        : 5345.81
clflush size    : 64
power management:

After this output the box feels dead, at least all userspace dead, no login, open shells are dead.

-- 
Regards,
Stephan

