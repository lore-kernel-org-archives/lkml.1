Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYIXTJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYIXTJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYIXTJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:09:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:24643 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYIXTJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:09:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=yIQqyiZtzy0WLhzcnVYj0IWouVdNfLNcIy1RnLJGdXYaovLmSL7RhkpZLIZ3O5grod
         AAX8YyWeZdd7PpSEZiu2f2sUQy5ncIHj7goS3BPyDv59svLGF2aFhhe3EvyCarC/qyct
         sQ6H2JMfnfFpp00nNl8znqmBN+rXO063m/Mk0=
Message-ID: <19f34abd0809241209l3a69d607v153549ee43e085e9@mail.gmail.com>
Date: Wed, 24 Sep 2008 21:09:13 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: x86@kernel.org
Subject: v2.6.27-rc7: x86: #GP on panic?
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With 2.6.27-rc7 on qemu-x86_64, it seems that panic will trigger a
General Protection Fault. I haven't seen it before.

[    4.499793] VFS: Cannot open root device "hda1" or unknown-block(2,0)
[    4.502747] Please append a correct "root=" boot option; here are
the available partitions:
[    4.506641] 0800    2048000 sda driver: sd
[    4.508987]   0801    1895638 sda1
[    4.511088]   0802          1 sda2
[    4.512858] 0810       2048 sdb driver: sd
[    4.514915] 0b00    1048575 sr0 driver: sr
[    4.519074] Kernel panic - not syncing: VFS: Unable to mount root
fs on unknown-block(2,0)
[    4.523477] general protection fault: fff2 [1] SMP
[    4.523641] CPU 0
[    4.523641] Modules linked in:
[    4.523641] Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc7 #1
[    4.523641] RIP: 0010:[<ffffffff81019d27>]  [<ffffffff81019d27>]
native_smp_send_stop+0x29/0x2d
[    4.523641] RSP: 0018:ffff880007867d70  EFLAGS: 00000286
[    4.523641] RAX: 00000000000000ff RBX: 0000000000000286 RCX: 0000000000000000
[    4.523641] RDX: 0000000000000005 RSI: ffffffff81019ce1 RDI: 0000000000000000
[    4.523641] RBP: ffff880007867d80 R08: 0000000000000000 R09: 0000000000002800
[    4.523641] R10: 0000000000002800 R11: ffff880001020a40 R12: ffff88000705b018
[    4.523641] R13: ffff88000705b000 R14: 0000000000008001 R15: ffffffff8159d550
[    4.523641] FS:  0000000000000000(0000) GS:ffffffff816fae00(0000)
knlGS:0000000000000000
[    4.523641] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    4.523641] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006a0
[    4.523641] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.523641] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[    4.523641] Process swapper (pid: 1, threadinfo ffff880007866000,
task ffff880007868000)
[    4.523641] Stack:  0000000000005131 ffffffff8159d52d
ffff880007867e70 ffffffff810344a4
[    4.523641]  0000003000000010 ffff880007867e80 ffff880007867db0
ffff880007867e80
[    4.523641]  ffff880007867dd0 ffff880007867e80 ffff88000789d360
00000000000050d0
[    4.523641] Call Trace:
[    4.523641]  [<ffffffff810344a4>] panic+0xe8/0x193
[    4.523641]  [<ffffffff8118efaf>] ? kobject_put+0x44/0x49
[    4.523641]  [<ffffffff812177de>] ? put_device+0x15/0x17
[    4.523641]  [<ffffffff8121ad99>] ? class_for_each_device+0xfe/0x10e
[    4.523641]  [<ffffffff81715059>] mount_block_root+0x1ee/0x205
[    4.523641]  [<ffffffff81009417>] ? name_to_dev_t+0x1bb/0xda4
[    4.523641]  [<ffffffff817152cd>] mount_root+0xe5/0xea
[    4.523641]  [<ffffffff81715449>] prepare_namespace+0x177/0x1a4
[    4.523641]  [<ffffffff810aaf2e>] ? putname+0x37/0x39
[    4.523641]  [<ffffffff81714d0f>] kernel_init+0x16a/0x178
[    4.523641]  [<ffffffff8102be33>] ? schedule_tail+0x24/0x5d
[    4.523641]  [<ffffffff8100cf79>] child_rip+0xa/0x11
[    4.523641]  [<ffffffff811b92f4>] ? acpi_ds_init_one_object+0x0/0x88
[    4.523641]  [<ffffffff81714ba5>] ? kernel_init+0x0/0x178
[    4.523641]  [<ffffffff8100cf6f>] ? child_rip+0x0/0x11
[    4.523641]
[    4.523641]
[    4.523641] Code: eb fd 55 48 89 e5 53 51 83 3d 25 e8 78 00 00 75
1a 31 d2 31 f6 48 c7 c7 e1 9c 01 81 e8 f7 a4 03 00 9c 5b fa e8 94 09
00 00 53 9d <5a> 5b c9 c3 55 31 c0 48 89 e5 89 04 25 b0 c0 5f ff 65 83
04 25
[    4.523641] RIP  [<ffffffff81019d27>] native_smp_send_stop+0x29/0x2d
[    4.523641]  RSP <ffff880007867d70>
[    4.523641] ---[ end trace 4eaa2a86a8e2da22 ]---
[    4.523641] swapper used greatest stack depth: 3664 bytes left
[    4.523641] Kernel panic - not syncing: Attempted to kill init!

Maybe this will not wrap. I can at least hope.

ffffffff81019cfe <native_smp_send_stop>:
ffffffff81019cfe:       55                      push   %rbp
ffffffff81019cff:       48 89 e5                mov    %rsp,%rbp
ffffffff81019d02:       53                      push   %rbx
ffffffff81019d03:       51                      push   %rcx
ffffffff81019d04:       83 3d 25 e8 78 00 00    cmpl
$0x0,7923749(%rip)        # ffffffff817a8530 <reboot_force>
ffffffff81019d0b:       75 1a                   jne
ffffffff81019d27 <native_smp_send_stop+0x29>
ffffffff81019d0d:       31 d2                   xor    %edx,%edx
ffffffff81019d0f:       31 f6                   xor    %esi,%esi
ffffffff81019d11:       48 c7 c7 e1 9c 01 81    mov    $0xffffffff81019ce1,%rdi
ffffffff81019d18:       e8 f7 a4 03 00          callq
ffffffff81054214 <smp_call_function>
ffffffff81019d1d:       9c                      pushfq
ffffffff81019d1e:       5b                      pop    %rbx
ffffffff81019d1f:       fa                      cli
ffffffff81019d20:       e8 94 09 00 00          callq
ffffffff8101a6b9 <disable_local_APIC>
ffffffff81019d25:       53                      push   %rbx
ffffffff81019d26:       9d                      popfq
ffffffff81019d27:       5a                      pop    %rdx
ffffffff81019d28:       5b                      pop    %rbx
ffffffff81019d29:       c9                      leaveq
ffffffff81019d2a:       c3                      retq


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
