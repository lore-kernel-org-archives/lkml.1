Return-Path: <linux-kernel-owner+w=401wt.eu-S1422997AbXDZB7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422997AbXDZB7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 21:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423073AbXDZB7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 21:59:12 -0400
Received: from bromine.webpack.hosteurope.de ([217.115.142.123]:57760 "EHLO
	bromine.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422997AbXDZB7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 21:59:10 -0400
Date: Thu, 26 Apr 2007 03:59:05 +0200
From: speedy <speedy@3d-io.com>
X-Mailer: The Bat! (v3.80.06) Professional
Reply-To: speedy <speedy@3d-io.com>
X-Priority: 3 (Normal)
Message-ID: <1005889901.20070426035905@3d-io.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG REPORT] 2.6.21-rc7 - Yukon-EC Ultra <-> sky2 driver bug(s)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;speedy@3d-io.com;1177549007;43536683;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel: 2.6.21-rc7
Device: Yukon-EC Ultra (0xb4) rev 2 [integrated on Gigabyte GA-965P-DQ6]
OS: Ubuntu 7.04 (Feisty Fawn)

Description: 

The driver reports rx errors, drops carrier due to HW error, rmmod/modprobe combo returns carrier to sane state.. 
after that it works with rx errors for a while, then OOPSes the kernel in different ways each time 
ie. ext3 routines, vma (traversal(?)) or this time in the workqueue. Seemingly, random memory corruption takes place.

I assume a kernel bug because of the recent git commits regarding sky2, the fact Windows XP works flawlessly and
the OOPS itself. Also, that box recently compiled the kernel, so I regard it as stable.

The bug is easily reproducible (*sigh* too easy) and occurs also with Ubuntu default kernel - 2.6.20 with 
Ubuntu patches. After linux boots and crashes, the network card malfunctions even when dual-booted to Windows 
(causing slowness and reboots). It takes power-off/power-on cycle to bring it back to stable state.

Thanks in advance for all help, if you need more info, .config or testing any patches, let me know.

Cheers,
speedy over&out

ps. not subscribed to LKML, plz. keep me in CC:


DMESG output:

[   49.876701] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   49.876713] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   49.876735] sky2 0000:03:00.0: v1.13 addr 0xf9000000 irq 16 Yukon-EC Ultra (0xb4) rev 2
[   49.876887] PM: Adding info for No Bus:eth0
[   49.876939] sky2 eth0: addr 00:16:e6:d7:a6:ea
[   49.888814] sky2 eth0: enabling interface
[   49.891741] sky2 eth0: ram buffer 0K

...

[   52.326154] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[   52.328083] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   53.394751] NET: Registered protocol family 17

...

