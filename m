Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZAAT4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZAAT4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 14:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbZAAT4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 14:56:25 -0500
Received: from nn7.de ([85.214.94.156]:45112 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZAAT4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 14:56:21 -0500
Subject: Intel e1000e: eth0: Detected Tx Unit Hang
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Jan 2009 20:56:13 +0100
Message-Id: <1230839773.8319.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,

I just recently observed a strange problem with an onboard 82567LF-2
Intel ethernet controller. It completely stopped working and this
desktop machine required a powerdown to get it to work again. This
happened with 2.6.27.10. However, the machine was working for weeks
before using an older kernel version (2.6.27.*, no binary modules, intel
skyburg mainboard, e8400 c2d cpu).

Relevant details follow, can someone make sense of this?

Soeren

$ lspci

00:19.0 Ethernet controller: Intel Corporation 82567LF-2 Gigabit Network Connection

$ dmesg | grep relevant parts

Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
Intel(R) Gigabit Ethernet Network Driver - version 1.2.45-k2

0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) XX:XX:XX:XX:XX:XX
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 5, PHY: 8, PBA No: ffffff-0ff
ADDRCONF(NETDEV_UP): eth0: link is not ready
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[...]
[uptime of a couple of days, with lots of network i/o]
[...]
saa7146 (1) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
saa7146 (1) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <ff>
  TDT                  <1>
  next_to_use          <1>
  next_to_clean        <ff>
buffer_info[next_to_clean]:
  time_stamp           <1104ec2c3>
  next_to_watch        <ff>
  jiffies              <1104ec8f0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <ff>
  TDT                  <1>
  next_to_use          <1>
  next_to_clean        <ff>
buffer_info[next_to_clean]:
  time_stamp           <1104ec2c3>
  next_to_watch        <ff>
  jiffies              <1104ed0c0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <ff>
  TDT                  <1>
  next_to_use          <1>
  next_to_clean        <ff>
buffer_info[next_to_clean]:
  time_stamp           <1104ec2c3>
  next_to_watch        <ff>
  jiffies              <1104ed890>
  next_to_watch.status <0>
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:219 dev_watchdog+0x22e/0x240()
NETDEV WATCHDOG: eth0 (e1000e): transmit timed out
Modules linked in: ves1820 dvb_ttpci saa7146_vv tda1004x budget_ci budget_core dvb_core saa7146 ttpci_eeprom snd_hda_intel snd_pcm videobuf_dma_sg videobuf_core videodev v4l1_compat snd_timer ir_common usb_storage i2c_i801 snd snd_page_alloc [last unloaded: tda1004x]
Pid: 0, comm: swapper Not tainted 2.6.27.10 #1

Call Trace:
 <IRQ>  [<ffffffff80268ebd>] warn_slowpath+0xcd/0x120
 [<ffffffff8025d5f8>] enqueue_task_fair+0x38/0x90
 [<ffffffff8025c441>] resched_task+0x51/0x90
 [<ffffffff80706ddf>] _spin_unlock_irqrestore+0x1f/0x40
 [<ffffffff802626fe>] try_to_wake_up+0xee/0x1a0
 [<ffffffff80706986>] _spin_lock+0x16/0x20
 [<ffffffff80706e94>] _spin_unlock+0x14/0x40
 [<ffffffff802cf724>] cache_flusharray+0x104/0x160
 [<ffffffff80706e94>] _spin_unlock+0x14/0x40
 [<ffffffff802cc5d9>] kfree_debugcheck+0x9/0x60
 [<ffffffff802cd28e>] cache_free_debugcheck+0x20e/0x290
 [<ffffffff80237512>] read_tsc+0x12/0x40
 [<ffffffff80286908>] getnstimeofday+0x48/0xc0
 [<ffffffff80706ddf>] _spin_unlock_irqrestore+0x1f/0x40
 [<ffffffff80461ae1>] strlcpy+0x41/0x50
 [<ffffffff80626d0e>] dev_watchdog+0x22e/0x240
 [<ffffffff80706e94>] _spin_unlock+0x14/0x40
 [<ffffffff80266027>] scheduler_tick+0xd7/0x230
 [<ffffffff80237512>] read_tsc+0x12/0x40
 [<ffffffff80626ae0>] dev_watchdog+0x0/0x240
 [<ffffffff802739e8>] run_timer_softirq+0x178/0x250
 [<ffffffff8028ac66>] tick_dev_program_event+0x36/0xb0
 [<ffffffff8026ef14>] __do_softirq+0x54/0xc0
 [<ffffffff80230efc>] call_softirq+0x1c/0x30
 [<ffffffff802330fd>] do_softirq+0x4d/0x90
 [<ffffffff8026ebe5>] irq_exit+0x95/0xa0
 [<ffffffff80244824>] smp_apic_timer_interrupt+0x94/0xf0
 [<ffffffff80230703>] apic_timer_interrupt+0x83/0x90
 <EOI>  [<ffffffff8023821c>] mwait_idle+0x3c/0x50
 [<ffffffff8022e50a>] cpu_idle+0x6a/0x110

---[ end trace af5750cbb0896692 ]---
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b6>
  TDT                  <b7>
  next_to_use          <b7>
  next_to_clean        <b5>
buffer_info[next_to_clean]:
  time_stamp           <11051201f>
  next_to_watch        <b6>
  jiffies              <110512665>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b6>
  TDT                  <b7>
  next_to_use          <b7>
  next_to_clean        <b5>
buffer_info[next_to_clean]:
  time_stamp           <11051201f>
  next_to_watch        <b6>
  jiffies              <110512e35>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b1>
  TDT                  <bc>
  next_to_use          <bc>
  next_to_clean        <b0>
