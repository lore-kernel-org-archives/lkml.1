Return-Path: <linux-kernel-owner+w=401wt.eu-S1762508AbXHAH73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762508AbXHAH73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758380AbXHAH7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:59:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:13074 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905AbXHAH7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:59:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dEvdZTdraBwjBuDIasDZ7qPg8hwYVlKhj47Ctzc6k8prY+bDtEPv2hAK0BhUT0j1t4gU/jmA+G4dO0URkhZum9bVdvIlA3Rz/Nk0QE5fC3iD+rfh0F9gRd+r3uKYNatfhkEFd1swyYEgqTBfJMl3HCE+9Kw2HNj1P3DPIuozdVw=
Message-ID: <a307c1910708010059l6c2c9df0n4ad9d0197eaba0f@mail.gmail.com>
Date: Wed, 1 Aug 2007 13:29:18 +0530
From: "Gireesh Kumar M" <gireesh.mnair@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: request_module() fails
In-Reply-To: <a307c1910708010011l57dbee87hb0d9a725ac259966@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a307c1910708010011l57dbee87hb0d9a725ac259966@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to load some modules upon occurance of a GPIO interrupt.
The ISR checks some register and then schedules a tasklet to act
further on the interrupt.
Inside the tasklet, I call request_module to load a driver. But, here
it's failing. Please see the error log pasted below.
When I tried to load the same module using modprobe and it works fine. I
have edited modules.dep with an entry for my module.

[Note:] The kernel modules installed on the rootfs are from a
different kernel version. So I don't see an entry in /lib/modules/<my
kernel name>. Instead, the rootfs has a different
entry(/lib/modules/<default-kernel>)
Since I have a different kernel version, the "uname -r" gives <my
kernel name> and since that entry is not in /lib/modules/; modprobe
was failing initially.
I fixed this by creating a soft link called /lib/modules/<my kernel
name> that points to /lib/modules/<default-kernel>
After this modification, modprobe worked fine.

Kindly help me if anyone has a clue.

Kernel version: 2.6.10
Architecture: ARM

Thank you,
Gireesh


 =====Error Log=========================================
root@10.24.241.113:/home/gireesh/test_mod# insmod test_mod.ko pin_a=0 pin_b=2
Test module inserted
irq registered successfully

[gireesh] then I generated the interrupt and what I see is as follows.
"In tasklet" is the message I'm printing from the tasklet.