[   94.584404] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  101.984227] sky2 eth0: rx error, status 0x5ac0002 length 1452
[  102.216648] sky2 eth0: rx error, status 0x5cc0002 length 1484
[  103.182574] sky2 eth0: rx error, status 0x5ac0002 length 1452
[  103.604065] sky2 eth0: rx error, status 0x5ac0002 length 1452
[  103.697021] sky2 eth0: rx error, status 0x5ac0002 length 1452
[  104.244439] sky2 eth0: rx error, status 0x5ac0002 length 1452
[  105.038951] sky2 eth0: rx error, status 0x5ac0002 length 1452
[  105.374538] sky2 eth0: rx error, status 0x5ac0002 length 1452
[  106.878209] sky2 eth0: rx error, status 0x5ac0002 length 1452
[  107.328009] sky2 eth0: rx error, status 0x5ac0002 length 1452
[  107.381861] sky2 eth0: rx error, status 0x5ac0002 length 1452
[  111.996276] printk: 10 messages suppressed.
[  111.996282] sky2 eth0: rx error, status 0x5ac0002 length 1452
[  118.404802] printk: 12 messages suppressed.
[  118.404808] sky2 eth0: rx error, status 0x5ac0002 length 1452
[  174.080264] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  174.095495] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  174.102641] sky2 eth0: hw error interrupt status 0x8
[  174.102645] sky2 eth0: MAC parity error
[  174.181775] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  176.979478] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  177.244215] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  177.617673] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  177.692007] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  178.214524] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  179.230857] printk: 2 messages suppressed.
[  179.230863] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  184.548409] printk: 9 messages suppressed.
[  184.548415] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  189.247824] printk: 5 messages suppressed.
[  189.247830] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  194.293119] printk: 9 messages suppressed.
[  194.293125] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  196.015470] sky2 eth0: transmit descriptor error (hardware problem)
[  196.015561] sky2 eth0: Link is down.
[  199.212348] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[  199.212354] sky2 eth0: transmit descriptor error (hardware problem)
[  199.212485] sky2 eth0: Link is down.
[  201.858518] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[  201.858525] sky2 eth0: transmit descriptor error (hardware problem)
[  201.858657] sky2 eth0: Link is down.
[  204.644601] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[  204.644608] sky2 eth0: transmit descriptor error (hardware problem)
[  204.644739] sky2 eth0: Link is down.
[  207.396671] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[  207.396679] sky2 eth0: transmit descriptor error (hardware problem)
[  207.396811] sky2 eth0: Link is down.
[  210.131335] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[  210.131342] sky2 eth0: transmit descriptor error (hardware problem)
[  210.131472] sky2 eth0: Link is down.

# rmmod sky2
[  732.141127] sky2 eth0: disabling interface
[  732.185176] PM: Removing info for No Bus:eth0
[  732.185411] ACPI: PCI interrupt for device 0000:03:00.0 disabled

# modprobe sky2
[  736.382683] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[  736.382699] PCI: Setting latency timer of device 0000:03:00.0 to 64
[  736.382726] sky2 0000:03:00.0: v1.13 addr 0xf9000000 irq 16 Yukon-EC Ultra (0xb4) rev 2
[  736.382897] PM: Adding info for No Bus:eth0
[  736.383128] sky2 eth0: addr 00:16:e6:d7:a6:ea
[  736.421304] sky2 eth0: enabling interface
[  736.424573] sky2 eth0: ram buffer 0K
[  736.427868] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  738.797787] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[  738.800674] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

[  957.648281] printk: 4 messages suppressed.
[  957.648288] sky2 eth0: rx error, status 0x5cb0002 length 1483
[  957.883434] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  958.465500] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  959.239677] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  959.774463] sky2 eth0: rx error, status 0x5ea0002 length 1514
[  960.229511] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  961.852139] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  962.690813] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  963.353618] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  965.046971] sky2 eth0: rx error, status 0x5ea0002 length 1514
[  965.872358] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  967.840302] printk: 2 messages suppressed.
[  967.840308] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  972.825309] printk: 4 messages suppressed.
[  972.825316] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  977.975694] printk: 9 messages suppressed.
[  977.975701] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  984.203903] printk: 9 messages suppressed.
[  984.203909] sky2 eth0: rx error, status 0x5ea0002 length 1514
[  987.769380] printk: 7 messages suppressed.
[  987.769387] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  993.097435] printk: 5 messages suppressed.
[  993.097441] sky2 eth0: rx error, status 0x5ca0002 length 1482
[  999.663068] printk: 12 messages suppressed.
[  999.663073] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1003.151110] printk: 6 messages suppressed.
[ 1003.151116] sky2 eth0: rx error, status 0x5ea0002 length 1514
[ 1007.813964] printk: 10 messages suppressed.
[ 1007.813971] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1013.231059] printk: 6 messages suppressed.
[ 1013.231066] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1017.859598] printk: 9 messages suppressed.
[ 1017.859604] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1022.980511] printk: 5 messages suppressed.
[ 1022.980518] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1027.733932] printk: 7 messages suppressed.
[ 1027.733939] sky2 eth0: rx error, status 0x5ea0002 length 1514
[ 1032.829627] printk: 5 messages suppressed.
[ 1032.829634] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1037.981660] printk: 11 messages suppressed.
[ 1037.981666] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1043.129533] printk: 6 messages suppressed.
[ 1043.129540] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1047.694229] printk: 6 messages suppressed.
[ 1047.694235] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1052.802942] printk: 7 messages suppressed.
[ 1052.802948] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1058.005130] printk: 10 messages suppressed.
[ 1058.005136] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1063.032224] printk: 3 messages suppressed.
[ 1063.032230] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1068.809544] printk: 9 messages suppressed.
[ 1068.809551] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1073.043609] printk: 5 messages suppressed.
[ 1073.043616] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1078.014996] printk: 10 messages suppressed.
[ 1078.015003] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1085.171209] printk: 3 messages suppressed.
[ 1085.171215] sky2 eth0: rx error, status 0x5ca0002 length 1482
[ 1089.222356] printk: 5 messages suppressed.
[ 1089.222363] sky2 eth0: rx error, status 0x5ca0002 length 1482