buffer_info[next_to_clean]:
  time_stamp           <11053682d>
  next_to_watch        <b1>
  jiffies              <110536c6d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b1>
  TDT                  <bc>
  next_to_use          <bc>
  next_to_clean        <b0>
buffer_info[next_to_clean]:
  time_stamp           <11053682d>
  next_to_watch        <b1>
  jiffies              <11053743d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b1>
  TDT                  <bc>
  next_to_use          <bc>
  next_to_clean        <b0>
buffer_info[next_to_clean]:
  time_stamp           <11053682d>
  next_to_watch        <b1>
  jiffies              <110537c0d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b1>
  TDT                  <bc>
  next_to_use          <bc>
  next_to_clean        <b0>
buffer_info[next_to_clean]:
  time_stamp           <11053682d>
  next_to_watch        <b1>
  jiffies              <1105383dd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b7>
  TDT                  <b8>
  next_to_use          <b8>
  next_to_clean        <b7>
buffer_info[next_to_clean]:
  time_stamp           <11055b23c>
  next_to_watch        <b7>
  jiffies              <11055ba45>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b7>
  TDT                  <b8>
  next_to_use          <b8>
  next_to_clean        <b7>
buffer_info[next_to_clean]:
  time_stamp           <11055b23c>
  next_to_watch        <b7>
  jiffies              <11055c215>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b7>
  TDT                  <b8>
  next_to_use          <b8>
  next_to_clean        <b7>
buffer_info[next_to_clean]:
  time_stamp           <11055b23c>
  next_to_watch        <b7>
  jiffies              <11055c9e5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <a7>
  TDT                  <ad>
  next_to_use          <ad>
  next_to_clean        <a7>
buffer_info[next_to_clean]:
  time_stamp           <110583717>
  next_to_watch        <a7>
  jiffies              <1105842b8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <a7>
  TDT                  <ad>
  next_to_use          <ad>
  next_to_clean        <a7>
buffer_info[next_to_clean]:
  time_stamp           <110583717>
  next_to_watch        <a7>
  jiffies              <110584a88>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <a7>
  TDT                  <ad>
  next_to_use          <ad>
  next_to_clean        <a7>
buffer_info[next_to_clean]:
  time_stamp           <110583717>
  next_to_watch        <a7>
  jiffies              <110585258>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <a7>
  TDT                  <ad>
  next_to_use          <ad>
  next_to_clean        <a7>
buffer_info[next_to_clean]:
  time_stamp           <110583717>
  next_to_watch        <a7>
  jiffies              <110585a28>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <ab>
  TDT                  <af>
  next_to_use          <af>
  next_to_clean        <aa>
buffer_info[next_to_clean]:
  time_stamp           <1105abc59>
  next_to_watch        <ab>
  jiffies              <1105ac355>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <ab>
  TDT                  <af>
  next_to_use          <af>
  next_to_clean        <aa>
buffer_info[next_to_clean]:
  time_stamp           <1105abc59>
  next_to_watch        <ab>
  jiffies              <1105acb25>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <ab>
  TDT                  <af>
  next_to_use          <af>
  next_to_clean        <aa>
buffer_info[next_to_clean]:
  time_stamp           <1105abc59>
  next_to_watch        <ab>
  jiffies              <1105ad2f5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b3>
  TDT                  <b8>
  next_to_use          <b8>
  next_to_clean        <b2>
buffer_info[next_to_clean]:
  time_stamp           <1105d7b79>
  next_to_watch        <b3>
  jiffies              <1105d865d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b3>
  TDT                  <b8>
  next_to_use          <b8>
  next_to_clean        <b2>
buffer_info[next_to_clean]:
  time_stamp           <1105d7b79>
  next_to_watch        <b3>
  jiffies              <1105d8e2d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8e>
  TDT                  <98>
  next_to_use          <98>
  next_to_clean        <8d>
buffer_info[next_to_clean]:
  time_stamp           <1106123cd>
  next_to_watch        <8e>
  jiffies              <110612bf5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8e>
  TDT                  <98>
  next_to_use          <98>
  next_to_clean        <8d>
buffer_info[next_to_clean]:
  time_stamp           <1106123cd>
  next_to_watch        <8e>
  jiffies              <1106133c5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8e>
  TDT                  <98>
  next_to_use          <98>
  next_to_clean        <8d>
buffer_info[next_to_clean]:
  time_stamp           <1106123cd>
  next_to_watch        <8e>
  jiffies              <110613b95>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8e>
  TDT                  <98>
  next_to_use          <98>
  next_to_clean        <8d>
buffer_info[next_to_clean]:
  time_stamp           <1106123cd>
  next_to_watch        <8e>
  jiffies              <110614365>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110657f01>
  next_to_watch        <86>
  jiffies              <110658541>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110657f01>
  next_to_watch        <86>
  jiffies              <110658d10>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110657f01>
  next_to_watch        <86>
  jiffies              <1106594e0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <1106956b3>
  next_to_watch        <86>
  jiffies              <110696185>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <1106956b3>
  next_to_watch        <86>
  jiffies              <110696955>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <1106956b3>
  next_to_watch        <86>
  jiffies              <110697125>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1106d0c3d>
  next_to_watch        <86>
  jiffies              <1106d12d5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1106d0c3d>
  next_to_watch        <86>
  jiffies              <1106d1aa5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1106d0c3d>
  next_to_watch        <86>
  jiffies              <1106d2275>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1106d0c3d>
  next_to_watch        <86>
  jiffies              <1106d2a45>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8c>
  next_to_use          <8c>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <11070b559>
  next_to_watch        <88>
  jiffies              <11070c040>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8c>
  next_to_use          <8c>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <11070b559>
  next_to_watch        <88>
  jiffies              <11070c810>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8c>
  next_to_use          <8c>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <11070b559>
  next_to_watch        <88>
  jiffies              <11070cfe0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <11074d60d>
  next_to_watch        <87>
  jiffies              <11074deed>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <11074d60d>
  next_to_watch        <87>
  jiffies              <11074e6bd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <85>
  next_to_use          <85>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <11078a21b>
  next_to_watch        <83>
  jiffies              <11078ab98>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <85>
  next_to_use          <85>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <11078a21b>
  next_to_watch        <83>
  jiffies              <11078b368>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <85>
  next_to_use          <85>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <11078a21b>
  next_to_watch        <83>
  jiffies              <11078bb38>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <85>
  next_to_use          <85>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <11078a21b>
  next_to_watch        <83>
  jiffies              <11078c308>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <82>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <81>
