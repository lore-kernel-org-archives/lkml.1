Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbZELH4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbZELH4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbZELH4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:56:39 -0400
Received: from welcomes-you.com ([85.214.50.128]:51884 "EHLO
	smtp.welcomes-you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbZELH4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:56:38 -0400
X-Greylist: delayed 1715 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 May 2009 03:56:37 EDT
Message-ID: <4A0924FF.7040502@aei.mpg.de>
Date: Tue, 12 May 2009 09:27:59 +0200
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: sky2 problem with WARNING: at net/sched/sch_generic.c:219
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

we've recently got some Asus P5E Deluxe based boards with Yukon NICs on it:

03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E
Gigabit Ethernet Controller (rev 12)
        Subsystem: ASUSTeK Computer Inc. Device 81f8
        Flags: bus master, fast devsel, latency 0, IRQ 762
        Memory at fcffc000 (64-bit, non-prefetchable) [size=16K]
        I/O ports at e800 [size=256]
        Expansion ROM at fcfc0000 [disabled] [size=128K]
        Capabilities: [48] Power Management version 3
        Capabilities: [50] Vital Product Data <?>
        Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable+
        Capabilities: [e0] Express Legacy Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting <?>
        Kernel driver in use: sky2
        Kernel modules: sky2

Kernel is 2.6.27.21 (vanilla) with sky2 version 1.22, but we have seen
similar issues with 2.6.26 and 2.6.28 kernels (Debian based or vanilla).

We do see this error quite often, especially during installation and
afterwards if doing "innocent" stuff like browsing through dmesg or
doing 'lshw|most':

May 12 09:04:28 gpu01 kernel: [ 3000.040007] ------------[ cut here
]------------
May 12 09:04:28 gpu01 kernel: [ 3000.040011] WARNING: at
net/sched/sch_generic.c:219 dev_watchdog+0x121/0x1b8()
May 12 09:04:28 gpu01 kernel: [ 3000.040013] NETDEV WATCHDOG: eth0
(sky2): transmit timed out
May 12 09:04:28 gpu01 kernel: [ 3000.040015] Modules linked in:
ipmi_devintf ipmi_watchdog ipmi_poweroff ipmi_msghandler i2c_i801
i2c_core sky2
May 12 09:04:28 gpu01 kernel: [ 3000.040025] Pid: 0, comm: swapper Not
tainted 2.6.27.21-atlas-generic-noinitrd #1
May 12 09:04:28 gpu01 kernel: [ 3000.040027]
May 12 09:04:28 gpu01 kernel: [ 3000.040028] Call Trace:
May 12 09:04:28 gpu01 kernel: [ 3000.040030]  <IRQ>
[<ffffffff80237378>] warn_slowpath+0xb4/0xdc
May 12 09:04:28 gpu01 kernel: [ 3000.040037]  [<ffffffff804d2d00>]
sk_filter+0x10/0x80
May 12 09:04:28 gpu01 kernel: [ 3000.040040]  [<ffffffff804e7b1a>]
ip_route_input+0x63e/0xedf
May 12 09:04:28 gpu01 kernel: [ 3000.040044]  [<ffffffff803bf7b9>]
__next_cpu+0x19/0x26
May 12 09:04:28 gpu01 kernel: [ 3000.040048]  [<ffffffff802302e7>]
find_busiest_group+0x315/0x7c3
May 12 09:04:28 gpu01 kernel: [ 3000.040051]  [<ffffffff80232203>]
try_to_wake_up+0x165/0x177
May 12 09:04:28 gpu01 kernel: [ 3000.040054]  [<ffffffff8022f0ce>]
enqueue_task_fair+0xd8/0x130
May 12 09:04:28 gpu01 kernel: [ 3000.040057]  [<ffffffff804df6ed>]
dev_watchdog+0x121/0x1b8
May 12 09:04:28 gpu01 kernel: [ 3000.040060]  [<ffffffff80232203>]
try_to_wake_up+0x165/0x177
May 12 09:04:28 gpu01 kernel: [ 3000.040062]  [<ffffffff804df5cc>]
dev_watchdog+0x0/0x1b8
May 12 09:04:28 gpu01 kernel: [ 3000.040065]  [<ffffffff8023fa06>]
run_timer_softirq+0x16e/0x1ee
May 12 09:04:28 gpu01 kernel: [ 3000.040069]  [<ffffffff8024c075>]
ktime_get_ts+0x21/0x49
May 12 09:04:28 gpu01 kernel: [ 3000.040072]  [<ffffffff8023bfad>]
__do_softirq+0x6a/0xda
May 12 09:04:28 gpu01 kernel: [ 3000.040075]  [<ffffffff8021163c>]
call_softirq+0x1c/0x28
May 12 09:04:28 gpu01 kernel: [ 3000.040078]  [<ffffffff802130fb>]
do_softirq+0x3c/0x81
May 12 09:04:28 gpu01 kernel: [ 3000.040082]  [<ffffffff80220326>]
smp_apic_timer_interrupt+0x8e/0xa7
May 12 09:04:28 gpu01 kernel: [ 3000.040085]  [<ffffffff80210e43>]
apic_timer_interrupt+0x83/0x90
May 12 09:04:28 gpu01 kernel: [ 3000.040086]  <EOI>
[<ffffffff802170e2>] mwait_idle+0x3c/0x46
May 12 09:04:28 gpu01 kernel: [ 3000.040092]  [<ffffffff8020ee32>]
cpu_idle+0x91/0xd1
May 12 09:04:28 gpu01 kernel: [ 3000.040094]
May 12 09:04:28 gpu01 kernel: [ 3000.040096] ---[ end trace
da19323bcd799bc5 ]---
May 12 09:04:28 gpu01 kernel: [ 3000.040098] sky2 eth0: tx timeout
May 12 09:04:28 gpu01 kernel: [ 3000.048993] sky2 eth0: transmit ring
348 .. 308 report=348 done=348
May 12 09:04:28 gpu01 kernel: [ 3000.049017] sky2 eth0: disabling interface
May 12 09:04:28 gpu01 kernel: [ 3000.053439] sky2 eth0: enabling interface
May 12 09:04:31 gpu01 kernel: [ 3003.153938] sky2 eth0: Link is up at
1000 Mbps, full duplex, flow control rx

After this it takes a couple of minutes until the NIC reports back to
ping requests.

Anyone an idea what this is about?

TIA

Carsten