root@10.24.241.113:/home/gireesh/test_mod # In tasklet
BUG: scheduling while atomic: swapper/0x00000103/0
caller is schedule+0xec/0x12c
BUG: scheduling from the idle thread!
Unable to handle kernel NULL pointer dereference at virtual address 00000004
pgd = c0004000
[00000004] *pgd=00000000
Internal error: Oops: 17 [#1]
Modules linked in: test_mod dsplinkk
CPU: 0
PC is at dequeue_task+0xc/0x78
LR is at deactivate_task+0x28/0x34
pc : [<c003c128>]    lr : [<c003c464>]    Tainted: PF
sp : c027fca0  ip : c027fcb0  fp : c027fcac
r10: c027e000  r9 : c02d94f0  r8 : c02800c0
r7 : c027e000  r6 : c027fde4  r5 : c027fd5c  r4 : c02800c0
r3 : 00000001  r2 : 00000000  r1 : 00000000  r0 : c02800c0
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  Segment kernel
Control: 5317F  Table: 80FD8000  DAC: 00000017
Process swapper (pid: 0, stack limit = 0xc027e1a0)
Stack: (0xc027fca0 to 0xc0280000)
fca0: c027fcc4 c027fcb0 c003c464 c003c12c c0239168 c0239168 c027fd14 c027fcc8
fcc0: c0238c24 c003c44c 00000000 20000093 c027fcfc 03938700 f4e31f00 0000049a
fce0: c0369ed0 c028021c 00000000 c027e000 c027fd5c c027fde4 c027e000 c027fde0
fd00: c02d6ca0 c02de780 c027fd34 c027fd18 c0239168 c0238a50 c02d6ca0 c027fd48
fd20: c027fd5c c027fd48 c027fd8c c027fd38 c02392fc c023908c 00000000 c02800c0
fd40: c003d00c 00000000 00000000 c0238ffc 00000001 c02800c0 c003d00c c027fde4
fd60: c027fde4 c027fde0 c027fd8c c028334c c027fd90 c027fde0 c02de7d0 0000000a
fd80: c027fe0c c027fd90 c0052898 c023923c 00000001 c0369ec8 c0369ec8 c0052774
fda0: c027fdc8 c0369ec0 00000000 00000000 00000000 4b87ad6e 00000000 00000000
fdc0: 00000000 00000000 c027fde0 c028334c c027fe10 c028344c 00000001 00000000
fde0: 00000000 c027fd5c c027fd5c c027fe28 c02de7d0 c02e0240 c02e0244 c027fe28
fe00: c027fe84 c027fe10 c00529b0 c00527f8 c028334c c0244588 c024458c c027fe28
fe20: 00000000 00000000 6273756d 7264685f c0280063 0000000b c027fe74 c027fe48
fe40: c0041c44 c0041840 c0041c44 c027feac e1048000 00000000 c02de7a4 00000001
fe60: c02de7d0 0000000a c027fe84 00000000 c02de7a4 00000001 c027fea4 c027fe98
fe80: bf012360 c00528c8 bf0124b8 c027e000 00000000 00000000 c027febc c027fea8
fea0: c00469a0 bf012344 c027e000 00000103 c027fee4 c027fec0 c0046458 c0046930
fec0: c027e000 00000000 ffffffff 00000002 c027e000 c027ff50 c027fefc c027fee8
fee0: c0046534 c0046414 c027e000 c027e000 c027ff14 c027ff00 c00466ec c004650c
ff00: c027e000 c027ff84 c027ff4c c027ff18 c002d320 c00466b0 c003c424 c003c27c
ff20: 00000000 c027ff84 e1048000 ffffffff 00000002 c027e000 00000001 800240f8
ff40: c027ffac c027ff50 c002b5e0 c002d210 00000000 0005317f 0005217f 60000013
ff60: c027e000 60000093 c02812a8 c02fa450 80024128 41069265 800240f8 c027ffac
ff80: c027ff98 c027ff98 c002ddfc c002de0c 60000013 ffffffff c027e000 c002dd94
ffa0: c027ffcc c027ffb0 c002de78 c002dda4 c027ffcc 00053175 c02d67dc c02e13e4
ffc0: c027fffc c027ffd0 c00087d8 c002de24 c0008304 00000000 00000000 c02d7c30
ffe0: 00000000 00053175 c02d7c1c c0280fd0 00000000 c0280000 8000809c c0008660
Backtrace:
[<c003c11c>] (dequeue_task+0x0/0x78) from [<c003c464>]
(deactivate_task+0x28/0x3
4)
[<c003c43c>] (deactivate_task+0x0/0x34) from [<c0238c24>] (__schedule+0x1e4/0x5a
c)
 r4 = C0239168
[<c0238a40>] (__schedule+0x0/0x5ac) from [<c0239168>] (schedule+0xec/0x12c)
[<c023907c>] (schedule+0x0/0x12c) from [<c02392fc>] (wait_for_completion+0xd0/0x
164)
 r4 = C027FD48
[<c023922c>] (wait_for_completion+0x0/0x164) from [<c0052898>] (call_usermodehel
per+0xb0/0xcc)
 r8 = 0000000A  r7 = C02DE7D0  r6 = C027FDE0  r5 = C027FD90
 r4 = C028334C
[<c00527e8>] (call_usermodehelper+0x0/0xcc) from [<c00529b0>] (request_module+0x
fc/0x140)
 r6 = C027FE28  r5 = C02E0244  r4 = C02E0240
[<c00528b4>] (request_module+0x0/0x140) from [<bf012360>] (load_module_tasklet+0
x2c/0x54 [test_mod])
 r3 = 00000000  r2 = 00000000  r1 = C027E000  r0 = BF0124B8
 r6 = 00000001  r5 = C02DE7A4  r4 = 00000000
[<bf012334>] (load_module_tasklet+0x0/0x54 [test_mod]) from [<c00469a0>] (tas
klet_action+0x80/0xcc)
[<c0046920>] (tasklet_action+0x0/0xcc) from [<c0046458>] (___do_softirq+0x54/0xf
8)
 r5 = 00000103  r4 = C027E000
[<c0046404>] (___do_softirq+0x0/0xf8) from [<c0046534>] (__do_softirq+0x38/0x58)
[<c00464fc>] (__do_softirq+0x0/0x58) from [<c00466ec>] (irq_exit+0x4c/0x60)
 r5 = C027E000  r4 = C027E000
[<c00466a0>] (irq_exit+0x0/0x60) from [<c002d320>] (asm_do_IRQ+0x120/0x138)
 r4 = C027FF84
[<c002d200>] (asm_do_IRQ+0x0/0x138) from [<c002b5e0>] (__irq_svc+0x40/0x74)
[<c002dd94>] (default_idle+0x0/0x80) from [<c002de78>] (cpu_idle+0x64/0xac)
 r5 = C002DD94  r4 = C027E000
[<c002de14>] (cpu_idle+0x0/0xac) from [<c00087d8>] (start_kernel+0x188/0x1cc)
 r6 = C02E13E4  r5 = C02D67DC  r4 = 00053175
[<c0008650>] (start_kernel+0x0/0x1cc) from [<8000809c>] (0x8000809c)
Code: e89da800 e1a0c00d e92dd800 e24cb004 (e5913004)
 <0>Kernel panic - not syncing: Aiee, killing interrupt handler!