buffer_info[next_to_clean]:
  time_stamp           <1107c9bd5>
  next_to_watch        <82>
  jiffies              <1107ca71d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <82>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <81>
buffer_info[next_to_clean]:
  time_stamp           <1107c9bd5>
  next_to_watch        <82>
  jiffies              <1107caeed>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <82>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <81>
buffer_info[next_to_clean]:
  time_stamp           <1107c9bd5>
  next_to_watch        <82>
  jiffies              <1107cb6bd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1108045ba>
  next_to_watch        <86>
  jiffies              <110804cb8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1108045ba>
  next_to_watch        <86>
  jiffies              <110805488>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1108045ba>
  next_to_watch        <86>
  jiffies              <110805c58>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110845d02>
  next_to_watch        <87>
  jiffies              <110846395>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110845d02>
  next_to_watch        <87>
  jiffies              <110846b65>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110845d02>
  next_to_watch        <87>
  jiffies              <110847335>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <90>
  next_to_use          <90>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1108881ed>
  next_to_watch        <86>
  jiffies              <110888a18>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <90>
  next_to_use          <90>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1108881ed>
  next_to_watch        <86>
  jiffies              <1108891e8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <90>
  next_to_use          <90>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1108881ed>
  next_to_watch        <86>
  jiffies              <1108899b8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <82>
  TDT                  <83>
  next_to_use          <83>
  next_to_clean        <82>
buffer_info[next_to_clean]:
  time_stamp           <1108c7acd>
  next_to_watch        <82>
  jiffies              <1108c81b8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <82>
  TDT                  <83>
  next_to_use          <83>
  next_to_clean        <82>
buffer_info[next_to_clean]:
  time_stamp           <1108c7acd>
  next_to_watch        <82>
  jiffies              <1108c8988>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <82>
  TDT                  <83>
  next_to_use          <83>
  next_to_clean        <82>
buffer_info[next_to_clean]:
  time_stamp           <1108c7acd>
  next_to_watch        <82>
  jiffies              <1108c9158>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <85>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <110905355>
  next_to_watch        <85>
  jiffies              <110905dfd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <85>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <110905355>
  next_to_watch        <85>
  jiffies              <1109065cd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <85>
  TDT                  <88>
  next_to_use          <88>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <110905355>
  next_to_watch        <85>
  jiffies              <110906d9d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110943676>
  next_to_watch        <87>
  jiffies              <110944215>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110943676>
  next_to_watch        <87>
  jiffies              <1109449e5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110943676>
  next_to_watch        <87>
  jiffies              <1109451b5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110943676>
  next_to_watch        <87>
  jiffies              <110945985>
  next_to_watch.status <0>
saa7146 (1) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110943676>
  next_to_watch        <87>
  jiffies              <110946155>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <110981379>
  next_to_watch        <86>
  jiffies              <110981a75>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <110981379>
  next_to_watch        <86>
  jiffies              <110982245>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <110981379>
  next_to_watch        <86>
  jiffies              <110982a15>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <1109c5bf4>
  next_to_watch        <87>
  jiffies              <1109c6035>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <1109c5bf4>
  next_to_watch        <87>
  jiffies              <1109c6805>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <1109c5bf4>
  next_to_watch        <87>
  jiffies              <1109c6fd5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <1109c5bf4>
  next_to_watch        <87>
  jiffies              <1109c77a5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <82>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <81>
buffer_info[next_to_clean]:
  time_stamp           <110a05011>
  next_to_watch        <82>
  jiffies              <110a05bbd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <82>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <81>
buffer_info[next_to_clean]:
  time_stamp           <110a05011>
  next_to_watch        <82>
  jiffies              <110a0638d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <82>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <81>
buffer_info[next_to_clean]:
  time_stamp           <110a05011>
  next_to_watch        <82>
  jiffies              <110a06b5d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8d>
  next_to_use          <8d>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110a3fa59>
  next_to_watch        <88>
  jiffies              <110a40158>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8d>
  next_to_use          <8d>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110a3fa59>
  next_to_watch        <88>
  jiffies              <110a40928>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8d>
  next_to_use          <8d>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110a3fa59>
  next_to_watch        <88>
  jiffies              <110a410f8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110a7a43d>
  next_to_watch        <88>
  jiffies              <110a7aad8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110a7a43d>
  next_to_watch        <88>
  jiffies              <110a7b2a8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110a7a43d>
  next_to_watch        <88>
  jiffies              <110a7ba78>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <110a7a43d>
  next_to_watch        <88>
  jiffies              <110a7c248>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110ab9d1d>
  next_to_watch        <83>
  jiffies              <110aba65d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110ab9d1d>
  next_to_watch        <83>
  jiffies              <110abae2d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110ab9d1d>
  next_to_watch        <83>
  jiffies              <110abb5fd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110af477b>
  next_to_watch        <83>
  jiffies              <110af4fe0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110af477b>
  next_to_watch        <83>
  jiffies              <110af57b0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110af477b>
  next_to_watch        <83>
  jiffies              <110af5f80>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110af477b>
  next_to_watch        <83>
  jiffies              <110af6750>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
