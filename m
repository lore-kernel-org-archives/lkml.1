Return-Path: <linux-kernel-owner+w=401wt.eu-S965583AbXCLNqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965583AbXCLNqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965616AbXCLNqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:46:38 -0400
Received: from mx3.aixit.com ([82.149.224.22]:33142 "EHLO mx3.aixit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965583AbXCLNqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:46:37 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2007 09:46:37 EDT
X-Qmail-Scanner-Mail-From: lk@stresslinux.org via mx3
X-Qmail-Scanner: 1.25 (Clear:RC:1(82.149.224.60):. Processed in 0.135404 secs)
Message-ID: <45F5582C.1050100@stresslinux.org>
Date: Mon, 12 Mar 2007 14:39:56 +0100
From: Stresslinux Kernel <lk@stresslinux.org>
User-Agent: Thunderbird 2.0pre (X11/20070214)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.20.2: kernel BUG at fs/nfs/write.c:505!
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello List,

running the following command

/sbin/grub-install --root-directory=/mnt --no-floppy /dev/sda

from a nfsroot system with kernel 2.6.20.2 (x86_64) results in:

------------[ cut here ]------------
kernel BUG at fs/nfs/write.c:505!
invalid opcode: 0000 [1] SMP
CPU 0
Modules linked in: ipv6 genrtc
Pid: 1464, comm: grub-install Not tainted 2.6.20.2 #1
RIP: 0010:[<ffffffff8032fb83>]  [<ffffffff8032fb83>] nfs_wait_on_requests_locked+0x43/0xb2
RSP: 0018:ffff81007d669ca8  EFLAGS: 00010246
RAX: 00000000fffff0ba RBX: 0000000000000000 RCX: ffffffff802917aa
RDX: 0000000000000000 RSI: ffff81007d669cb0 RDI: ffff810002f5f9d8
RBP: ffff810002f5f898 R08: 0000000000000001 R09: 0000000000000286
R10: 7fffffffffffffff R11: 0000000000000286 R12: 74d83948d2310001
R13: 0000000000000000 R14: ffffffffffffffff R15: 0000000000000000
FS:  00002b24eb8214a0(0000) GS:ffffffff809d6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000596d88 CR3: 000000007d594000 CR4: 00000000000006e0
Process grub-install (pid: 1464, threadinfo ffff81007d668000, task ffff81007e885840)
Stack:  ffff810002f5f898 ffffffff802917aa 0000000000000000 ffff810002f5fb58
 0000000000000020 ffff810002f5f898 ffff81007d669da8 ffffffff80331245
 000000000000002e ffff81007d669e48 0000000000000020 0000000000000000
Call Trace:
 [<ffffffff802917aa>] bd_forget+0x8d/0x8e
 [<ffffffff80331245>] nfs_sync_mapping_wait+0xbe/0x1ec
 [<ffffffff80331486>] nfs_sync_mapping_range+0x80/0xa1
 [<ffffffff80328a1c>] nfs_getattr+0x2e/0x9b
 [<ffffffff80272313>] vfs_getattr+0x1d/0x2b
 [<ffffffff802723aa>] vfs_lstat_fd+0x2f/0x47
 [<ffffffff8021c3ce>] do_page_fault+0x279/0x572
 [<ffffffff80237c17>] do_sigaction+0x6b/0x1b0
 [<ffffffff8027270a>] sys_newlstat+0x19/0x31
 [<ffffffff807231ed>] error_exit+0x0/0x84
 [<ffffffff80209dde>] system_call+0x7e/0x83


Code: 0f 0b eb fe f0 ff 41 44 c7 85 18 01 00 00 01 00 00 00 48 8b
RIP  [<ffffffff8032fb83>] nfs_wait_on_requests_locked+0x43/0xb2
 RSP <ffff81007d669ca8>


The nfsroot contains a debootstraped version of debian 3.1 amd64.


My hardware:
a MSI Barebone system -> http://www.msi-computer.de/produkte/bare_idx_view.php?Prod_id=515

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      :               Intel(R) Pentium(R) 4 CPU 3.06GHz
stepping        : 9
cpu MHz         : 3059.077
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush
dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm constant_tsc pni monitor ds_cpl tm2 cid cx16 xtpr
lahf_lm
bogomips        : 6123.63
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      :               Intel(R) Pentium(R) 4 CPU 3.06GHz
stepping        : 9
cpu MHz         : 3059.077
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush
dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm constant_tsc pni monitor ds_cpl tm2 cid cx16 xtpr
lahf_lm
bogomips        : 6118.50
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:

0000:00:00.0 Host bridge: Intel Corporation 82915G/P/GV/GL/PL/910GL Memory Controller Hub (rev 0e)
0000:00:02.0 VGA compatible controller: Intel Corporation 82915G/GV/910GL Integrated Graphics
Controller (rev 0e)
0000:00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #1 (rev 04)
0000:00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #2 (rev 04)
0000:00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #3 (rev 04)
0000:00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #4 (rev 04)
0000:00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB2 EHCI
Controller (rev 04)
0000:00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d4)
0000:00:1f.0 ISA bridge: Intel Corporation 82801FB/FR (ICH6/ICH6R) LPC Interface Bridge (rev 04)
0000:00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) IDE Controller
(rev 04)
0000:00:1f.2 IDE interface: Intel Corporation 82801FB/FW (ICH6/ICH6W) SATA Controller (rev 04)
0000:00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus Controller (rev 04)
0000:02:06.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet Controller (rev 05)


