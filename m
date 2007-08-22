Return-Path: <linux-kernel-owner+w=401wt.eu-S1762727AbXHVNW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762727AbXHVNW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 09:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762157AbXHVNWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 09:22:22 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:60719 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760979AbXHVNWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 09:22:11 -0400
Message-ID: <46CC387D.4000605@linux.vnet.ibm.com>
Date: Wed, 22 Aug 2007 18:52:05 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.23-rc3-mm1 Oops: Machine check, sig: 7 [#1]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Following oops is generated on ppc64 machine while booting with
the 2.6.23-rc3-mm1 kernel.

===========================================================
[    5.341499] PowerMac i2c bus u3 0 registered
[    5.354201] TCP cubic registered
[    5.364880] input: PMU as /class/input/input0
[    5.400152] RAMDISK: cramfs filesystem found at block 0
[    5.414336] RAMDISK: Loading 4688KiB [1 disk] into ram disk... done.
[    5.533921] VFS: Mounted root (cramfs filesystem) readonly.
[    5.549385] Machine check in kernel mode.
[    5.560880] Caused by (from SRR1=9000000000009032): Transfer error 
ack signal
[    5.578607] Oops: Machine check, sig: 7 [#1]
[    5.590736] SMP NR_CPUS=32 NUMA PowerMac
[    5.602052] Modules linked in:
[    5.611551] NIP: c000000000279ee0 LR: c0000000000ab1c4 CTR: 
c000000000092cc8
[    5.629323] REGS: c00000000dcdf040 TRAP: 0200   Not tainted  
(2.6.23-rc3-mm1-autokern1)
[    5.653218] MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 24000022  XER: 
00000000
[    5.671260] TASK = c00000000e176000[774] 'linuxrc' THREAD: 
c00000000dcdc000 CPU: 0
[    5.690056] GPR00: c00000000e207b08 c00000000dcdf2c0 c0000000005bfac0 
c00000000e207848
[    5.714493] GPR04: c00000000e10fb08 c00000000e207900 c00000000e2078f8 
c00000000e2078f8
[    5.739017] GPR08: 0000000000000000 c00000000e2078f8 c00000000e2078f8 
0000000000000000
[    5.763600] GPR12: c00000000e2078f8 c000000000505280 0000000010028230 
0000000000000000
[    5.788276] GPR16: 0000000000000002 0000000000000000 0000000000000000 
0000000000000802
[    5.813137] GPR20: 0000000000029000 0000000000000029 0000000000000000 
0000000000000001
[    5.838609] GPR24: 0000000000000000 c00000000e10fb00 c00000000e2078f8 
c00000000e10fb08
[    5.864713] GPR28: c00000000e207848 c00000000e207848 c00000000055af48 
c00000000e207b08
[    5.897143] NIP [c000000000279ee0] .rb_insert_color+0x5c/0x194
[    5.914305] LR [c0000000000ab1c4] .__vma_link_rb+0x30/0x44
[    5.930736] Call Trace:
[    5.941092] [c00000000dcdf2c0] [c00000000e004580] 0xc00000000e004580 
(unreliable)
[    5.966930] [c00000000dcdf360] [c0000000000ab1c4] 
.__vma_link_rb+0x30/0x44
[    5.986182] [c00000000dcdf3e0] [c0000000000ab230] .__vma_link+0x58/0x78
[    6.004896] [c00000000dcdf460] [c0000000000ab79c] .vma_link+0x94/0x1b8
[    6.023345] [c00000000dcdf510] [c0000000000ada44] 
.mmap_region+0x330/0x4d8
[    6.042415] [c00000000dcdf620] [c000000000011fcc] .elf_map+0xb8/0x19c
[    6.060511] [c00000000dcdf6d0] [c000000000013064] 
.load_elf_binary+0xfb4/0x1a4c
[    6.085519] [c00000000dcdf830] [c0000000000d0c1c] 
.search_binary_handler+0x104/0x310
[    6.111417] [c00000000dcdf8e0] [c000000000111cc0] 
.load_script+0x278/0x2b4
[    6.130289] [c00000000dcdfa10] [c0000000000d0c1c] 
.search_binary_handler+0x104/0x310
[    6.155961] [c00000000dcdfac0] [c0000000000d0fac] .do_execve+0x184/0x244
[    6.174367] [c00000000dcdfb70] [c00000000000f278] .sys_execve+0x70/0xf4
[    6.192490] [c00000000dcdfc10] [c00000000000852c] syscall_exit+0x0/0x40
[    6.210486] --- Exception: c01 at .kernel_execve+0x8/0x14
[    6.226093]     LR = .do_linuxrc+0xa4/0xc0
[    6.239060] [c00000000dcdff00] [c0000000004b31f4] 
.do_linuxrc+0x90/0xc0 (unreliable)
[    6.263900] [c00000000dcdff90] [c000000000023ef4] 
.kernel_thread+0x4c/0x68
[    6.282270] Instruction dump:
[    6.292794] e97f0010 7fa95800 409e0070 e97f0008 2fab0000 419e0010 
e80b0000 780807e1
[    6.317509] 4182006c eba90008 7fbde000 409e0018 <7d234b78> 7f64db78 
7d3c4b78 4bffff1d

Thanks & Regards,
Kamalesh Babulal.