saa7146 (1) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <84>
buffer_info[next_to_clean]:
  time_stamp           <110b2e571>
  next_to_watch        <84>
  jiffies              <110b2eda5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <84>
buffer_info[next_to_clean]:
  time_stamp           <110b2e571>
  next_to_watch        <84>
  jiffies              <110b2f575>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
saa7146 (1) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110b6fd8e>
  next_to_watch        <83>
  jiffies              <110b7086d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110b6fd8e>
  next_to_watch        <83>
  jiffies              <110b7103d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110b6fd8e>
  next_to_watch        <83>
  jiffies              <110b7180d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110b6fd8e>
  next_to_watch        <83>
  jiffies              <110b71fdd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <84>
buffer_info[next_to_clean]:
  time_stamp           <110ba7510>
  next_to_watch        <84>
  jiffies              <110ba7f25>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <84>
buffer_info[next_to_clean]:
  time_stamp           <110ba7510>
  next_to_watch        <84>
  jiffies              <110ba86f5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <9c>
  TDT                  <a5>
  next_to_use          <a5>
  next_to_clean        <9b>
buffer_info[next_to_clean]:
  time_stamp           <110bd9bad>
  next_to_watch        <9c>
  jiffies              <110bd9fed>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <9c>
  TDT                  <a5>
  next_to_use          <a5>
  next_to_clean        <9b>
buffer_info[next_to_clean]:
  time_stamp           <110bd9bad>
  next_to_watch        <9c>
  jiffies              <110bda7bd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <9c>
  TDT                  <a5>
  next_to_use          <a5>
  next_to_clean        <9b>
buffer_info[next_to_clean]:
  time_stamp           <110bd9bad>
  next_to_watch        <9c>
  jiffies              <110bdaf8d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <9c>
  TDT                  <a5>
  next_to_use          <a5>
  next_to_clean        <9b>
buffer_info[next_to_clean]:
  time_stamp           <110bd9bad>
  next_to_watch        <9c>
  jiffies              <110bdb75d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <9c>
  TDT                  <9e>
  next_to_use          <9e>
  next_to_clean        <9c>
buffer_info[next_to_clean]:
  time_stamp           <110c08953>
  next_to_watch        <9c>
  jiffies              <110c091d5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <9c>
  TDT                  <9e>
  next_to_use          <9e>
  next_to_clean        <9c>
buffer_info[next_to_clean]:
  time_stamp           <110c08953>
  next_to_watch        <9c>
  jiffies              <110c099a5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <9c>
  TDT                  <9e>
  next_to_use          <9e>
  next_to_clean        <9c>
buffer_info[next_to_clean]:
  time_stamp           <110c08953>
  next_to_watch        <9c>
  jiffies              <110c0a175>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <9c>
  TDT                  <9e>
  next_to_use          <9e>
  next_to_clean        <9c>
buffer_info[next_to_clean]:
  time_stamp           <110c08953>
  next_to_watch        <9c>
  jiffies              <110c0a945>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <96>
  TDT                  <97>
  next_to_use          <97>
  next_to_clean        <96>
buffer_info[next_to_clean]:
  time_stamp           <110c3a0b8>
  next_to_watch        <96>
  jiffies              <110c3aad0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <96>
  TDT                  <97>
  next_to_use          <97>
  next_to_clean        <96>
buffer_info[next_to_clean]:
  time_stamp           <110c3a0b8>
  next_to_watch        <96>
  jiffies              <110c3b2a0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <110c789eb>
  next_to_watch        <88>
  jiffies              <110c792d0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <110c789eb>
  next_to_watch        <88>
  jiffies              <110c79aa0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <110c789eb>
  next_to_watch        <88>
  jiffies              <110c7a270>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <89>
  TDT                  <8c>
  next_to_use          <8c>
  next_to_clean        <89>
buffer_info[next_to_clean]:
  time_stamp           <110cb6ebc>
  next_to_watch        <89>
  jiffies              <110cb76e5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <89>
  TDT                  <8c>
  next_to_use          <8c>
  next_to_clean        <89>
buffer_info[next_to_clean]:
  time_stamp           <110cb6ebc>
  next_to_watch        <89>
  jiffies              <110cb7eb5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <89>
  TDT                  <8c>
  next_to_use          <8c>
  next_to_clean        <89>
buffer_info[next_to_clean]:
  time_stamp           <110cb6ebc>
  next_to_watch        <89>
  jiffies              <110cb8685>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <89>
  TDT                  <8c>
  next_to_use          <8c>
  next_to_clean        <89>
buffer_info[next_to_clean]:
  time_stamp           <110cb6ebc>
  next_to_watch        <89>
  jiffies              <110cb8e55>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <89>
  TDT                  <8c>
  next_to_use          <8c>
  next_to_clean        <89>
buffer_info[next_to_clean]:
  time_stamp           <110cb6ebc>
  next_to_watch        <89>
  jiffies              <110cb9625>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <82>
  TDT                  <84>
  next_to_use          <84>
  next_to_clean        <82>
buffer_info[next_to_clean]:
  time_stamp           <110cf6ef9>
  next_to_watch        <82>
  jiffies              <110cf7a40>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <82>
  TDT                  <84>
  next_to_use          <84>
  next_to_clean        <82>
buffer_info[next_to_clean]:
  time_stamp           <110cf6ef9>
  next_to_watch        <82>
  jiffies              <110cf8210>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <82>
  TDT                  <84>
  next_to_use          <84>
  next_to_clean        <82>
buffer_info[next_to_clean]:
  time_stamp           <110cf6ef9>
  next_to_watch        <82>
  jiffies              <110cf89e0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
