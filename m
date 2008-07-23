Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbYGWG7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbYGWG7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 02:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYGWG7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 02:59:06 -0400
Received: from smtp-out13.tpgi.com.au ([220.244.226.123]:45107 "EHLO
	mail13.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751137AbYGWG7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 02:59:05 -0400
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 02:59:04 EDT
X-TPG-Antivirus: Passed
Subject: kernel crunch to a halt with e1000e driver
From: Will Trives <will@trivescon.com.au>
To: linux-kernel@vger.kernel.org
Cc: e1000-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Wed, 23 Jul 2008 16:34:11 +1000
Message-Id: <1216794851.4074.42.camel@Athas>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys,

Latest linux git tree, noticed the e1000 driver no longer worked with my
pci express nic. e1000e works but has the following bug...

Problem: When system grinds to a halt when unplugging the cord from the
nic.

Let me know if you need any more info.

Kernel Message:

ul 23 15:59:28 Athas eth0: Link is Up 1000 Mbps Full Duplex, Flow
Control: None
Jul 23 15:59:28 Athas ------------[ cut here ]------------
Jul 23 15:59:28 Athas kernel BUG at net/core/dev.c:1328!
Jul 23 15:59:28 Athas invalid opcode: 0000 [1] SMP
Jul 23 15:59:28 Athas CPU 1
Jul 23 15:59:28 Athas Modules linked in: xt_MARK ipt_REDIRECT xt_state
xt_TCPMSS xt_tcpudp iptable_mangle iptable_nat n$
Jul 23 15:59:28 Athas Pid: 12, comm: events/1 Not tainted 2.6.26 #1
Jul 23 15:59:28 Athas RIP: 0010:[<ffffffff8038db39>]
[<ffffffff8038db39>] __netif_schedule+0xa/0x4b
Jul 23 15:59:28 Athas RSP: 0018:ffff88019fd0fe30  EFLAGS: 00010246
Jul 23 15:59:28 Athas RAX: ffff88019f6f2b90 RBX: 0000000000000000 RCX:
ffff88019f6f2b80
Jul 23 15:59:28 Athas RDX: 00000000ffffffff RSI: 0000000000000286 RDI:
ffffffff805cfac0
Jul 23 15:59:28 Athas RBP: ffff88019eddc640 R08: 00000000000013ba R09:
ffff88019fc66858
Jul 23 15:59:28 Athas R10: 0000000000000400 R11: 0000000000400000 R12:
0000000000000000
Jul 23 15:59:28 Athas R13: 0000000000000000 R14: ffff88019eddc970 R15:
ffff88019eddc000
Jul 23 15:59:28 Athas FS:  0000000000000000(0000)
GS:ffff88019fc09480(0000) knlGS:0000000000000000
Jul 23 15:59:28 Athas CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Jul 23 15:59:28 Athas CR2: 00007f74831d6030 CR3: 0000000192a46000 CR4:
00000000000006e0
Jul 23 15:59:28 Athas DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
Jul 23 15:59:28 Athas DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
Jul 23 15:59:28 Athas Process events/1 (pid: 12, threadinfo
ffff88019fd0e000, task ffff88019fc66820)
Jul 23 15:59:28 Athas Stack:  0000000000000000 ffffffffa00d66e9
ffffffff807b0bc0 ffff88019f6f2940
Jul 23 15:59:28 Athas 0000000000000286 0000000000000000 0000000000000202
000000009fc62ca0
Jul 23 15:59:28 Athas ffff88019eddc968 ffff88019fc09880 ffffffffa00d626d
ffff88019fc09888
Jul 23 15:59:28 Athas Call Trace:
Jul 23 15:59:28 Athas [<ffffffffa00d66e9>] ? e1000_watchdog_task
+0x47c/0x695 [e1000e]
Jul 23 15:59:28 Athas [<ffffffffa00d626d>] ? e1000_watchdog_task
+0x0/0x695 [e1000e]
Jul 23 15:59:28 Athas [<ffffffff8023c8cd>] ? run_workqueue+0x7a/0x100
Jul 23 15:59:28 Athas [<ffffffff8023cbce>] ? worker_thread+0x96/0xa5
Jul 23 15:59:28 Athas [<ffffffff8023fcbf>] ? autoremove_wake_function
+0x0/0x2e
Jul 23 15:59:28 Athas [<ffffffff8023cb38>] ? worker_thread+0x0/0xa5
Jul 23 15:59:28 Athas [<ffffffff8023f9b1>] ? kthread+0x47/0x73
Jul 23 15:59:28 Athas [<ffffffff8022c35f>] ? schedule_tail+0x27/0x5f
Jul 23 15:59:28 Athas [<ffffffff8020cd99>] ? child_rip+0xa/0x11
Jul 23 15:59:28 Athas [<ffffffff8023f96a>] ? kthread+0x0/0x73
Jul 23 15:59:28 Athas [<ffffffff8020cd8f>] ? child_rip+0x0/0x11
Jul 23 15:59:28 Athas
Jul 23 15:59:28 Athas
Jul 23 15:59:28 Athas Code: 00 00 48 63 80 48 e0 ff ff a9 00 00 ff 0f 75
07 9c 58 f6 c4 02 75 05 e9 9f ff ff ff e9 cb a$
Jul 23 15:59:28 Athas RIP  [<ffffffff8038db39>] __netif_schedule
+0xa/0x4b
Jul 23 15:59:28 Athas RSP <ffff88019fd0fe30>
Jul 23 15:59:28 Athas ---[ end trace 3accc2d688eaad80 ]---


Lspci -vv 

2:00.0 Ethernet controller: Intel Corporation 82572EI Gigabit Ethernet
Controller (Copper) (rev 06)
        Subsystem: Intel Corporation PRO/1000 PT Desktop Adapter
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 216
        Region 0: Memory at f8020000 (32-bit, non-prefetchable)
[size=128K]
        Region 1: Memory at f8000000 (32-bit, non-prefetchable)
[size=128K]
        Region 2: I/O ports at b000 [size=32]
        [virtual] Expansion ROM at fb300000 [disabled] [size=128K]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0
+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable+
                Address: 00000000fee0f00c  Data: 41b9
        Capabilities: [e0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s,
Latency L0 <4us, L1 <64us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [140] Device Serial Number 8d-bf-0b-ff-ff-17-15-00

Desg: 
eth0: (PCI Express:2.5GB/s:Width x1) 00:xx:xx:xx:xx:xx
eth0: Intel(R) PRO/1000 Network Connection
eth0: MAC: 1, PHY: 4, PBA No: d50854-001


Regards,

Will Trives

