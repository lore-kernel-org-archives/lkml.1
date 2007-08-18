Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbXHRKLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbXHRKLM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 06:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXHRKLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 06:11:01 -0400
Received: from baldrick.fusednetworks.co.uk ([83.142.228.48]:37066 "EHLO
	baldrick.fusednetworks.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751913AbXHRKK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 06:10:59 -0400
Message-ID: <46C6C145.70506@abacustree.com>
Date: Sat, 18 Aug 2007 10:52:05 +0100
From: Chris Boot <chris.boot@abacustree.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Panic with XFS on RHEL5 (2.6.18-8.1.8.el5)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All,

I've got a box running RHEL5 and haven't been impressed by ext3 
performance on it (running of a 1.5TB HP MSA20 using the cciss driver). 
I compiled XFS as a module and tried it out since I'm used to using it 
on Debian, which runs much more efficiently. However, every so often the 
kernel panics as below. Apologies for the tainted kernel, but we run 
VMware Server on the box as well.

Does anyone have any hits/tips for using XFS on Red Hat? What's causing 
the panic below, and is there a way around this?

Many thanks,
Chris Boot

BUG: unable to handle kernel paging request at virtual address b8af9d60
 printing eip:
c0415974
*pde = 00000000
Oops: 0000 [#1]
SMP 
last sysfs file: /block/loop7/dev
Modules linked in: loop nfsd exportfs lockd nfs_acl iscsi_trgt(U) 
autofs4 hidp nls_utf8 cifs ppdev rfcomm l2cap bluetooth vmnet(U) 
vmmon(U) sunrpc ipv6 xfs(U) video sbs i2c_ec button battery asus_acpi ac 
lp st sg floppy serio_raw intel_rng pcspkr e100 mii e7xxx_edac i2c_i801 
edac_mc i2c_core e1000 r8169 ide_cd cdrom parport_pc parport dm_snapshot 
dm_zero dm_mirror dm_mod cciss mptspi mptscsih scsi_transport_spi sd_mod 
scsi_mod mptbase ext3 jbd ehci_hcd ohci_hcd uhci_hcd
CPU:    1
EIP:    0060:[<c0415974>]    Tainted: P      VLI
EFLAGS: 00010046   (2.6.18-8.1.8.el5 #1) 
EIP is at smp_send_reschedule+0x3/0x53
eax: c213f000   ebx: c213f000   ecx: eef84000   edx: c213f000
esi: 00001086   edi: f668c000   ebp: f4f2fce8   esp: f4f2fc8c
ds: 007b   es: 007b   ss: 0068
Process crond (pid: 3146, ti=f4f2f000 task=f51faaa0 task.ti=f4f2f000)
Stack: 66d66b89 c041dc23 00000000 a9afbb0e fffffea5 01904500 00000000 
0000000f 
       00000000 00000001 00000001 c200c6e0 00000100 00000000 00000069 
00000180 
       018fc500 c200d240 00000003 00000292 f601efc0 f6027e00 00000000 
00000050 
Call Trace:
 [<c041dc23>] try_to_wake_up+0x351/0x37b
 [<f936884e>] xfsbufd_wakeup+0x28/0x49 [xfs]
 [<c04572f9>] shrink_slab+0x56/0x13c
 [<c0457c0c>] try_to_free_pages+0x162/0x23e
 [<c0454064>] __alloc_pages+0x18d/0x27e
 [<c045214e>] find_or_create_page+0x53/0x8c
 [<c046c7b1>] __getblk+0x162/0x270
 [<c0475be0>] do_lookup+0x53/0x157
 [<f889138f>] ext3_getblk+0x7c/0x233 [ext3]
 [<f88913fe>] ext3_getblk+0xeb/0x233 [ext3]
 [<c048215c>] mntput_no_expire+0x11/0x6a
 [<f889226e>] ext3_bread+0x13/0x69 [ext3]
 [<f8895606>] htree_dirblock_to_tree+0x22/0x113 [ext3]
 [<f889574f>] ext3_htree_fill_tree+0x58/0x1a0 [ext3]
 [<c047828b>] do_path_lookup+0x20e/0x25f
 [<c046b987>] get_empty_filp+0x99/0x15e
 [<f889d611>] ext3_permission+0x0/0xa [ext3]
 [<f888eaa3>] ext3_readdir+0x1ce/0x59b [ext3]
 [<c047a0dd>] filldir+0x0/0xb9
 [<c0472973>] sys_fstat64+0x1e/0x23
 [<c047a1f9>] vfs_readdir+0x63/0x8d
 [<c047a0dd>] filldir+0x0/0xb9
 [<c047a447>] sys_getdents+0x5f/0x9c
 [<c0403eff>] syscall_call+0x7/0xb
 =======================
Code: 5d c3 b9 01 00 00 00 31 d2 6a 00 b8 f0 5a 41 c0 e8 2a ff ff ff fa 
e8 52 16 00 00 fb 58 c3 b8 54 3a 66 c0 e9 8e 6b 1e 00 53 89 c3 <0f> a3 
05 60 1f 6d c0 19 c0 85 c0 75 27 e8 bf db 00 00 50 68 55 
EIP: [<c0415974>] smp_send_reschedule+0x3/0x53 SS:ESP 0068:f4f2fc8c
 <0>Kernel panic - not syncing: Fatal exception