saa7146 (1) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110d2bed3>
  next_to_watch        <86>
  jiffies              <110d2c9e5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110d2bed3>
  next_to_watch        <86>
  jiffies              <110d2d1b5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110d2bed3>
  next_to_watch        <86>
  jiffies              <110d2d985>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110d2bed3>
  next_to_watch        <86>
  jiffies              <110d2e155>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110d67162>
  next_to_watch        <86>
  jiffies              <110d67b35>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110d67162>
  next_to_watch        <86>
  jiffies              <110d68305>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110d67162>
  next_to_watch        <86>
  jiffies              <110d68ad5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110d67162>
  next_to_watch        <86>
  jiffies              <110d692a5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <84>
buffer_info[next_to_clean]:
  time_stamp           <110da4158>
  next_to_watch        <84>
  jiffies              <110da47dd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <84>
buffer_info[next_to_clean]:
  time_stamp           <110da4158>
  next_to_watch        <84>
  jiffies              <110da4fad>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <84>
buffer_info[next_to_clean]:
  time_stamp           <110da4158>
  next_to_watch        <84>
  jiffies              <110da577d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <84>
buffer_info[next_to_clean]:
  time_stamp           <110da4158>
  next_to_watch        <84>
  jiffies              <110da5f4d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <89>
  TDT                  <93>
  next_to_use          <93>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <110de912d>
  next_to_watch        <89>
  jiffies              <110de956d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <89>
  TDT                  <93>
  next_to_use          <93>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <110de912d>
  next_to_watch        <89>
  jiffies              <110de9d3d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <89>
  TDT                  <93>
  next_to_use          <93>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <110de912d>
  next_to_watch        <89>
  jiffies              <110dea50d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <89>
  TDT                  <93>
  next_to_use          <93>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <110de912d>
  next_to_watch        <89>
  jiffies              <110deacdd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110e2d540>
  next_to_watch        <86>
  jiffies              <110e2df15>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110e2d540>
  next_to_watch        <86>
  jiffies              <110e2e6e5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110e2d540>
  next_to_watch        <86>
  jiffies              <110e2eeb5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <85>
  next_to_use          <85>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110e5e5bd>
  next_to_watch        <84>
  jiffies              <110e5f040>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <85>
  next_to_use          <85>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110e5e5bd>
  next_to_watch        <84>
  jiffies              <110e5f810>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <110e98f3d>
  next_to_watch        <86>
  jiffies              <110e999c0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <110e98f3d>
  next_to_watch        <86>
  jiffies              <110e9a190>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <110e98f3d>
  next_to_watch        <86>
  jiffies              <110e9a960>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <8d>
  next_to_use          <8d>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110ee218d>
  next_to_watch        <84>
  jiffies              <110ee25d0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <8d>
  next_to_use          <8d>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110ee218d>
  next_to_watch        <84>
  jiffies              <110ee2da0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <8d>
  next_to_use          <8d>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110ee218d>
  next_to_watch        <84>
  jiffies              <110ee3570>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <8d>
  next_to_use          <8d>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <110ee218d>
  next_to_watch        <84>
  jiffies              <110ee3d40>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <85>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <84>
buffer_info[next_to_clean]:
  time_stamp           <110f1cc9d>
  next_to_watch        <85>
  jiffies              <110f1d71d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <85>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <84>
buffer_info[next_to_clean]:
  time_stamp           <110f1cc9d>
  next_to_watch        <85>
  jiffies              <110f1deed>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <90>
  TDT                  <98>
  next_to_use          <98>
  next_to_clean        <8f>
buffer_info[next_to_clean]:
  time_stamp           <110f57555>
  next_to_watch        <90>
  jiffies              <110f580a0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <90>
  TDT                  <98>
  next_to_use          <98>
  next_to_clean        <8f>
buffer_info[next_to_clean]:
  time_stamp           <110f57555>
  next_to_watch        <90>
  jiffies              <110f58870>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <90>
  TDT                  <98>
  next_to_use          <98>
  next_to_clean        <8f>
buffer_info[next_to_clean]:
  time_stamp           <110f57555>
  next_to_watch        <90>
  jiffies              <110f59040>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <110f91f9d>
  next_to_watch        <86>
  jiffies              <110f92635>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <110f91f9d>
  next_to_watch        <86>
  jiffies              <110f92e05>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <110f91f9d>
  next_to_watch        <86>
  jiffies              <110f935d5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110fcc8b9>
  next_to_watch        <87>
  jiffies              <110fcd39d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <110fcc8b9>
  next_to_watch        <87>
  jiffies              <110fcdb6d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <90>
  TDT                  <97>
  next_to_use          <97>
  next_to_clean        <8f>
buffer_info[next_to_clean]:
  time_stamp           <1110071d5>
  next_to_watch        <90>
  jiffies              <111007d1d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <90>
  TDT                  <97>
  next_to_use          <97>
  next_to_clean        <8f>
buffer_info[next_to_clean]:
  time_stamp           <1110071d5>
  next_to_watch        <90>
  jiffies              <1110084ed>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <90>
  TDT                  <97>
  next_to_use          <97>
  next_to_clean        <8f>
buffer_info[next_to_clean]:
  time_stamp           <1110071d5>
  next_to_watch        <90>
  jiffies              <111008cbd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <99>
  TDT                  <9b>
  next_to_use          <9b>
  next_to_clean        <99>
buffer_info[next_to_clean]:
  time_stamp           <11103ebd2>
  next_to_watch        <99>
  jiffies              <11103f3d5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <99>
  TDT                  <9b>
  next_to_use          <9b>
  next_to_clean        <99>