tankgirl kernel: [ 1154.388660] ------------[ cut here ]------------

Message from syslogd@tankgirl at Thu Apr 26 01:06:54 2007 ...
tankgirl kernel: [ 1154.388670] invalid opcode: 0000 [#1]

Message from syslogd@tankgirl at Thu Apr 26 01:06:54 2007 ...
tankgirl kernel: [ 1154.388672] SMP 

Message from syslogd@tankgirl at Thu Apr 26 01:06:54 2007 ...
tankgirl kernel: [ 1154.388771] CPU:    1

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388772] EIP:    0060:[free_block+291/304]    Not tainted VLI

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388774] EFLAGS: 00010046   (2.6.21-rc7 #1)

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388782] EIP is at free_block+0x123/0x130

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388786] eax: 80000000   ebx: df67b294   ecx: f9ad37a3   edx: c1735a60

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388790] esi: df67b280   edi: 05490ca1   ebp: df67b294   esp: c2115efc

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388794] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388798] Process events/1 (pid: 9, ti=c2114000 task=dd614a90 task.ti=c2114000)

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388801] Stack: 00000048 c20f1540 05490ca1 df5800c0 00000000 df67b294 df67b280 05490ca1 

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388811]        df675300 c01755af 00000000 df5800c0 df675300 df5800c0 c2015660 00000292 

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388822]        c0176b39 00000000 00000000 c2015664 dd6242c0 c2015660 c01361e4 00000000 

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388831] Call Trace:

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388848]  [drain_array+95/208] drain_array+0x5f/0xd0

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388862]  [cache_reap+137/288] cache_reap+0x89/0x120

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388874]  [run_workqueue+148/320] run_workqueue+0x94/0x140

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388889]  [cache_reap+0/288] cache_reap+0x0/0x120

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388899]  [worker_thread+327/368] worker_thread+0x147/0x170

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388913]  [default_wake_function+0/16] default_wake_function+0x0/0x10

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388929]  [worker_thread+0/368] worker_thread+0x0/0x170

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388935]  [kthread+186/240] kthread+0xba/0xf0

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388944]  [kthread+0/240] kthread+0x0/0xf0

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388953]  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388966]  =======================

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.388968] Code: 2b 42 3c 89 f2 89 47 18 8b 44 24 0c e8 77 fe ff ff e9 2f ff ff ff 83 c4 14 5b 5e 5f 5d c3 8b 52 0c 8b 02 84 c0 0f 88 5a ff ff ff <0f> 0b eb fe 89 f6 8d bc 27 00 00 00 00 83 ec 18 85 c9 89 74 24 

Message from syslogd@tankgirl at Thu Apr 26 01:06:55 2007 ...
tankgirl kernel: [ 1154.389015] EIP: [free_block+291/304] free_block+0x123/0x130 SS:ESP 0068:c2115efc

