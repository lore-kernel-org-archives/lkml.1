Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZCUSBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZCUSBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 14:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZCUSBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 14:01:09 -0400
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1256 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbZCUSBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 14:01:04 -0400
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Mar 2009 14:01:03 EDT
Message-ID: <49C52958.7030700@xs4all.nl>
Date: Sat, 21 Mar 2009 18:52:24 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Folkert van Heusden <folkert@vanheusden.com>
Subject: 2.6.28.2 kernel bug
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While doing a find to get rid of 2.5M smallish files in 1 directory I 
got the stuff pasted below which made the system freeze.
This is on Fedora 10 on AMD x86_64 with a custom kernel.
Any ideas on how to fix this? Can I help?

Kind regards,
Udo

Mar 21 18:27:44 bla kernel: Bad page state in process 'find'
Mar 21 18:27:44 bla kernel: page:ffffe20001d4b8e8 
flags:0x4000000000080008 mapping:0000000000000000 mapcount:1 count:0
Mar 21 18:27:44 bla kernel: Trying to fix it up, but a reboot is needed
Mar 21 18:27:44 bla kernel: Backtrace:
Mar 21 18:27:44 bla kernel: Pid: 28653, comm: find Not tainted 2.6.28.2 #8
Mar 21 18:27:44 bla kernel: Call Trace:
Mar 21 18:27:44 bla kernel: [<ffffffff80283bd6>] bad_page+0x66/0xa0
Mar 21 18:27:44 bla kernel: [<ffffffff80284cd8>] 
free_hot_cold_page+0x1f8/0x2d0
Mar 21 18:27:44 bla kernel: [<ffffffff80284de0>] __pagevec_free+0x30/0x40
Mar 21 18:27:44 bla kernel: [<ffffffff80288508>] release_pages+0x1a8/0x1f0
Mar 21 18:27:44 bla kernel: [<ffffffff802bffba>] touch_atime+0x1a/0x150
Mar 21 18:27:44 bla kernel: [<ffffffff80526fe0>] _spin_unlock+0x10/0x30
Mar 21 18:27:44 bla kernel: [<ffffffff8029e975>] 
free_pages_and_swap_cache+0x85/0xb0
Mar 21 18:27:44 bla kernel: [<ffffffff80291364>] unmap_vmas+0x8b4/0x9a0
Mar 21 18:27:44 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:27:44 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:27:44 bla kernel: [<ffffffff802b120e>] flush_old_exec+0x1de/0x890
Mar 21 18:27:44 bla kernel: [<ffffffff802ea9be>] 
load_elf_binary+0x2ee/0x1dd0
Mar 21 18:27:44 bla kernel: [<ffffffff80526fe0>] _spin_unlock+0x10/0x30
Mar 21 18:27:44 bla kernel: [<ffffffff8028874d>] __lru_cache_add+0x8d/0xf0
Mar 21 18:27:44 bla kernel: [<ffffffff8028ddc8>] __inc_zone_state+0x18/0x90
Mar 21 18:27:44 bla kernel: [<ffffffff80526fe0>] _spin_unlock+0x10/0x30
Mar 21 18:27:44 bla kernel: [<ffffffff802922eb>] handle_mm_fault+0x5db/0x840
Mar 21 18:27:44 bla kernel: [<ffffffff80526fe0>] _spin_unlock+0x10/0x30
Mar 21 18:27:44 bla kernel: [<ffffffff80290a08>] follow_page+0x1e8/0x290
Mar 21 18:27:44 bla kernel: [<ffffffff80526fe0>] _spin_unlock+0x10/0x30
Mar 21 18:27:44 bla kernel: [<ffffffff80290a08>] follow_page+0x1e8/0x290
Mar 21 18:27:44 bla kernel: [<ffffffff80526f61>] _read_unlock+0x11/0x40
Mar 21 18:27:44 bla kernel: [<ffffffffa0195076>] 
load_misc_binary+0x3b6/0x3d0 [binfmt_misc]
Mar 21 18:27:44 bla kernel: [<ffffffff802b0846>] get_arg_page+0x46/0xb0
Mar 21 18:27:44 bla kernel: [<ffffffff802ea6d0>] load_elf_binary+0x0/0x1dd0
Mar 21 18:27:44 bla kernel: [<ffffffff802b0d4b>] 
search_binary_handler+0x12b/0x300
Mar 21 18:27:44 bla kernel: [<ffffffff802b2312>] do_execve+0x2b2/0x310
Mar 21 18:27:44 bla kernel: [<ffffffff80209dd9>] sys_execve+0x49/0x80
Mar 21 18:27:44 bla kernel: [<ffffffff8020bcea>] stub_execve+0x6a/0xc0
Mar 21 18:27:44 bla kernel: Bad page state in process 'find'
Mar 21 18:27:44 bla kernel: page:ffffe20001d4b8e8 
flags:0x4000000000000008 mapping:0000000000000000 mapcount:1 count:1
Mar 21 18:27:44 bla kernel: Trying to fix it up, but a reboot is needed
Mar 21 18:27:44 bla kernel: Backtrace:
Mar 21 18:27:44 bla kernel: Pid: 28655, comm: find Tainted: G    B 
2.6.28.2 #8
Mar 21 18:27:44 bla kernel: Call Trace:
Mar 21 18:27:44 bla kernel: [<ffffffff80283bd6>] bad_page+0x66/0xa0
Mar 21 18:27:44 bla kernel: [<ffffffff80285485>] 
get_page_from_freelist+0x5c5/0x600
Mar 21 18:27:44 bla kernel: [<ffffffff802856a7>] 
__alloc_pages_internal+0xe7/0x4b0
Mar 21 18:27:44 bla kernel: [<ffffffff80526fe0>] _spin_unlock+0x10/0x30
Mar 21 18:27:44 bla kernel: [<ffffffff80292203>] handle_mm_fault+0x4f3/0x840
Mar 21 18:27:44 bla kernel: [<ffffffff80292686>] 
__get_user_pages+0x136/0x450
Mar 21 18:27:44 bla kernel: [<ffffffff802b0846>] get_arg_page+0x46/0xb0
Mar 21 18:27:44 bla kernel: [<ffffffff802b09b2>] copy_strings+0x102/0x1e0
Mar 21 18:27:44 bla kernel: [<ffffffff802b0ac5>] 
copy_strings_kernel+0x35/0x60
Mar 21 18:27:44 bla kernel: [<ffffffff802b22ae>] do_execve+0x24e/0x310
Mar 21 18:27:44 bla kernel: [<ffffffff80209dd9>] sys_execve+0x49/0x80
Mar 21 18:27:44 bla kernel: [<ffffffff8020bcea>] stub_execve+0x6a/0xc0
Mar 21 18:27:45 bla kernel: Eeek! page_mapcount(page) went negative! (-1)
Mar 21 18:27:45 bla kernel:  page pfn = 85ebb
Mar 21 18:27:45 bla kernel:  page->flags = 400000000000001c
Mar 21 18:27:45 bla kernel:  page->count = 0
Mar 21 18:27:45 bla kernel:  page->mapping = 0000000000000000
Mar 21 18:27:45 bla kernel:  vma->vm_ops = 0x0
Mar 21 18:27:45 bla kernel: ------------[ cut here ]------------
Mar 21 18:27:45 bla kernel: kernel BUG at mm/rmap.c:725!
Mar 21 18:27:45 bla kernel: invalid opcode: 0000 [#1] PREEMPT SMP
Mar 21 18:27:45 bla kernel: last sysfs file: 
/sys/devices/virtual/net/ltspbr0/statistics/collisions
Mar 21 18:27:45 bla kernel: CPU 2
Mar 21 18:27:45 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:27:45 bla kernel: Pid: 28655, comm: rm Tainted: G    B 
2.6.28.2 #8
Mar 21 18:27:45 bla kernel: RIP: 0010:[<ffffffff8029a903>] 
[<ffffffff8029a903>] page_remove_rmap+0x113/0x120
Mar 21 18:27:45 bla kernel: RSP: 0018:ffff8800c7689d28  EFLAGS: 00010246
Mar 21 18:27:45 bla kernel: RAX: 0000000000000000 RBX: ffffe20001d4b8e8 
RCX: 0000000000000000
Mar 21 18:27:45 bla kernel: RDX: ffff8800a7932000 RSI: 0000000000000096 
RDI: 0000000000000001
Mar 21 18:27:45 bla kernel: RBP: ffff88012910bc60 R08: 00000000fffffffe 
R09: 0000000000000003
Mar 21 18:27:45 bla kernel: R10: ffff8800c7689bb8 R11: 000000008074b800 
R12: ffffe20001d4b8e8
Mar 21 18:27:45 bla kernel: R13: 00007fff9725d000 R14: 0000000000004fff 
R15: 0000000000000020
Mar 21 18:27:45 bla kernel: FS:  00007f438f23e6f0(0000) 
GS:ffff88012f86a440(0000) knlGS:00000000ef284b90
Mar 21 18:27:45 bla kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Mar 21 18:27:45 bla kernel: CR2: 00000036da8720e0 CR3: 0000000000201000 
CR4: 00000000000006e0
Mar 21 18:27:45 bla kernel: DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
Mar 21 18:27:45 bla kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 
DR7: 0000000000000400
Mar 21 18:27:45 bla kernel: Process rm (pid: 28655, threadinfo 
ffff8800c7688000, task ffff880126588800)
Mar 21 18:27:45 bla kernel: Stack:
Mar 21 18:27:45 bla kernel: ffff8800130332d0 00007fff9725e000 
ffff8800130332e8 ffffffff80290f96
Mar 21 18:27:45 bla kernel: 00000036da8720e0 00007fff9725dfff 
0000000000000000 ffff8800c7689e50
Mar 21 18:27:45 bla kernel: ffffffffffffffff 0000000000000000 
ffff88012910bc60 ffff8800c7689e58
Mar 21 18:27:45 bla kernel: Call Trace:
Mar 21 18:27:45 bla kernel: [<ffffffff80290f96>] ? unmap_vmas+0x4e6/0x9a0
Mar 21 18:27:45 bla kernel: [<ffffffff80296505>] ? exit_mmap+0xb5/0x1c0
Mar 21 18:27:45 bla kernel: [<ffffffff8023cb45>] ? mmput+0x25/0xc0
Mar 21 18:27:45 bla kernel: [<ffffffff802409d1>] ? exit_mm+0xf1/0x130
Mar 21 18:27:45 bla kernel: [<ffffffff80276c7a>] ? audit_free+0x24a/0x2a0
Mar 21 18:27:45 bla kernel: [<ffffffff80242654>] ? do_exit+0x164/0x8f0
Mar 21 18:27:45 bla kernel: [<ffffffff80242e13>] ? do_group_exit+0x33/0xa0
Mar 21 18:27:45 bla kernel: [<ffffffff80242e92>] ? sys_exit_group+0x12/0x20
Mar 21 18:27:45 bla kernel: [<ffffffff8020b8cb>] ? 
system_call_fastpath+0x16/0x1b
Mar 21 18:27:45 bla kernel: Code: 80 e8 b2 fb fc ff 48 8b 85 90 00 00 00 
48 85 c0 74 19 48 8b 40 20 48 85 c0 74 10 48 8b 70 58 48 c7 c7 d0 88 5d 
80 e8 8d fb fc ff <0f> 0b eb fe 66 0f 1f 84 00 00 00 00 00 48 83 ec 48 
48 89 5c 24
Mar 21 18:27:45 bla kernel: RIP  [<ffffffff8029a903>] 
page_remove_rmap+0x113/0x120
Mar 21 18:27:45 bla kernel: RSP <ffff8800c7689d28>
Mar 21 18:27:45 bla kernel: ---[ end trace b5685138b7f6c401 ]---
Mar 21 18:27:45 bla kernel: Fixing recursive fault but reboot is needed!
Mar 21 18:27:45 bla kernel: BUG: scheduling while atomic: 
rm/28655/0x00000003
Mar 21 18:27:45 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:27:45 bla kernel: Pid: 28655, comm: rm Tainted: G    B D 
2.6.28.2 #8
Mar 21 18:27:45 bla kernel: Call Trace:
Mar 21 18:27:45 bla kernel: [<ffffffff80524ca0>] thread_return+0x11f/0x63f
Mar 21 18:27:45 bla kernel: [<ffffffff8025a276>] up+0x16/0x50
Mar 21 18:27:45 bla kernel: [<ffffffff8023f7a5>] 
release_console_sem+0x1a5/0x1f0
Mar 21 18:27:45 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:27:45 bla kernel: [<ffffffff80242c97>] do_exit+0x7a7/0x8f0
Mar 21 18:27:45 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:27:45 bla kernel: [<ffffffff8020e7d2>] oops_end+0xb2/0xc0
Mar 21 18:27:45 bla kernel: [<ffffffff8020d8d4>] do_invalid_op+0x84/0xa0
Mar 21 18:27:45 bla kernel: [<ffffffff8029a903>] 
page_remove_rmap+0x113/0x120
Mar 21 18:27:45 bla kernel: [<ffffffff8026a4bf>] __print_symbol+0x2f/0x50
Mar 21 18:27:45 bla kernel: [<ffffffff8023fc5a>] vprintk+0x17a/0x400
Mar 21 18:27:45 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:27:45 bla kernel: [<ffffffff8029a903>] 
page_remove_rmap+0x113/0x120
Mar 21 18:27:45 bla kernel: [<ffffffff8029a8c2>] page_remove_rmap+0xd2/0x120
Mar 21 18:27:45 bla kernel: [<ffffffff80290f96>] unmap_vmas+0x4e6/0x9a0
Mar 21 18:27:45 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:27:45 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:27:45 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:27:45 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:27:45 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:27:45 bla kernel: [<ffffffff80242e13>] do_group_exit+0x33/0xa0
Mar 21 18:27:45 bla kernel: [<ffffffff80242e92>] sys_exit_group+0x12/0x20
Mar 21 18:27:45 bla kernel: [<ffffffff8020b8cb>] 
system_call_fastpath+0x16/0x1b
Mar 21 18:27:53 bla kernel: Bad page state in process 'firefox'
Mar 21 18:27:53 bla kernel: page:ffffe20001d4b8e8 
flags:0x400000000000001c mapping:0000000000000000 mapcount:-1 count:0
Mar 21 18:27:53 bla kernel: Trying to fix it up, but a reboot is needed
Mar 21 18:27:53 bla kernel: Backtrace:
Mar 21 18:27:53 bla kernel: Pid: 15008, comm: firefox Tainted: G    B D 
    2.6.28.2 #8
Mar 21 18:27:53 bla kernel: Call Trace:
Mar 21 18:27:53 bla kernel: [<ffffffff80283bd6>] bad_page+0x66/0xa0
Mar 21 18:27:53 bla kernel: [<ffffffff80285485>] 
get_page_from_freelist+0x5c5/0x600
Mar 21 18:27:53 bla kernel: [<ffffffff802856a7>] 
__alloc_pages_internal+0xe7/0x4b0
Mar 21 18:27:53 bla kernel: [<ffffffff802b3eeb>] pipe_read+0x4db/0x4e0
Mar 21 18:27:53 bla kernel: [<ffffffff80292203>] handle_mm_fault+0x4f3/0x840
Mar 21 18:27:53 bla kernel: [<ffffffff80526cbf>] 
_spin_lock_irqsave+0x1f/0x50
Mar 21 18:27:53 bla kernel: [<ffffffff80227cf0>] do_page_fault+0x2e0/0x970
Mar 21 18:27:53 bla kernel: [<ffffffff80234b8a>] set_next_entity+0x3a/0x80
Mar 21 18:27:53 bla kernel: [<ffffffff80526ee1>] _spin_unlock_irq+0x11/0x40
Mar 21 18:27:53 bla kernel: [<ffffffff8023a15b>] 
finish_task_switch+0x2b/0xe0
Mar 21 18:27:53 bla kernel: [<ffffffff80524c24>] thread_return+0xa3/0x63f
Mar 21 18:27:53 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:27:56 bla kerneloops: Submitted 1 kernel oopses to 
www.kerneloops.org
Mar 21 18:28:39 bla kernel: ------------[ cut here ]------------
Mar 21 18:28:39 bla kernel: WARNING: at fs/buffer.c:710 
__set_page_dirty+0x12f/0x160()
Mar 21 18:28:39 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:28:39 bla kernel: Pid: 29549, comm: find Tainted: G    B D 
2.6.28.2 #8
Mar 21 18:28:39 bla kernel: Call Trace:
Mar 21 18:28:39 bla kernel: [<ffffffff8023efa4>] warn_on_slowpath+0x64/0xa0
Mar 21 18:28:39 bla kernel: [<ffffffff80284de0>] __pagevec_free+0x30/0x40
Mar 21 18:28:39 bla kernel: [<ffffffff80288508>] release_pages+0x1a8/0x1f0
Mar 21 18:28:39 bla kernel: [<ffffffff802cff7f>] 
__set_page_dirty+0x12f/0x160
Mar 21 18:28:39 bla kernel: [<ffffffff802860d1>] set_page_dirty+0x31/0xc0
Mar 21 18:28:39 bla kernel: [<ffffffff802911e0>] unmap_vmas+0x730/0x9a0
Mar 21 18:28:39 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:28:39 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:28:39 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:28:39 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:28:39 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:28:39 bla kernel: [<ffffffff80291cd2>] __pte_alloc+0x82/0xc0
Mar 21 18:28:39 bla kernel: [<ffffffff8028874d>] __lru_cache_add+0x8d/0xf0
Mar 21 18:28:39 bla kernel: [<ffffffff80242e13>] do_group_exit+0x33/0xa0
Mar 21 18:28:39 bla kernel: [<ffffffff8024e253>] 
get_signal_to_deliver+0x263/0x390
Mar 21 18:28:39 bla kernel: [<ffffffff8020ac1a>] do_notify_resume+0xfa/0x910
Mar 21 18:28:39 bla kernel: [<ffffffff80524c24>] thread_return+0xa3/0x63f
Mar 21 18:28:39 bla kernel: [<ffffffff80363f71>] __up_read+0x21/0xb0
Mar 21 18:28:39 bla kernel: [<ffffffff80241705>] 
wait_consider_task+0xa5/0x980
Mar 21 18:28:39 bla kernel: [<ffffffff8023a700>] update_curr+0xd0/0x140
Mar 21 18:28:39 bla kernel: [<ffffffff80230362>] place_entity+0x62/0xb0
Mar 21 18:28:39 bla kernel: [<ffffffff80526cbf>] 
_spin_lock_irqsave+0x1f/0x50
Mar 21 18:28:39 bla kernel: [<ffffffff80255ce9>] remove_wait_queue+0x19/0x60
Mar 21 18:28:39 bla kernel: [<ffffffff80242282>] do_wait+0x2a2/0x340
Mar 21 18:28:39 bla kernel: [<ffffffff8020b952>] sysret_signal+0x1a/0x25
Mar 21 18:28:39 bla kernel: [<ffffffff8020bc37>] ptregscall_common+0x67/0xb0
Mar 21 18:28:39 bla kernel: ---[ end trace b5685138b7f6c401 ]---
Mar 21 18:28:39 bla kernel: Eeek! page_mapcount(page) went negative! (-1)
Mar 21 18:28:39 bla kernel:  page pfn = 85ebb
Mar 21 18:28:39 bla kernel:  page->flags = 4000000000000834
Mar 21 18:28:39 bla kernel:  page->count = 2
Mar 21 18:28:39 bla kernel:  page->mapping = ffff88012f435290
Mar 21 18:28:39 bla kernel:  vma->vm_ops = 0x0
Mar 21 18:28:39 bla kernel: ------------[ cut here ]------------
Mar 21 18:28:39 bla kernel: kernel BUG at mm/rmap.c:725!
Mar 21 18:28:39 bla kernel: invalid opcode: 0000 [#2] PREEMPT SMP
Mar 21 18:28:39 bla kernel: last sysfs file: 
/sys/devices/virtual/net/ltspbr0/statistics/collisions
Mar 21 18:28:39 bla kernel: CPU 2
Mar 21 18:28:39 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:28:39 bla kernel: Pid: 29549, comm: find Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:28:39 bla kernel: RIP: 0010:[<ffffffff8029a903>] 
[<ffffffff8029a903>] page_remove_rmap+0x113/0x120
Mar 21 18:28:39 bla kernel: RSP: 0018:ffff8800379d3af8  EFLAGS: 00010246
Mar 21 18:28:39 bla kernel: RAX: 0000000000000000 RBX: ffffe20001d4b8e8 
RCX: 0000000000000000
Mar 21 18:28:39 bla kernel: RDX: ffff8800a7932000 RSI: 0000000000000092 
RDI: 0000000000000001
Mar 21 18:28:39 bla kernel: RBP: ffff8800bded97c8 R08: 00000000fffffffe 
R09: 0000000000000003
Mar 21 18:28:39 bla kernel: R10: ffff8800379d3988 R11: 000000008074b800 
R12: ffffe20001d4b8e8
Mar 21 18:28:39 bla kernel: R13: 0000000018f00000 R14: 0000000000002000 
R15: 0000000000000020
Mar 21 18:28:39 bla kernel: FS:  00007ff08fdca780(0000) 
GS:ffff88012f86a440(0000) knlGS:00000000ef284b90
Mar 21 18:28:39 bla kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Mar 21 18:28:39 bla kernel: CR2: 00007fc150651000 CR3: 000000012e784000 
CR4: 00000000000006e0
Mar 21 18:28:39 bla kernel: DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
Mar 21 18:28:39 bla kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 
DR7: 0000000000000400
Mar 21 18:28:39 bla kernel: Process find (pid: 29549, threadinfo 
ffff8800379d2000, task ffff8800c2771850)
Mar 21 18:28:39 bla kernel: Stack:
Mar 21 18:28:39 bla kernel: ffff880037a607d8 0000000019000000 
ffff880037a60800 ffffffff80290f96
Mar 21 18:28:39 bla kernel: ffffffff80685500 000000002a5b3fff 
0000000000000000 ffff8800379d3c20
Mar 21 18:28:39 bla kernel: ffffffffffffffff 0000000000000000 
ffff8800bded97c8 ffff8800379d3c28
Mar 21 18:28:39 bla kernel: Call Trace:
Mar 21 18:28:39 bla kernel: [<ffffffff80290f96>] ? unmap_vmas+0x4e6/0x9a0
Mar 21 18:28:39 bla kernel: [<ffffffff80296505>] ? exit_mmap+0xb5/0x1c0
Mar 21 18:28:39 bla kernel: [<ffffffff8023cb45>] ? mmput+0x25/0xc0
Mar 21 18:28:39 bla kernel: [<ffffffff802409d1>] ? exit_mm+0xf1/0x130
Mar 21 18:28:39 bla kernel: [<ffffffff80276c7a>] ? audit_free+0x24a/0x2a0
Mar 21 18:28:39 bla kernel: [<ffffffff80242654>] ? do_exit+0x164/0x8f0
Mar 21 18:28:39 bla kernel: [<ffffffff80291cd2>] ? __pte_alloc+0x82/0xc0
Mar 21 18:28:39 bla kernel: [<ffffffff8028874d>] ? __lru_cache_add+0x8d/0xf0
Mar 21 18:28:39 bla kernel: [<ffffffff80242e13>] ? do_group_exit+0x33/0xa0
Mar 21 18:28:39 bla kernel: [<ffffffff8024e253>] ? 
get_signal_to_deliver+0x263/0x390
Mar 21 18:28:39 bla kernel: [<ffffffff8020ac1a>] ? 
do_notify_resume+0xfa/0x910
Mar 21 18:28:39 bla kernel: [<ffffffff80524c24>] ? thread_return+0xa3/0x63f
Mar 21 18:28:39 bla kernel: [<ffffffff80363f71>] ? __up_read+0x21/0xb0
Mar 21 18:28:39 bla kernel: [<ffffffff80241705>] ? 
wait_consider_task+0xa5/0x980
Mar 21 18:28:39 bla kernel: [<ffffffff8023a700>] ? update_curr+0xd0/0x140
Mar 21 18:28:39 bla kernel: [<ffffffff80230362>] ? place_entity+0x62/0xb0
Mar 21 18:28:39 bla kernel: [<ffffffff80526cbf>] ? 
_spin_lock_irqsave+0x1f/0x50
Mar 21 18:28:39 bla kernel: [<ffffffff80255ce9>] ? 
remove_wait_queue+0x19/0x60
Mar 21 18:28:39 bla kernel: [<ffffffff80242282>] ? do_wait+0x2a2/0x340
Mar 21 18:28:39 bla kernel: [<ffffffff8020b952>] ? sysret_signal+0x1a/0x25
Mar 21 18:28:39 bla kernel: [<ffffffff8020bc37>] ? 
ptregscall_common+0x67/0xb0
Mar 21 18:28:39 bla kernel: Code: 80 e8 b2 fb fc ff 48 8b 85 90 00 00 00 
48 85 c0 74 19 48 8b 40 20 48 85 c0 74 10 48 8b 70 58 48 c7 c7 d0 88 5d 
80 e8 8d fb fc ff <0f> 0b eb fe 66 0f 1f 84 00 00 00 00 00 48 83 ec 48 
48 89 5c 24
Mar 21 18:28:39 bla kernel: RIP  [<ffffffff8029a903>] 
page_remove_rmap+0x113/0x120
Mar 21 18:28:39 bla kernel: RSP <ffff8800379d3af8>
Mar 21 18:28:39 bla kernel: ---[ end trace b5685138b7f6c401 ]---
Mar 21 18:28:39 bla kernel: Fixing recursive fault but reboot is needed!
Mar 21 18:28:39 bla kernel: BUG: scheduling while atomic: 
find/29549/0x00000003
Mar 21 18:28:39 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:28:39 bla kernel: Pid: 29549, comm: find Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:28:39 bla kernel: Call Trace:
Mar 21 18:28:39 bla kernel: [<ffffffff80524ca0>] thread_return+0x11f/0x63f
Mar 21 18:28:39 bla kernel: [<ffffffff8025a276>] up+0x16/0x50
Mar 21 18:28:39 bla kernel: [<ffffffff8023f7a5>] 
release_console_sem+0x1a5/0x1f0
Mar 21 18:28:39 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:28:39 bla kernel: [<ffffffff80242c97>] do_exit+0x7a7/0x8f0
Mar 21 18:28:39 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:28:39 bla kernel: [<ffffffff8020e7d2>] oops_end+0xb2/0xc0
Mar 21 18:28:39 bla kernel: [<ffffffff8020d8d4>] do_invalid_op+0x84/0xa0
Mar 21 18:28:39 bla kernel: [<ffffffff8029a903>] 
page_remove_rmap+0x113/0x120
Mar 21 18:28:39 bla kernel: [<ffffffff8026a4bf>] __print_symbol+0x2f/0x50
Mar 21 18:28:39 bla kernel: [<ffffffff8023fc5a>] vprintk+0x17a/0x400
Mar 21 18:28:39 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:28:39 bla kernel: [<ffffffff8029a903>] 
page_remove_rmap+0x113/0x120
Mar 21 18:28:39 bla kernel: [<ffffffff8029a8c2>] page_remove_rmap+0xd2/0x120
Mar 21 18:28:39 bla kernel: [<ffffffff80290f96>] unmap_vmas+0x4e6/0x9a0
Mar 21 18:28:39 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:28:39 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:28:39 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:28:39 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:28:39 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:28:39 bla kernel: [<ffffffff80291cd2>] __pte_alloc+0x82/0xc0
Mar 21 18:28:39 bla kernel: [<ffffffff8028874d>] __lru_cache_add+0x8d/0xf0
Mar 21 18:28:39 bla kernel: [<ffffffff80242e13>] do_group_exit+0x33/0xa0
Mar 21 18:28:39 bla kernel: [<ffffffff8024e253>] 
get_signal_to_deliver+0x263/0x390
Mar 21 18:28:39 bla kernel: [<ffffffff8020ac1a>] do_notify_resume+0xfa/0x910
Mar 21 18:28:39 bla kernel: [<ffffffff80524c24>] thread_return+0xa3/0x63f
Mar 21 18:28:39 bla kernel: [<ffffffff80363f71>] __up_read+0x21/0xb0
Mar 21 18:28:39 bla kernel: [<ffffffff80241705>] 
wait_consider_task+0xa5/0x980
Mar 21 18:28:39 bla kernel: [<ffffffff8023a700>] update_curr+0xd0/0x140
Mar 21 18:28:39 bla kernel: [<ffffffff80230362>] place_entity+0x62/0xb0
Mar 21 18:28:39 bla kernel: [<ffffffff80526cbf>] 
_spin_lock_irqsave+0x1f/0x50
Mar 21 18:28:39 bla kernel: [<ffffffff80255ce9>] remove_wait_queue+0x19/0x60
Mar 21 18:28:39 bla kernel: [<ffffffff80242282>] do_wait+0x2a2/0x340
Mar 21 18:28:39 bla kernel: [<ffffffff8020b952>] sysret_signal+0x1a/0x25
Mar 21 18:28:39 bla kernel: [<ffffffff8020bc37>] ptregscall_common+0x67/0xb0
Mar 21 18:28:44 bla kerneloops: Submitted 1 kernel oopses to 
www.kerneloops.org
Mar 21 18:32:04 bla kernel: general protection fault: 0000 [#3] PREEMPT SMP
Mar 21 18:32:04 bla kernel: last sysfs file: 
/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
Mar 21 18:32:04 bla kernel: CPU 3
Mar 21 18:32:04 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:32:04 bla kernel: Pid: 7339, comm: ls Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:32:04 bla kernel: RIP: 0010:[<ffffffff802cf5b8>] 
[<ffffffff802cf5b8>] __find_get_block_slow+0xa8/0x120
Mar 21 18:32:04 bla kernel: RSP: 0018:ffff8801000e7b08  EFLAGS: 00010212
Mar 21 18:32:04 bla kernel: RAX: 8124ffffe20002aa RBX: ffff880053d53d02 
RCX: 0000000000000000
Mar 21 18:32:04 bla kernel: RDX: 0000000000000000 RSI: 0000000000000002 
RDI: 0000000000000001
Mar 21 18:32:04 bla kernel: RBP: 00000000013501cd R08: ffffe20001d4bfb8 
R09: ffff880055659748
Mar 21 18:32:04 bla kernel: R10: ffff88012ebd6800 R11: 0000000000000000 
R12: ffff88012f435300
Mar 21 18:32:04 bla kernel: R13: ffffe20001d4bfb0 R14: ffff88012f435180 
R15: ffffffff8070b720
Mar 21 18:32:04 bla kernel: FS:  00007fc159dc2780(0000) 
GS:ffff88012f906cc0(0000) knlGS:00000000f3bd9b90
Mar 21 18:32:04 bla kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Mar 21 18:32:04 bla kernel: CR2: 00007fc149da5000 CR3: 000000010040c000 
CR4: 00000000000006e0
Mar 21 18:32:04 bla kernel: DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
Mar 21 18:32:04 bla kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 
DR7: 0000000000000400
Mar 21 18:32:04 bla kernel: Process ls (pid: 7339, threadinfo 
ffff8801000e6000, task ffff8800a52a1950)
Mar 21 18:32:04 bla kernel: Stack:
Mar 21 18:32:04 bla kernel: ffffffff8070b720 0000000000000000 
ffff8800280218c0 ffff88012f4350c0
Mar 21 18:32:04 bla kernel: 00000000013501cd ffffffff802cf9ae 
ffff88012e7be000 ffffffff802a8455
Mar 21 18:32:04 bla kernel: 0000000000000006 00000050000e7c44 
0000001000000000 0000000000000050
Mar 21 18:32:04 bla kernel: Call Trace:
Mar 21 18:32:04 bla kernel: [<ffffffff802cf9ae>] ? 
__find_get_block+0xce/0x200
Mar 21 18:32:04 bla kernel: [<ffffffff802a8455>] ? 
cache_alloc_refill+0x185/0x590
Mar 21 18:32:04 bla kernel: [<ffffffff802cfafe>] ? __getblk+0x1e/0x2f0
Mar 21 18:32:04 bla kernel: [<ffffffff8030d1e1>] ? 
__ext3_get_inode_loc+0x111/0x320
Mar 21 18:32:04 bla kernel: [<ffffffff8030d44c>] ? ext3_iget+0x5c/0x3f0
Mar 21 18:32:04 bla kernel: [<ffffffff803143e0>] ? ext3_lookup+0xb0/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802b48f0>] ? do_lookup+0x210/0x260
Mar 21 18:32:04 bla kernel: [<ffffffff802b6db5>] ? 
__link_path_walk+0x765/0x1000
Mar 21 18:32:04 bla kernel: [<ffffffff802c47b7>] ? 
mntput_no_expire+0x27/0x150
Mar 21 18:32:04 bla kernel: [<ffffffff802b7846>] ? path_walk+0x66/0xd0
Mar 21 18:32:04 bla kernel: [<ffffffff802b79e6>] ? do_path_lookup+0x96/0x1f0
Mar 21 18:32:04 bla kernel: [<ffffffff802b65ed>] ? getname+0x1bd/0x220
Mar 21 18:32:04 bla kernel: [<ffffffff802b88a7>] ? user_path_at+0x97/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff8033e8e0>] ? 
cap_d_instantiate+0x0/0x10
Mar 21 18:32:04 bla kernel: [<ffffffff802bac60>] ? filldir+0x0/0xe0
Mar 21 18:32:04 bla kernel: [<ffffffff802af714>] ? cp_new_stat+0xe4/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802afa40>] ? vfs_lstat_fd+0x20/0x60
Mar 21 18:32:04 bla kernel: [<ffffffff802afaa7>] ? sys_newlstat+0x27/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff80276e18>] ? 
audit_syscall_entry+0x148/0x170
Mar 21 18:32:04 bla kernel: [<ffffffff8020b8cb>] ? 
system_call_fastpath+0x16/0x1b
Mar 21 18:32:04 bla kernel: Code: 24 4c 8b 64 24 10 4c 8b 6c 24 18 4c 8b 
74 24 20 48 83 c4 28 c3 66 0f 1f 44 00 00 49 8b 5d 10 ba 01 00 00 00 31 
c9 48 89 d8 66 90 <48> 39 68 18 74 62 f6 00 20 48 8b 40 08 0f 44 d1 48 
39 c3 75 eb
Mar 21 18:32:04 bla kernel: RIP  [<ffffffff802cf5b8>] 
__find_get_block_slow+0xa8/0x120
Mar 21 18:32:04 bla kernel: RSP <ffff8801000e7b08>
Mar 21 18:32:04 bla kernel: ---[ end trace b5685138b7f6c401 ]---
Mar 21 18:32:04 bla kernel: note: ls[7339] exited with preempt_count 1
Mar 21 18:32:04 bla kernel: BUG: scheduling while atomic: ls/7339/0x10000002
Mar 21 18:32:04 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:32:04 bla kernel: Pid: 7339, comm: ls Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:32:04 bla kernel: Call Trace:
Mar 21 18:32:04 bla kernel: [<ffffffff80524ca0>] thread_return+0x11f/0x63f
Mar 21 18:32:04 bla kernel: [<ffffffff8023b957>] __cond_resched+0x17/0x40
Mar 21 18:32:04 bla kernel: [<ffffffff805252c5>] _cond_resched+0x35/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff802912b3>] unmap_vmas+0x803/0x9a0
Mar 21 18:32:04 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:32:04 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:32:04 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:32:04 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:32:04 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:32:04 bla kernel: [<ffffffff8020e7d2>] oops_end+0xb2/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:32:04 bla kernel: [<ffffffff802cf5b8>] 
__find_get_block_slow+0xa8/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf567>] 
__find_get_block_slow+0x57/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf9ae>] __find_get_block+0xce/0x200
Mar 21 18:32:04 bla kernel: [<ffffffff802a8455>] 
cache_alloc_refill+0x185/0x590
Mar 21 18:32:04 bla kernel: [<ffffffff802cfafe>] __getblk+0x1e/0x2f0
Mar 21 18:32:04 bla kernel: [<ffffffff8030d1e1>] 
__ext3_get_inode_loc+0x111/0x320
Mar 21 18:32:04 bla kernel: [<ffffffff8030d44c>] ext3_iget+0x5c/0x3f0
Mar 21 18:32:04 bla kernel: [<ffffffff803143e0>] ext3_lookup+0xb0/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802b48f0>] do_lookup+0x210/0x260
Mar 21 18:32:04 bla kernel: [<ffffffff802b6db5>] 
__link_path_walk+0x765/0x1000
Mar 21 18:32:04 bla kernel: [<ffffffff802c47b7>] mntput_no_expire+0x27/0x150
Mar 21 18:32:04 bla kernel: [<ffffffff802b7846>] path_walk+0x66/0xd0
Mar 21 18:32:04 bla kernel: [<ffffffff802b79e6>] do_path_lookup+0x96/0x1f0
Mar 21 18:32:04 bla kernel: [<ffffffff802b65ed>] getname+0x1bd/0x220
Mar 21 18:32:04 bla kernel: [<ffffffff802b88a7>] user_path_at+0x97/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff8033e8e0>] cap_d_instantiate+0x0/0x10
Mar 21 18:32:04 bla kernel: [<ffffffff802bac60>] filldir+0x0/0xe0
Mar 21 18:32:04 bla kernel: [<ffffffff802af714>] cp_new_stat+0xe4/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802afa40>] vfs_lstat_fd+0x20/0x60
Mar 21 18:32:04 bla kernel: [<ffffffff802afaa7>] sys_newlstat+0x27/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff80276e18>] 
audit_syscall_entry+0x148/0x170
Mar 21 18:32:04 bla kernel: [<ffffffff8020b8cb>] 
system_call_fastpath+0x16/0x1b
Mar 21 18:32:04 bla kernel: BUG: scheduling while atomic: ls/7339/0x10000002
Mar 21 18:32:04 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:32:04 bla kernel: Pid: 7339, comm: ls Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:32:04 bla kernel: Call Trace:
Mar 21 18:32:04 bla kernel: [<ffffffff80524ca0>] thread_return+0x11f/0x63f
Mar 21 18:32:04 bla kernel: [<ffffffff8023b957>] __cond_resched+0x17/0x40
Mar 21 18:32:04 bla kernel: [<ffffffff805252c5>] _cond_resched+0x35/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff802912b3>] unmap_vmas+0x803/0x9a0
Mar 21 18:32:04 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:32:04 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:32:04 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:32:04 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:32:04 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:32:04 bla kernel: [<ffffffff8020e7d2>] oops_end+0xb2/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:32:04 bla kernel: [<ffffffff802cf5b8>] 
__find_get_block_slow+0xa8/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf567>] 
__find_get_block_slow+0x57/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf9ae>] __find_get_block+0xce/0x200
Mar 21 18:32:04 bla kernel: [<ffffffff802a8455>] 
cache_alloc_refill+0x185/0x590
Mar 21 18:32:04 bla kernel: [<ffffffff802cfafe>] __getblk+0x1e/0x2f0
Mar 21 18:32:04 bla kernel: [<ffffffff8030d1e1>] 
__ext3_get_inode_loc+0x111/0x320
Mar 21 18:32:04 bla kernel: [<ffffffff8030d44c>] ext3_iget+0x5c/0x3f0
Mar 21 18:32:04 bla kernel: [<ffffffff803143e0>] ext3_lookup+0xb0/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802b48f0>] do_lookup+0x210/0x260
Mar 21 18:32:04 bla kernel: [<ffffffff802b6db5>] 
__link_path_walk+0x765/0x1000
Mar 21 18:32:04 bla kernel: [<ffffffff802c47b7>] mntput_no_expire+0x27/0x150
Mar 21 18:32:04 bla kernel: [<ffffffff802b7846>] path_walk+0x66/0xd0
Mar 21 18:32:04 bla kernel: [<ffffffff802b79e6>] do_path_lookup+0x96/0x1f0
Mar 21 18:32:04 bla kernel: [<ffffffff802b65ed>] getname+0x1bd/0x220
Mar 21 18:32:04 bla kernel: [<ffffffff802b88a7>] user_path_at+0x97/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff8033e8e0>] cap_d_instantiate+0x0/0x10
Mar 21 18:32:04 bla kernel: [<ffffffff802bac60>] filldir+0x0/0xe0
Mar 21 18:32:04 bla kernel: [<ffffffff802af714>] cp_new_stat+0xe4/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802afa40>] vfs_lstat_fd+0x20/0x60
Mar 21 18:32:04 bla kernel: [<ffffffff802afaa7>] sys_newlstat+0x27/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff80276e18>] 
audit_syscall_entry+0x148/0x170
Mar 21 18:32:04 bla kernel: [<ffffffff8020b8cb>] 
system_call_fastpath+0x16/0x1b
Mar 21 18:32:04 bla kernel: BUG: scheduling while atomic: ls/7339/0x10000002
Mar 21 18:32:04 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:32:04 bla kernel: Pid: 7339, comm: ls Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:32:04 bla kernel: Call Trace:
Mar 21 18:32:04 bla kernel: [<ffffffff80524ca0>] thread_return+0x11f/0x63f
Mar 21 18:32:04 bla kernel: [<ffffffff8023b957>] __cond_resched+0x17/0x40
Mar 21 18:32:04 bla kernel: [<ffffffff805252c5>] _cond_resched+0x35/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff802912b3>] unmap_vmas+0x803/0x9a0
Mar 21 18:32:04 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:32:04 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:32:04 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:32:04 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:32:04 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:32:04 bla kernel: [<ffffffff8020e7d2>] oops_end+0xb2/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:32:04 bla kernel: [<ffffffff802cf5b8>] 
__find_get_block_slow+0xa8/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf567>] 
__find_get_block_slow+0x57/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf9ae>] __find_get_block+0xce/0x200
Mar 21 18:32:04 bla kernel: [<ffffffff802a8455>] 
cache_alloc_refill+0x185/0x590
Mar 21 18:32:04 bla kernel: [<ffffffff802cfafe>] __getblk+0x1e/0x2f0
Mar 21 18:32:04 bla kernel: [<ffffffff8030d1e1>] 
__ext3_get_inode_loc+0x111/0x320
Mar 21 18:32:04 bla kernel: [<ffffffff8030d44c>] ext3_iget+0x5c/0x3f0
Mar 21 18:32:04 bla kernel: [<ffffffff803143e0>] ext3_lookup+0xb0/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802b48f0>] do_lookup+0x210/0x260
Mar 21 18:32:04 bla kernel: [<ffffffff802b6db5>] 
__link_path_walk+0x765/0x1000
Mar 21 18:32:04 bla kernel: [<ffffffff802c47b7>] mntput_no_expire+0x27/0x150
Mar 21 18:32:04 bla kernel: [<ffffffff802b7846>] path_walk+0x66/0xd0
Mar 21 18:32:04 bla kernel: [<ffffffff802b79e6>] do_path_lookup+0x96/0x1f0
Mar 21 18:32:04 bla kernel: [<ffffffff802b65ed>] getname+0x1bd/0x220
Mar 21 18:32:04 bla kernel: [<ffffffff802b88a7>] user_path_at+0x97/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff8033e8e0>] cap_d_instantiate+0x0/0x10
Mar 21 18:32:04 bla kernel: [<ffffffff802bac60>] filldir+0x0/0xe0
Mar 21 18:32:04 bla kernel: [<ffffffff802af714>] cp_new_stat+0xe4/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802afa40>] vfs_lstat_fd+0x20/0x60
Mar 21 18:32:04 bla kernel: [<ffffffff802afaa7>] sys_newlstat+0x27/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff80276e18>] 
audit_syscall_entry+0x148/0x170
Mar 21 18:32:04 bla kernel: [<ffffffff8020b8cb>] 
system_call_fastpath+0x16/0x1b
Mar 21 18:32:04 bla kernel: BUG: scheduling while atomic: ls/7339/0x10000002
Mar 21 18:32:04 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:32:04 bla kernel: Pid: 7339, comm: ls Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:32:04 bla kernel: Call Trace:
Mar 21 18:32:04 bla kernel: [<ffffffff80524ca0>] thread_return+0x11f/0x63f
Mar 21 18:32:04 bla kernel: [<ffffffff8023b957>] __cond_resched+0x17/0x40
Mar 21 18:32:04 bla kernel: [<ffffffff805252c5>] _cond_resched+0x35/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff802912b3>] unmap_vmas+0x803/0x9a0
Mar 21 18:32:04 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:32:04 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:32:04 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:32:04 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:32:04 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:32:04 bla kernel: [<ffffffff8020e7d2>] oops_end+0xb2/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:32:04 bla kernel: [<ffffffff802cf5b8>] 
__find_get_block_slow+0xa8/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf567>] 
__find_get_block_slow+0x57/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf9ae>] __find_get_block+0xce/0x200
Mar 21 18:32:04 bla kernel: [<ffffffff802a8455>] 
cache_alloc_refill+0x185/0x590
Mar 21 18:32:04 bla kernel: [<ffffffff802cfafe>] __getblk+0x1e/0x2f0
Mar 21 18:32:04 bla kernel: [<ffffffff8030d1e1>] 
__ext3_get_inode_loc+0x111/0x320
Mar 21 18:32:04 bla kernel: [<ffffffff8030d44c>] ext3_iget+0x5c/0x3f0
Mar 21 18:32:04 bla kernel: [<ffffffff803143e0>] ext3_lookup+0xb0/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802b48f0>] do_lookup+0x210/0x260
Mar 21 18:32:04 bla kernel: [<ffffffff802b6db5>] 
__link_path_walk+0x765/0x1000
Mar 21 18:32:04 bla kernel: [<ffffffff802c47b7>] mntput_no_expire+0x27/0x150
Mar 21 18:32:04 bla kernel: [<ffffffff802b7846>] path_walk+0x66/0xd0
Mar 21 18:32:04 bla kernel: [<ffffffff802b79e6>] do_path_lookup+0x96/0x1f0
Mar 21 18:32:04 bla kernel: [<ffffffff802b65ed>] getname+0x1bd/0x220
Mar 21 18:32:04 bla kernel: [<ffffffff802b88a7>] user_path_at+0x97/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff8033e8e0>] cap_d_instantiate+0x0/0x10
Mar 21 18:32:04 bla kernel: [<ffffffff802bac60>] filldir+0x0/0xe0
Mar 21 18:32:04 bla kernel: [<ffffffff802af714>] cp_new_stat+0xe4/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802afa40>] vfs_lstat_fd+0x20/0x60
Mar 21 18:32:04 bla kernel: [<ffffffff802afaa7>] sys_newlstat+0x27/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff80276e18>] 
audit_syscall_entry+0x148/0x170
Mar 21 18:32:04 bla kernel: [<ffffffff8020b8cb>] 
system_call_fastpath+0x16/0x1b
Mar 21 18:32:04 bla kernel: BUG: scheduling while atomic: ls/7339/0x10000002
Mar 21 18:32:04 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:32:04 bla kernel: Pid: 7339, comm: ls Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:32:04 bla kernel: Call Trace:
Mar 21 18:32:04 bla kernel: [<ffffffff80524ca0>] thread_return+0x11f/0x63f
Mar 21 18:32:04 bla kernel: [<ffffffff8029e978>] 
free_pages_and_swap_cache+0x88/0xb0
Mar 21 18:32:04 bla kernel: [<ffffffff8023b957>] __cond_resched+0x17/0x40
Mar 21 18:32:04 bla kernel: [<ffffffff805252c5>] _cond_resched+0x35/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff802912b3>] unmap_vmas+0x803/0x9a0
Mar 21 18:32:04 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:32:04 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:32:04 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:32:04 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:32:04 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:32:04 bla kernel: [<ffffffff8020e7d2>] oops_end+0xb2/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:32:04 bla kernel: [<ffffffff802cf5b8>] 
__find_get_block_slow+0xa8/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf567>] 
__find_get_block_slow+0x57/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf9ae>] __find_get_block+0xce/0x200
Mar 21 18:32:04 bla kernel: [<ffffffff802a8455>] 
cache_alloc_refill+0x185/0x590
Mar 21 18:32:04 bla kernel: [<ffffffff802cfafe>] __getblk+0x1e/0x2f0
Mar 21 18:32:04 bla kernel: [<ffffffff8030d1e1>] 
__ext3_get_inode_loc+0x111/0x320
Mar 21 18:32:04 bla kernel: [<ffffffff8030d44c>] ext3_iget+0x5c/0x3f0
Mar 21 18:32:04 bla kernel: [<ffffffff803143e0>] ext3_lookup+0xb0/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802b48f0>] do_lookup+0x210/0x260
Mar 21 18:32:04 bla kernel: [<ffffffff802b6db5>] 
__link_path_walk+0x765/0x1000
Mar 21 18:32:04 bla kernel: [<ffffffff802c47b7>] mntput_no_expire+0x27/0x150
Mar 21 18:32:04 bla kernel: [<ffffffff802b7846>] path_walk+0x66/0xd0
Mar 21 18:32:04 bla kernel: [<ffffffff802b79e6>] do_path_lookup+0x96/0x1f0
Mar 21 18:32:04 bla kernel: [<ffffffff802b65ed>] getname+0x1bd/0x220
Mar 21 18:32:04 bla kernel: [<ffffffff802b88a7>] user_path_at+0x97/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff8033e8e0>] cap_d_instantiate+0x0/0x10
Mar 21 18:32:04 bla kernel: [<ffffffff802bac60>] filldir+0x0/0xe0
Mar 21 18:32:04 bla kernel: [<ffffffff802af714>] cp_new_stat+0xe4/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802afa40>] vfs_lstat_fd+0x20/0x60
Mar 21 18:32:04 bla kernel: [<ffffffff802afaa7>] sys_newlstat+0x27/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff80276e18>] 
audit_syscall_entry+0x148/0x170
Mar 21 18:32:04 bla kernel: [<ffffffff8020b8cb>] 
system_call_fastpath+0x16/0x1b
Mar 21 18:32:04 bla kernel: BUG: scheduling while atomic: ls/7339/0x10000002
Mar 21 18:32:04 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:32:04 bla kernel: Pid: 7339, comm: ls Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:32:04 bla kernel: Call Trace:
Mar 21 18:32:04 bla kernel: [<ffffffff80524ca0>] thread_return+0x11f/0x63f
Mar 21 18:32:04 bla kernel: [<ffffffff8023b957>] __cond_resched+0x17/0x40
Mar 21 18:32:04 bla kernel: [<ffffffff805252c5>] _cond_resched+0x35/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff802912b3>] unmap_vmas+0x803/0x9a0
Mar 21 18:32:04 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:32:04 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:32:04 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:32:04 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:32:04 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:32:04 bla kernel: [<ffffffff8020e7d2>] oops_end+0xb2/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:32:04 bla kernel: [<ffffffff802cf5b8>] 
__find_get_block_slow+0xa8/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf567>] 
__find_get_block_slow+0x57/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf9ae>] __find_get_block+0xce/0x200
Mar 21 18:32:04 bla kernel: [<ffffffff802a8455>] 
cache_alloc_refill+0x185/0x590
Mar 21 18:32:04 bla kernel: [<ffffffff802cfafe>] __getblk+0x1e/0x2f0
Mar 21 18:32:04 bla kernel: [<ffffffff8030d1e1>] 
__ext3_get_inode_loc+0x111/0x320
Mar 21 18:32:04 bla kernel: [<ffffffff8030d44c>] ext3_iget+0x5c/0x3f0
Mar 21 18:32:04 bla kernel: [<ffffffff803143e0>] ext3_lookup+0xb0/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802b48f0>] do_lookup+0x210/0x260
Mar 21 18:32:04 bla kernel: [<ffffffff802b6db5>] 
__link_path_walk+0x765/0x1000
Mar 21 18:32:04 bla kernel: [<ffffffff802c47b7>] mntput_no_expire+0x27/0x150
Mar 21 18:32:04 bla kernel: [<ffffffff802b7846>] path_walk+0x66/0xd0
Mar 21 18:32:04 bla kernel: [<ffffffff802b79e6>] do_path_lookup+0x96/0x1f0
Mar 21 18:32:04 bla kernel: [<ffffffff802b65ed>] getname+0x1bd/0x220
Mar 21 18:32:04 bla kernel: [<ffffffff802b88a7>] user_path_at+0x97/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff8033e8e0>] cap_d_instantiate+0x0/0x10
Mar 21 18:32:04 bla kernel: [<ffffffff802bac60>] filldir+0x0/0xe0
Mar 21 18:32:04 bla kernel: [<ffffffff802af714>] cp_new_stat+0xe4/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802afa40>] vfs_lstat_fd+0x20/0x60
Mar 21 18:32:04 bla kernel: [<ffffffff802afaa7>] sys_newlstat+0x27/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff80276e18>] 
audit_syscall_entry+0x148/0x170
Mar 21 18:32:04 bla kernel: [<ffffffff8020b8cb>] 
system_call_fastpath+0x16/0x1b
Mar 21 18:32:04 bla kernel: BUG: scheduling while atomic: ls/7339/0x10000002
Mar 21 18:32:04 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:32:04 bla kernel: Pid: 7339, comm: ls Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:32:04 bla kernel: Call Trace:
Mar 21 18:32:04 bla kernel: [<ffffffff80524ca0>] thread_return+0x11f/0x63f
Mar 21 18:32:04 bla kernel: [<ffffffff8023b957>] __cond_resched+0x17/0x40
Mar 21 18:32:04 bla kernel: [<ffffffff805252c5>] _cond_resched+0x35/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff802912b3>] unmap_vmas+0x803/0x9a0
Mar 21 18:32:04 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:32:04 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:32:04 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:32:04 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:32:04 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:32:04 bla kernel: [<ffffffff8020e7d2>] oops_end+0xb2/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:32:04 bla kernel: [<ffffffff802cf5b8>] 
__find_get_block_slow+0xa8/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf567>] 
__find_get_block_slow+0x57/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf9ae>] __find_get_block+0xce/0x200
Mar 21 18:32:04 bla kernel: [<ffffffff802a8455>] 
cache_alloc_refill+0x185/0x590
Mar 21 18:32:04 bla kernel: [<ffffffff802cfafe>] __getblk+0x1e/0x2f0
Mar 21 18:32:04 bla kernel: [<ffffffff8030d1e1>] 
__ext3_get_inode_loc+0x111/0x320
Mar 21 18:32:04 bla kernel: [<ffffffff8030d44c>] ext3_iget+0x5c/0x3f0
Mar 21 18:32:04 bla kernel: [<ffffffff803143e0>] ext3_lookup+0xb0/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802b48f0>] do_lookup+0x210/0x260
Mar 21 18:32:04 bla kernel: [<ffffffff802b6db5>] 
__link_path_walk+0x765/0x1000
Mar 21 18:32:04 bla kernel: [<ffffffff802c47b7>] mntput_no_expire+0x27/0x150
Mar 21 18:32:04 bla kernel: [<ffffffff802b7846>] path_walk+0x66/0xd0
Mar 21 18:32:04 bla kernel: [<ffffffff802b79e6>] do_path_lookup+0x96/0x1f0
Mar 21 18:32:04 bla kernel: [<ffffffff802b65ed>] getname+0x1bd/0x220
Mar 21 18:32:04 bla kernel: [<ffffffff802b88a7>] user_path_at+0x97/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff8033e8e0>] cap_d_instantiate+0x0/0x10
Mar 21 18:32:04 bla kernel: [<ffffffff802bac60>] filldir+0x0/0xe0
Mar 21 18:32:04 bla kernel: [<ffffffff802af714>] cp_new_stat+0xe4/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802afa40>] vfs_lstat_fd+0x20/0x60
Mar 21 18:32:04 bla kernel: [<ffffffff802afaa7>] sys_newlstat+0x27/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff80276e18>] 
audit_syscall_entry+0x148/0x170
Mar 21 18:32:04 bla kernel: [<ffffffff8020b8cb>] 
system_call_fastpath+0x16/0x1b
Mar 21 18:32:04 bla kernel: BUG: scheduling while atomic: ls/7339/0x10000002
Mar 21 18:32:04 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:32:04 bla kernel: Pid: 7339, comm: ls Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:32:04 bla kernel: Call Trace:
Mar 21 18:32:04 bla kernel: [<ffffffff80524ca0>] thread_return+0x11f/0x63f
Mar 21 18:32:04 bla kernel: [<ffffffff8023b957>] __cond_resched+0x17/0x40
Mar 21 18:32:04 bla kernel: [<ffffffff805252c5>] _cond_resched+0x35/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff802912b3>] unmap_vmas+0x803/0x9a0
Mar 21 18:32:04 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:32:04 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:32:04 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:32:04 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:32:04 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:32:04 bla kernel: [<ffffffff8020e7d2>] oops_end+0xb2/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:32:04 bla kernel: [<ffffffff802cf5b8>] 
__find_get_block_slow+0xa8/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf567>] 
__find_get_block_slow+0x57/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf9ae>] __find_get_block+0xce/0x200
Mar 21 18:32:04 bla kernel: [<ffffffff802a8455>] 
cache_alloc_refill+0x185/0x590
Mar 21 18:32:04 bla kernel: [<ffffffff802cfafe>] __getblk+0x1e/0x2f0
Mar 21 18:32:04 bla kernel: [<ffffffff8030d1e1>] 
__ext3_get_inode_loc+0x111/0x320
Mar 21 18:32:04 bla kernel: [<ffffffff8030d44c>] ext3_iget+0x5c/0x3f0
Mar 21 18:32:04 bla kernel: [<ffffffff803143e0>] ext3_lookup+0xb0/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802b48f0>] do_lookup+0x210/0x260
Mar 21 18:32:04 bla kernel: [<ffffffff802b6db5>] 
__link_path_walk+0x765/0x1000
Mar 21 18:32:04 bla kernel: [<ffffffff802c47b7>] mntput_no_expire+0x27/0x150
Mar 21 18:32:04 bla kernel: [<ffffffff802b7846>] path_walk+0x66/0xd0
Mar 21 18:32:04 bla kernel: [<ffffffff802b79e6>] do_path_lookup+0x96/0x1f0
Mar 21 18:32:04 bla kernel: [<ffffffff802b65ed>] getname+0x1bd/0x220
Mar 21 18:32:04 bla kernel: [<ffffffff802b88a7>] user_path_at+0x97/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff8033e8e0>] cap_d_instantiate+0x0/0x10
Mar 21 18:32:04 bla kernel: [<ffffffff802bac60>] filldir+0x0/0xe0
Mar 21 18:32:04 bla kernel: [<ffffffff802af714>] cp_new_stat+0xe4/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802afa40>] vfs_lstat_fd+0x20/0x60
Mar 21 18:32:04 bla kernel: [<ffffffff802afaa7>] sys_newlstat+0x27/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff80276e18>] 
audit_syscall_entry+0x148/0x170
Mar 21 18:32:04 bla kernel: [<ffffffff8020b8cb>] 
system_call_fastpath+0x16/0x1b
Mar 21 18:32:04 bla kernel: BUG: scheduling while atomic: ls/7339/0x10000002
Mar 21 18:32:04 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:32:04 bla kernel: Pid: 7339, comm: ls Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:32:04 bla kernel: Call Trace:
Mar 21 18:32:04 bla kernel: [<ffffffff80524ca0>] thread_return+0x11f/0x63f
Mar 21 18:32:04 bla kernel: [<ffffffff8023b957>] __cond_resched+0x17/0x40
Mar 21 18:32:04 bla kernel: [<ffffffff805252c5>] _cond_resched+0x35/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff802912b3>] unmap_vmas+0x803/0x9a0
Mar 21 18:32:04 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:32:04 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:32:04 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:32:04 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:32:04 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:32:04 bla kernel: [<ffffffff8020e7d2>] oops_end+0xb2/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:32:04 bla kernel: [<ffffffff802cf5b8>] 
__find_get_block_slow+0xa8/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf567>] 
__find_get_block_slow+0x57/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf9ae>] __find_get_block+0xce/0x200
Mar 21 18:32:04 bla kernel: [<ffffffff802a8455>] 
cache_alloc_refill+0x185/0x590
Mar 21 18:32:04 bla kernel: [<ffffffff802cfafe>] __getblk+0x1e/0x2f0
Mar 21 18:32:04 bla kernel: [<ffffffff8030d1e1>] 
__ext3_get_inode_loc+0x111/0x320
Mar 21 18:32:04 bla kernel: [<ffffffff8030d44c>] ext3_iget+0x5c/0x3f0
Mar 21 18:32:04 bla kernel: [<ffffffff803143e0>] ext3_lookup+0xb0/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802b48f0>] do_lookup+0x210/0x260
Mar 21 18:32:04 bla kernel: [<ffffffff802b6db5>] 
__link_path_walk+0x765/0x1000
Mar 21 18:32:04 bla kernel: [<ffffffff802c47b7>] mntput_no_expire+0x27/0x150
Mar 21 18:32:04 bla kernel: [<ffffffff802b7846>] path_walk+0x66/0xd0
Mar 21 18:32:04 bla kernel: [<ffffffff802b79e6>] do_path_lookup+0x96/0x1f0
Mar 21 18:32:04 bla kernel: [<ffffffff802b65ed>] getname+0x1bd/0x220
Mar 21 18:32:04 bla kernel: [<ffffffff802b88a7>] user_path_at+0x97/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff8033e8e0>] cap_d_instantiate+0x0/0x10
Mar 21 18:32:04 bla kernel: [<ffffffff802bac60>] filldir+0x0/0xe0
Mar 21 18:32:04 bla kernel: [<ffffffff802af714>] cp_new_stat+0xe4/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802afa40>] vfs_lstat_fd+0x20/0x60
Mar 21 18:32:04 bla kernel: [<ffffffff802afaa7>] sys_newlstat+0x27/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff80276e18>] 
audit_syscall_entry+0x148/0x170
Mar 21 18:32:04 bla kernel: [<ffffffff8020b8cb>] 
system_call_fastpath+0x16/0x1b
Mar 21 18:32:04 bla kernel: BUG: scheduling while atomic: ls/7339/0x10000002
Mar 21 18:32:04 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:32:04 bla kernel: Pid: 7339, comm: ls Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:32:04 bla kernel: Call Trace:
Mar 21 18:32:04 bla kernel: [<ffffffff80524ca0>] thread_return+0x11f/0x63f
Mar 21 18:32:04 bla kernel: [<ffffffff8023b957>] __cond_resched+0x17/0x40
Mar 21 18:32:04 bla kernel: [<ffffffff805252c5>] _cond_resched+0x35/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff802912b3>] unmap_vmas+0x803/0x9a0
Mar 21 18:32:04 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:32:04 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:32:04 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:32:04 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:32:04 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:32:04 bla kernel: [<ffffffff8020e7d2>] oops_end+0xb2/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:32:04 bla kernel: [<ffffffff802cf5b8>] 
__find_get_block_slow+0xa8/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf567>] 
__find_get_block_slow+0x57/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf9ae>] __find_get_block+0xce/0x200
Mar 21 18:32:04 bla kernel: [<ffffffff802a8455>] 
cache_alloc_refill+0x185/0x590
Mar 21 18:32:04 bla kernel: [<ffffffff802cfafe>] __getblk+0x1e/0x2f0
Mar 21 18:32:04 bla kernel: [<ffffffff8030d1e1>] 
__ext3_get_inode_loc+0x111/0x320
Mar 21 18:32:04 bla kernel: [<ffffffff8030d44c>] ext3_iget+0x5c/0x3f0
Mar 21 18:32:04 bla kernel: [<ffffffff803143e0>] ext3_lookup+0xb0/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802b48f0>] do_lookup+0x210/0x260
Mar 21 18:32:04 bla kernel: [<ffffffff802b6db5>] 
__link_path_walk+0x765/0x1000
Mar 21 18:32:04 bla kernel: [<ffffffff802c47b7>] mntput_no_expire+0x27/0x150
Mar 21 18:32:04 bla kernel: [<ffffffff802b7846>] path_walk+0x66/0xd0
Mar 21 18:32:04 bla kernel: [<ffffffff802b79e6>] do_path_lookup+0x96/0x1f0
Mar 21 18:32:04 bla kernel: [<ffffffff802b65ed>] getname+0x1bd/0x220
Mar 21 18:32:04 bla kernel: [<ffffffff802b88a7>] user_path_at+0x97/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff8033e8e0>] cap_d_instantiate+0x0/0x10
Mar 21 18:32:04 bla kernel: [<ffffffff802bac60>] filldir+0x0/0xe0
Mar 21 18:32:04 bla kernel: [<ffffffff802af714>] cp_new_stat+0xe4/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802afa40>] vfs_lstat_fd+0x20/0x60
Mar 21 18:32:04 bla kernel: [<ffffffff802afaa7>] sys_newlstat+0x27/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff80276e18>] 
audit_syscall_entry+0x148/0x170
Mar 21 18:32:04 bla kernel: [<ffffffff8020b8cb>] 
system_call_fastpath+0x16/0x1b
Mar 21 18:32:04 bla kernel: BUG: scheduling while atomic: ls/7339/0x10000002
Mar 21 18:32:04 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:32:04 bla kernel: Pid: 7339, comm: ls Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:32:04 bla kernel: Call Trace:
Mar 21 18:32:04 bla kernel: [<ffffffff80524ca0>] thread_return+0x11f/0x63f
Mar 21 18:32:04 bla kernel: [<ffffffff8023b957>] __cond_resched+0x17/0x40
Mar 21 18:32:04 bla kernel: [<ffffffff805252c5>] _cond_resched+0x35/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff802912b3>] unmap_vmas+0x803/0x9a0
Mar 21 18:32:04 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:32:04 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:32:04 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:32:04 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:32:04 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:32:04 bla kernel: [<ffffffff8020e7d2>] oops_end+0xb2/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:32:04 bla kernel: [<ffffffff802cf5b8>] 
__find_get_block_slow+0xa8/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf567>] 
__find_get_block_slow+0x57/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf9ae>] __find_get_block+0xce/0x200
Mar 21 18:32:04 bla kernel: [<ffffffff802a8455>] 
cache_alloc_refill+0x185/0x590
Mar 21 18:32:04 bla kernel: [<ffffffff802cfafe>] __getblk+0x1e/0x2f0
Mar 21 18:32:04 bla kernel: [<ffffffff8030d1e1>] 
__ext3_get_inode_loc+0x111/0x320
Mar 21 18:32:04 bla kernel: [<ffffffff8030d44c>] ext3_iget+0x5c/0x3f0
Mar 21 18:32:04 bla kernel: [<ffffffff803143e0>] ext3_lookup+0xb0/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802b48f0>] do_lookup+0x210/0x260
Mar 21 18:32:04 bla kernel: [<ffffffff802b6db5>] 
__link_path_walk+0x765/0x1000
Mar 21 18:32:04 bla kernel: [<ffffffff802c47b7>] mntput_no_expire+0x27/0x150
Mar 21 18:32:04 bla kernel: [<ffffffff802b7846>] path_walk+0x66/0xd0
Mar 21 18:32:04 bla kernel: [<ffffffff802b79e6>] do_path_lookup+0x96/0x1f0
Mar 21 18:32:04 bla kernel: [<ffffffff802b65ed>] getname+0x1bd/0x220
Mar 21 18:32:04 bla kernel: [<ffffffff802b88a7>] user_path_at+0x97/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff8033e8e0>] cap_d_instantiate+0x0/0x10
Mar 21 18:32:04 bla kernel: [<ffffffff802bac60>] filldir+0x0/0xe0
Mar 21 18:32:04 bla kernel: [<ffffffff802af714>] cp_new_stat+0xe4/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802afa40>] vfs_lstat_fd+0x20/0x60
Mar 21 18:32:04 bla kernel: [<ffffffff802afaa7>] sys_newlstat+0x27/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff80276e18>] 
audit_syscall_entry+0x148/0x170
Mar 21 18:32:04 bla kernel: [<ffffffff8020b8cb>] 
system_call_fastpath+0x16/0x1b
Mar 21 18:32:04 bla kernel: BUG: scheduling while atomic: ls/7339/0x10000002
Mar 21 18:32:04 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:32:04 bla kernel: Pid: 7339, comm: ls Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:32:04 bla kernel: Call Trace:
Mar 21 18:32:04 bla kernel: [<ffffffff80524ca0>] thread_return+0x11f/0x63f
Mar 21 18:32:04 bla kernel: [<ffffffff8023b957>] __cond_resched+0x17/0x40
Mar 21 18:32:04 bla kernel: [<ffffffff805252c5>] _cond_resched+0x35/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff802912b3>] unmap_vmas+0x803/0x9a0
Mar 21 18:32:04 bla kernel: [<ffffffff80296505>] exit_mmap+0xb5/0x1c0
Mar 21 18:32:04 bla kernel: [<ffffffff8023cb45>] mmput+0x25/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff802409d1>] exit_mm+0xf1/0x130
Mar 21 18:32:04 bla kernel: [<ffffffff80276c7a>] audit_free+0x24a/0x2a0
Mar 21 18:32:04 bla kernel: [<ffffffff80242654>] do_exit+0x164/0x8f0
Mar 21 18:32:04 bla kernel: [<ffffffff805244fa>] printk+0x40/0x46
Mar 21 18:32:04 bla kernel: [<ffffffff8020e7d2>] oops_end+0xb2/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff80527389>] error_exit+0x0/0x51
Mar 21 18:32:04 bla kernel: [<ffffffff802cf5b8>] 
__find_get_block_slow+0xa8/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf567>] 
__find_get_block_slow+0x57/0x120
Mar 21 18:32:04 bla kernel: [<ffffffff802cf9ae>] __find_get_block+0xce/0x200
Mar 21 18:32:04 bla kernel: [<ffffffff802a8455>] 
cache_alloc_refill+0x185/0x590
Mar 21 18:32:04 bla kernel: [<ffffffff802cfafe>] __getblk+0x1e/0x2f0
Mar 21 18:32:04 bla kernel: [<ffffffff8030d1e1>] 
__ext3_get_inode_loc+0x111/0x320
Mar 21 18:32:04 bla kernel: [<ffffffff8030d44c>] ext3_iget+0x5c/0x3f0
Mar 21 18:32:04 bla kernel: [<ffffffff803143e0>] ext3_lookup+0xb0/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802b48f0>] do_lookup+0x210/0x260
Mar 21 18:32:04 bla kernel: [<ffffffff802b6db5>] 
__link_path_walk+0x765/0x1000
Mar 21 18:32:04 bla kernel: [<ffffffff802c47b7>] mntput_no_expire+0x27/0x150
Mar 21 18:32:04 bla kernel: [<ffffffff802b7846>] path_walk+0x66/0xd0
Mar 21 18:32:04 bla kernel: [<ffffffff802b79e6>] do_path_lookup+0x96/0x1f0
Mar 21 18:32:04 bla kernel: [<ffffffff802b65ed>] getname+0x1bd/0x220
Mar 21 18:32:04 bla kernel: [<ffffffff802b88a7>] user_path_at+0x97/0xc0
Mar 21 18:32:04 bla kernel: [<ffffffff8033e8e0>] cap_d_instantiate+0x0/0x10
Mar 21 18:32:04 bla kernel: [<ffffffff802bac60>] filldir+0x0/0xe0
Mar 21 18:32:04 bla kernel: [<ffffffff802af714>] cp_new_stat+0xe4/0x100
Mar 21 18:32:04 bla kernel: [<ffffffff802afa40>] vfs_lstat_fd+0x20/0x60
Mar 21 18:32:04 bla kernel: [<ffffffff802afaa7>] sys_newlstat+0x27/0x50
Mar 21 18:32:04 bla kernel: [<ffffffff80276e18>] 
audit_syscall_entry+0x148/0x170
Mar 21 18:32:04 bla kernel: [<ffffffff8020b8cb>] 
system_call_fastpath+0x16/0x1b
Mar 21 18:32:22 bla kerneloops: Submitted 1 kernel oopses to 
www.kerneloops.org
Mar 21 18:33:33 bla megatec[2717]: Communications with UPS lost: No 
status from UPS.
Mar 21 18:33:35 bla kernel: BUG: soft lockup - CPU#0 stuck for 61s! 
[mono:18925]
Mar 21 18:33:35 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:33:35 bla kernel: CPU 0:
Mar 21 18:33:35 bla kernel: Modules linked in: amd5536udc udf crc_itu_t 
nfs cdc_ether vfat fat usb_storage ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables nf_conntrack_netbios_ns ipt_REJECT xt_tcpudp 
xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nfsd 
lockd nfs_acl exportfs eeprom it87 hwmon_vid sunrpc bridge stp llc ipv6 
powernow_k8 binfmt_misc snd_hda_intel ppdev snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device floppy snd_pcm_oss 
snd_mixer_oss ohci1394 snd_pcm k10temp ieee1394 parport_pc i2c_piix4 
usblp snd_timer sg parport snd snd_page_alloc button ohci_hcd ehci_hcd 
[last unloaded: nf_conntrack]
Mar 21 18:33:35 bla kernel: Pid: 18925, comm: mono Tainted: G    B D W 
2.6.28.2 #8
Mar 21 18:33:35 bla kernel: RIP: 0010:[<ffffffff80526aee>] 
[<ffffffff80526aee>] _spin_lock+0x1e/0x30
Mar 21 18:33:35 bla kernel: RSP: 0000:ffff88012eb37ad8  EFLAGS: 00000297
Mar 21 18:33:35 bla kernel: RAX: 0000000000003534 RBX: 0000000001058025 
RCX: 0000000000000002
Mar 21 18:33:35 bla kernel: RDX: 0000000000000000 RSI: 0000000000000002 
RDI: 0000000000000001
Mar 21 18:33:35 bla kernel: RBP: 0000000001058025 R08: ffffe20000f97ee0 
R09: ffff88012aba5190
Mar 21 18:33:35 bla kernel: R10: ffff88012ebd6800 R11: 0000000000000000 
R12: ffffffff805251f7
Mar 21 18:33:35 bla kernel: R13: ffff88012eb37a58 R14: ffffffff802d08d0 
R15: ffff880028006b68
Mar 21 18:33:35 bla kernel: FS:  00007f6dca544950(0000) 
GS:ffffffff8071c040(0000) knlGS:00000000f7f66750
Mar 21 18:33:35 bla kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Mar 21 18:33:35 bla kernel: CR2: 00007f6dc4f492a8 CR3: 0000000129955000 
CR4: 00000000000006e0
Mar 21 18:33:35 bla kernel: DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
Mar 21 18:33:35 bla kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 
DR7: 0000000000000400
Mar 21 18:33:35 bla kernel: Call Trace:
Mar 21 18:33:35 bla kernel: [<ffffffff80526ade>] ? _spin_lock+0xe/0x30
Mar 21 18:33:35 bla kernel: [<ffffffff802cf567>] ? 
__find_get_block_slow+0x57/0x120
Mar 21 18:33:35 bla kernel: [<ffffffff802cf9ae>] ? 
__find_get_block+0xce/0x200
Mar 21 18:33:35 bla kernel: [<ffffffff80320bae>] ? 
do_get_write_access+0x4fe/0x680
Mar 21 18:33:35 bla kernel: [<ffffffff802cfafe>] ? __getblk+0x1e/0x2f0
Mar 21 18:33:35 bla kernel: [<ffffffff8030d1e1>] ? 
__ext3_get_inode_loc+0x111/0x320
Mar 21 18:33:35 bla kernel: [<ffffffff8030d833>] ? 
ext3_reserve_inode_write+0x33/0xb0
Mar 21 18:33:35 bla kernel: [<ffffffff8030d8d1>] ? 
ext3_mark_inode_dirty+0x21/0x50
Mar 21 18:33:35 bla kernel: [<ffffffff80321736>] ? journal_start+0x96/0xe0
Mar 21 18:33:35 bla kernel: [<ffffffff8030da6a>] ? 
ext3_dirty_inode+0x5a/0xb0
Mar 21 18:33:35 bla kernel: [<ffffffff802cb344>] ? 
__mark_inode_dirty+0x34/0x1d0
Mar 21 18:33:35 bla kernel: [<ffffffff802bff80>] ? 
file_update_time+0x110/0x130
Mar 21 18:33:35 bla kernel: [<ffffffff8029057f>] ? do_wp_page+0x39f/0x640
Mar 21 18:33:35 bla kernel: [<ffffffff802924df>] ? 
handle_mm_fault+0x7cf/0x840
Mar 21 18:33:35 bla kernel: [<ffffffff80526cbf>] ? 
_spin_lock_irqsave+0x1f/0x50
Mar 21 18:33:35 bla kernel: [<ffffffff80227cf0>] ? do_page_fault+0x2e0/0x970
Mar 21 18:33:35 bla kernel: [<ffffffff80526f22>] ? 
_spin_unlock_irqrestore+0x12/0x40
Mar 21 18:33:35 bla kernel: [<ffffffff80259280>] ? 
hrtimer_try_to_cancel+0x50/0xc0
Mar 21 18:33:35 bla kernel: [<ffffffff80259302>] ? hrtimer_cancel+0x12/0x20
Mar 21 18:33:35 bla kernel: [<ffffffff80525c60>] ? do_nanosleep+0x40/0xd0
Mar 21 18:33:35 bla kernel: [<ffffffff8025963e>] ? 
hrtimer_nanosleep+0xae/0x150
Mar 21 18:33:35 bla kernel: [<ffffffff80258b10>] ? hrtimer_wakeup+0x0/0x30
Mar 21 18:33:35 bla kernel: [<ffffffff80525c9e>] ? do_nanosleep+0x7e/0xd0
Mar 21 18:33:35 bla kernel: [<ffffffff80527389>] ? error_exit+0x0/0x51
Mar 21 18:33:36 bla megatec[2717]: Communications with UPS lost: No 
status from UPS.
Mar 21 18:41:37 bla kernel: imklog 3.21.10, log source = /proc/kmsg started.