buffer_info[next_to_clean]:
  time_stamp           <11103ebd2>
  next_to_watch        <99>
  jiffies              <11103fba5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <99>
  TDT                  <9b>
  next_to_use          <9b>
  next_to_clean        <99>
buffer_info[next_to_clean]:
  time_stamp           <11103ebd2>
  next_to_watch        <99>
  jiffies              <111040375>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <99>
  TDT                  <9b>
  next_to_use          <9b>
  next_to_clean        <99>
buffer_info[next_to_clean]:
  time_stamp           <11103ebd2>
  next_to_watch        <99>
  jiffies              <111040b45>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
saa7146 (1) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <84>
buffer_info[next_to_clean]:
  time_stamp           <11107f0f1>
  next_to_watch        <84>
  jiffies              <11107f72d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <84>
buffer_info[next_to_clean]:
  time_stamp           <11107f0f1>
  next_to_watch        <84>
  jiffies              <11107fefd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <84>
buffer_info[next_to_clean]:
  time_stamp           <11107f0f1>
  next_to_watch        <84>
  jiffies              <1110806cd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <84>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <84>
buffer_info[next_to_clean]:
  time_stamp           <11107f0f1>
  next_to_watch        <84>
  jiffies              <111080e9d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8d>
  TDT                  <90>
  next_to_use          <90>
  next_to_clean        <8c>
buffer_info[next_to_clean]:
  time_stamp           <1110b6eb9>
  next_to_watch        <8d>
  jiffies              <1110b75b8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8d>
  TDT                  <90>
  next_to_use          <90>
  next_to_clean        <8c>
buffer_info[next_to_clean]:
  time_stamp           <1110b6eb9>
  next_to_watch        <8d>
  jiffies              <1110b7d88>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8d>
  TDT                  <90>
  next_to_use          <90>
  next_to_clean        <8c>
buffer_info[next_to_clean]:
  time_stamp           <1110b6eb9>
  next_to_watch        <8d>
  jiffies              <1110b8558>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8d>
  TDT                  <90>
  next_to_use          <90>
  next_to_clean        <8c>
buffer_info[next_to_clean]:
  time_stamp           <1110b6eb9>
  next_to_watch        <8d>
  jiffies              <1110b8d28>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <1110f2255>
  next_to_watch        <86>
  jiffies              <1110f2708>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <1110f2255>
  next_to_watch        <86>
  jiffies              <1110f2ed8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <1110f2255>
  next_to_watch        <86>
  jiffies              <1110f36a8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <1110f2255>
  next_to_watch        <86>
  jiffies              <1110f3e78>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8b>
  TDT                  <8e>
  next_to_use          <8e>
  next_to_clean        <8a>
buffer_info[next_to_clean]:
  time_stamp           <11112c1b9>
  next_to_watch        <8b>
  jiffies              <11112cc9d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8b>
  TDT                  <8e>
  next_to_use          <8e>
  next_to_clean        <8a>
buffer_info[next_to_clean]:
  time_stamp           <11112c1b9>
  next_to_watch        <8b>
  jiffies              <11112d46d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8b>
  TDT                  <8e>
  next_to_use          <8e>
  next_to_clean        <8a>
buffer_info[next_to_clean]:
  time_stamp           <11112c1b9>
  next_to_watch        <8b>
  jiffies              <11112dc3d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8b>
  TDT                  <8e>
  next_to_use          <8e>
  next_to_clean        <8a>
buffer_info[next_to_clean]:
  time_stamp           <11112c1b9>
  next_to_watch        <8b>
  jiffies              <11112e40d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <93>
  TDT                  <98>
  next_to_use          <98>
  next_to_clean        <92>
buffer_info[next_to_clean]:
  time_stamp           <111166ad5>
  next_to_watch        <93>
  jiffies              <11116761d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <93>
  TDT                  <98>
  next_to_use          <98>
  next_to_clean        <92>
buffer_info[next_to_clean]:
  time_stamp           <111166ad5>
  next_to_watch        <93>
  jiffies              <111167ded>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <93>
  TDT                  <98>
  next_to_use          <98>
  next_to_clean        <92>
buffer_info[next_to_clean]:
  time_stamp           <111166ad5>
  next_to_watch        <93>
  jiffies              <1111685bd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <85>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1111a2616>
  next_to_watch        <85>
  jiffies              <1111a2b58>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <85>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1111a2616>
  next_to_watch        <85>
  jiffies              <1111a3328>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <85>
  TDT                  <86>
  next_to_use          <86>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1111a2616>
  next_to_watch        <85>
  jiffies              <1111a3b05>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8e>
  TDT                  <95>
  next_to_use          <95>
  next_to_clean        <8d>
buffer_info[next_to_clean]:
  time_stamp           <1111dbdd5>
  next_to_watch        <8e>
  jiffies              <1111dc920>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8e>
  TDT                  <95>
  next_to_use          <95>
  next_to_clean        <8d>
buffer_info[next_to_clean]:
  time_stamp           <1111dbdd5>
  next_to_watch        <8e>
  jiffies              <1111dd0f0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8e>
  TDT                  <95>
  next_to_use          <95>
  next_to_clean        <8d>
buffer_info[next_to_clean]:
  time_stamp           <1111dbdd5>
  next_to_watch        <8e>
  jiffies              <1111dd8c0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8e>
  TDT                  <95>
  next_to_use          <95>
  next_to_clean        <8d>
buffer_info[next_to_clean]:
  time_stamp           <1111dbdd5>
  next_to_watch        <8e>
  jiffies              <1111de090>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <111217925>
  next_to_watch        <88>
  jiffies              <111218240>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <111217925>
  next_to_watch        <88>
  jiffies              <111218a10>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8b>
  next_to_use          <8b>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <111217925>
  next_to_watch        <88>
  jiffies              <1112191e0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <93>
  TDT                  <9e>
  next_to_use          <9e>
  next_to_clean        <92>
buffer_info[next_to_clean]:
  time_stamp           <111251071>
  next_to_watch        <93>
  jiffies              <111251835>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <93>
  TDT                  <9e>
  next_to_use          <9e>
  next_to_clean        <92>
buffer_info[next_to_clean]:
  time_stamp           <111251071>
  next_to_watch        <93>
  jiffies              <111252005>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <93>
  TDT                  <9e>
  next_to_use          <9e>
  next_to_clean        <92>
buffer_info[next_to_clean]:
  time_stamp           <111251071>
  next_to_watch        <93>
  jiffies              <1112527d5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <93>
  TDT                  <9e>
  next_to_use          <9e>
  next_to_clean        <92>
buffer_info[next_to_clean]:
  time_stamp           <111251071>
  next_to_watch        <93>
  jiffies              <111252fa5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <93>
  TDT                  <9e>
  next_to_use          <9e>
  next_to_clean        <92>
buffer_info[next_to_clean]:
  time_stamp           <111251071>
  next_to_watch        <93>
  jiffies              <111253775>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8f>
  TDT                  <94>
  next_to_use          <94>
  next_to_clean        <8e>
buffer_info[next_to_clean]:
  time_stamp           <11128bab9>
  next_to_watch        <8f>
  jiffies              <11128c1b8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8f>
  TDT                  <94>
  next_to_use          <94>
  next_to_clean        <8e>
buffer_info[next_to_clean]:
  time_stamp           <11128bab9>
  next_to_watch        <8f>
  jiffies              <11128c988>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8f>
  TDT                  <94>
  next_to_use          <94>
  next_to_clean        <8e>
buffer_info[next_to_clean]:
  time_stamp           <11128bab9>
  next_to_watch        <8f>
  jiffies              <11128d158>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <8f>
  TDT                  <94>
  next_to_use          <94>
  next_to_clean        <8e>
buffer_info[next_to_clean]:
  time_stamp           <11128bab9>
  next_to_watch        <8f>
  jiffies              <11128d928>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <99>
  TDT                  <a4>
  next_to_use          <a4>
  next_to_clean        <99>
buffer_info[next_to_clean]:
  time_stamp           <1112c6127>
  next_to_watch        <99>
  jiffies              <1112c6b35>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <99>
  TDT                  <a4>
  next_to_use          <a4>
  next_to_clean        <99>
buffer_info[next_to_clean]:
  time_stamp           <1112c6127>
  next_to_watch        <99>
  jiffies              <1112c7305>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <99>
  TDT                  <a4>
  next_to_use          <a4>
  next_to_clean        <99>
buffer_info[next_to_clean]:
  time_stamp           <1112c6127>
  next_to_watch        <99>
  jiffies              <1112c7ad5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <98>
  TDT                  <9a>
  next_to_use          <9a>
  next_to_clean        <98>
buffer_info[next_to_clean]:
  time_stamp           <1112ff58c>
  next_to_watch        <98>
  jiffies              <111300130>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <98>
  TDT                  <9a>
  next_to_use          <9a>
  next_to_clean        <98>
buffer_info[next_to_clean]:
  time_stamp           <1112ff58c>
  next_to_watch        <98>
  jiffies              <111300900>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <95>
  TDT                  <9a>
  next_to_use          <9a>
  next_to_clean        <95>
buffer_info[next_to_clean]:
  time_stamp           <111332e5e>
  next_to_watch        <95>
  jiffies              <111333965>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <95>
  TDT                  <9a>
  next_to_use          <9a>
  next_to_clean        <95>
buffer_info[next_to_clean]:
  time_stamp           <111332e5e>
  next_to_watch        <95>
  jiffies              <111334135>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <95>
  TDT                  <9a>
  next_to_use          <9a>
  next_to_clean        <95>
buffer_info[next_to_clean]:
  time_stamp           <111332e5e>
  next_to_watch        <95>
  jiffies              <111334905>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <111369632>
  next_to_watch        <88>
  jiffies              <11136a080>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <111369632>
  next_to_watch        <88>
  jiffies              <11136a850>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <111369632>
  next_to_watch        <88>
  jiffies              <11136b020>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <1113aa631>
  next_to_watch        <87>
  jiffies              <1113aaba8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <1113aa631>
  next_to_watch        <87>
  jiffies              <1113ab378>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <1113aa631>
  next_to_watch        <87>
  jiffies              <1113abb48>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <1113aa631>
  next_to_watch        <87>
  jiffies              <1113ac318>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <87>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <1113aa631>
  next_to_watch        <87>
  jiffies              <1113acae8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <84>
  next_to_use          <84>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <1113de328>
  next_to_watch        <83>
  jiffies              <1113de7c5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <84>
  next_to_use          <84>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <1113de328>
  next_to_watch        <83>
  jiffies              <1113def95>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <83>
  TDT                  <84>
  next_to_use          <84>
  next_to_clean        <83>
buffer_info[next_to_clean]:
  time_stamp           <1113de328>
  next_to_watch        <83>
  jiffies              <1113df765>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <93>
  TDT                  <9a>
  next_to_use          <9a>
  next_to_clean        <92>
buffer_info[next_to_clean]:
  time_stamp           <111417211>
  next_to_watch        <93>
  jiffies              <1114179d5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <93>
  TDT                  <9a>
  next_to_use          <9a>
  next_to_clean        <92>
buffer_info[next_to_clean]:
  time_stamp           <111417211>
  next_to_watch        <93>
  jiffies              <1114181a5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <111453364>
  next_to_watch        <86>
  jiffies              <111453eb0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <111453364>
  next_to_watch        <86>
  jiffies              <111454680>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <86>
buffer_info[next_to_clean]:
  time_stamp           <111453364>
  next_to_watch        <86>
  jiffies              <111454e50>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <89>
  TDT                  <8d>
  next_to_use          <8d>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <11148c5d9>
  next_to_watch        <89>
  jiffies              <11148d0c0>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <89>
  TDT                  <8d>
  next_to_use          <8d>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <11148c5d9>
  next_to_watch        <89>
  jiffies              <11148d890>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <89>
  TDT                  <8d>
  next_to_use          <8d>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <11148c5d9>
  next_to_watch        <89>
  jiffies              <11148e061>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <89>
  TDT                  <8d>
  next_to_use          <8d>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <11148c5d9>
  next_to_watch        <89>
  jiffies              <11148e830>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <89>
  TDT                  <8d>
  next_to_use          <8d>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <11148c5d9>
  next_to_watch        <89>
  jiffies              <11148f000>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <1114ce1df>
  next_to_watch        <88>
  jiffies              <1114ce79d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <89>
  next_to_use          <89>
  next_to_clean        <88>
buffer_info[next_to_clean]:
  time_stamp           <1114ce1df>
  next_to_watch        <88>
  jiffies              <1114cef6d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <98>
  TDT                  <a5>
  next_to_use          <a5>
  next_to_clean        <98>
buffer_info[next_to_clean]:
  time_stamp           <11150165e>
  next_to_watch        <98>
  jiffies              <111501fd8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <98>
  TDT                  <a5>
  next_to_use          <a5>
  next_to_clean        <98>
buffer_info[next_to_clean]:
  time_stamp           <11150165e>
  next_to_watch        <98>
  jiffies              <1115027a8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <98>
  TDT                  <a5>
  next_to_use          <a5>
  next_to_clean        <98>
buffer_info[next_to_clean]:
  time_stamp           <11150165e>
  next_to_watch        <98>
  jiffies              <111502f78>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <95>
  TDT                  <96>
  next_to_use          <96>
  next_to_clean        <95>
buffer_info[next_to_clean]:
  time_stamp           <11153b307>
  next_to_watch        <95>
  jiffies              <11153b9b8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <95>
  TDT                  <96>
  next_to_use          <96>
  next_to_clean        <95>
buffer_info[next_to_clean]:
  time_stamp           <11153b307>
  next_to_watch        <95>
  jiffies              <11153c188>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <111576c3d>
  next_to_watch        <88>
  jiffies              <1115772d5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <111576c3d>
  next_to_watch        <88>
  jiffies              <111577aa5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <111576c3d>
  next_to_watch        <88>
  jiffies              <111578275>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <111576c3d>
  next_to_watch        <88>
  jiffies              <111578a45>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <88>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <87>
buffer_info[next_to_clean]:
  time_stamp           <111576c3d>
  next_to_watch        <88>
  jiffies              <111579215>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <85>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1115b841f>
  next_to_watch        <85>
  jiffies              <1115b89b5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <85>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1115b841f>
  next_to_watch        <85>
  jiffies              <1115b9185>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <85>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1115b841f>
  next_to_watch        <85>
  jiffies              <1115b9955>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <85>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1115b841f>
  next_to_watch        <85>
  jiffies              <1115ba125>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <85>
  TDT                  <87>
  next_to_use          <87>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1115b841f>
  next_to_watch        <85>
  jiffies              <1115ba8f5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1115ebed9>
  next_to_watch        <86>
  jiffies              <1115ec5d5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1115ebed9>
  next_to_watch        <86>
  jiffies              <1115ecda5>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <86>
  TDT                  <8a>
  next_to_use          <8a>
  next_to_clean        <85>
buffer_info[next_to_clean]:
  time_stamp           <1115ebed9>
  next_to_watch        <86>
  jiffies              <1115ed575>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <a6>
  TDT                  <af>
  next_to_use          <af>
  next_to_clean        <a5>
buffer_info[next_to_clean]:
  time_stamp           <111617d95>
  next_to_watch        <a6>
  jiffies              <1116188dd>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <a6>
  TDT                  <af>
  next_to_use          <af>
  next_to_clean        <a5>
buffer_info[next_to_clean]:
  time_stamp           <111617d95>
  next_to_watch        <a6>
  jiffies              <1116190ad>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <a6>
  TDT                  <af>
  next_to_use          <af>
  next_to_clean        <a5>
buffer_info[next_to_clean]:
  time_stamp           <111617d95>
  next_to_watch        <a6>
  jiffies              <11161987d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <a6>
  TDT                  <af>
  next_to_use          <af>
  next_to_clean        <a5>
buffer_info[next_to_clean]:
  time_stamp           <111617d95>
  next_to_watch        <a6>
  jiffies              <11161a04d>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b1>
  TDT                  <b7>
  next_to_use          <b7>
  next_to_clean        <b0>
buffer_info[next_to_clean]:
  time_stamp           <11163531d>
  next_to_watch        <b1>
  jiffies              <1116359b8>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b1>
  TDT                  <b7>
  next_to_use          <b7>
  next_to_clean        <b0>
buffer_info[next_to_clean]:
  time_stamp           <11163531d>
  next_to_watch        <b1>
  jiffies              <111636188>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b1>
  TDT                  <b7>
  next_to_use          <b7>
  next_to_clean        <b0>
buffer_info[next_to_clean]:
  time_stamp           <11163531d>
  next_to_watch        <b1>
  jiffies              <111636958>
  next_to_watch.status <0>
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <b1>
  TDT                  <b7>
  next_to_use          <b7>
  next_to_clean        <b0>
buffer_info[next_to_clean]:
  time_stamp           <11163531d>
  next_to_watch        <b1>
  jiffies              <111637128>
  next_to_watch.status <0>
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[...]

