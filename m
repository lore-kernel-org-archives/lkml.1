Return-Path: <linux-kernel-owner+w=401wt.eu-S933510AbXDAQLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510AbXDAQLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 12:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933591AbXDAQLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 12:11:35 -0400
Received: from raven.upol.cz ([158.194.120.4]:43829 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510AbXDAQLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 12:11:33 -0400
Cc: Hamish Moffatt <hamish@debian.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.17->2.6.18(and 20) K8 SMP ondemand and userspace: General protection fault (bts Bug#415239)
Organization: Palacky University in Olomouc, experimental physics department.
Date: Sun, 1 Apr 2007 18:20:42 +0200
Message-Id: <E1HY2nK-0002VP-Rp@flower>
From: Oleg Verych <olecom@flower.upol.cz>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While it's only one such report so far, could you, please look at it?

There is some info below, full story:

<http://bugs.debian.org/415239> (from the bottom).

Thanks.

On Wed, Mar 21, 2007 at 08:36:51AM +1100, Hamish Moffatt wrote:
> On Tue, Mar 20, 2007 at 01:10:42AM +0100, Oleg Verych wrote:
> > On Tue, Mar 20, 2007 at 08:19:28AM +1100, Hamish Moffatt wrote:
> > > On Mon, Mar 19, 2007 at 02:49:48PM +0100, Oleg Verych wrote:
> > > > On Tue, Mar 20, 2007 at 12:09:30AM +1100, Hamish Moffatt wrote:
> > > > []
> > > > > > Why ondemand governor is bad?
> > > > > 
> > > > > Hi,
> > > > > 
> > > > > I have been using userspace/powernowd because it worked for me until
> > > > > now. I have no preference though. I just switched to the ondemand
> > > > > governor and it seems to be working so far.
> > > > > 
> > > > > Should cpufreq-userspace be removed if it can cause general protection
> > > > > faults?
> > > > 
> > > > That was daemon's problem, maybe some rules has changed since 2.6.16
> > > > or so, when it was updated. The userspace governor works form me, i
> > > > setup laptop on minimum, and if building a kernel switch on maximum:
> > > > 
> > > > cd /sys/devices/system/cpu/cpu0/cpufreq/
> > > > echo userspace > scaling_governor
> > > > dd<scaling_min_freq>scaling_setspeed # or max here
> > > > cd /tmp
> > > 
> > > It turns out that the system still crashes with cpufreq-ondemand, except
> > > the call stack now shows internal kernel threaders rather than
> > > powernowd.
> > 
> > Again, please try to reproduce this without taining the kernel.
> 
> Sure. Well it crashed just as hard although the trace seems quite
> different. The machine would have been pretty idle until this particular
> perl task started (which is the storeBackup package thrashing the disk).
> 
> Hamish
> 
> 
> Mar 21 06:30:21 noddy kernel: general protection fault: 0000 [1] SMP
> Mar 21 06:30:21 noddy kernel: CPU 0
> Mar 21 06:30:21 noddy kernel: Modules linked in: tcp_diag inet_diag binfmt_misc rfcomm l2cap bluetooth nfs lockd nfs_acl sunrpc tun ipt_ULOG ipt_recent xt_state ip_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables mkiss ax25 crc16 ipv6 parport_serial parport_pc dm_snapshot dm_mirror dm_mod it87 hwmon_vid i2c_isa lp parport cpufreq_ondemand powernow_k8 freq_table processor ide_disk ide_generic ide_cd cdrom eth1394 snd_ens1371 snd_seq_dummy snd_seq_oss usb_storage snd_seq_midi snd_seq_midi_event snd_seq tsdev snd_rawmidi snd_intel8x0 snd_seq_device snd_ac97_codec snd_ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm ohci1394 snd_timer snd ieee1394 skge amd74xx sata_sil i2c_nforce2 analog soundcore i2c_core floppy psmouse forcedeth gameport snd_page_alloc ehci_hcd shpchp pci_hotplug ohci_hcd pcspkr serio_raw ext3 jbd mbcache raid1 md_mod sd_mod generic ide_core sata_nv libata scsi_mod evdev
> Mar 21 06:30:21 noddy kernel: Pid: 7853, comm: perl Not tainted 2.6.18-4-amd64 #1
> Mar 21 06:30:21 noddy kernel: RIP: 0010:[<ffffffff80221c19>]  [<ffffffff80221c19>] vma_prio_tree_remove+0x29/0xe6
> Mar 21 06:30:21 noddy kernel: RSP: 0018:ffff81002070bc58  EFLAGS: 00010246
> Mar 21 06:30:21 noddy kernel: RAX: fffc810047b53390 RBX: 0000000000000000 RCX: 00002b73d9c6b000
> Mar 21 06:30:21 noddy kernel: RDX: ffff81007ebe80d0 RSI: ffff810039190700 RDI: ffff8100391906b8
> Mar 21 06:30:21 noddy kernel: RBP: ffff810068678e80 R08: ffff81007e2b8248 R09: ffff81000000c400
> Mar 21 06:30:21 noddy kernel: R10: 0000000061fd1972 R11: 00000000397c758f R12: ffff8100391906b8
> Mar 21 06:30:21 noddy kernel: R13: 00002b73d979a000 R14: 0000000000000000 R15: 0000000000000000
> Mar 21 06:30:21 noddy kernel: FS:  00002b73da1f3ae0(0000) GS:ffffffff80521000(0000) knlGS:0000000000000000
> Mar 21 06:30:21 noddy kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Mar 21 06:30:21 noddy kernel: CR2: 0000000000aa8060 CR3: 0000000020784000 CR4: 00000000000006e0
> Mar 21 06:30:21 noddy kernel: Process perl (pid: 7853, threadinfo ffff81002070a000, task ffff810031f8f7b0)
> Mar 21 06:30:21 noddy kernel: Stack:  00000000013fefff ffff81007e2b8228 ffff810068678e80 ffffffff8021c6f2
> Mar 21 06:30:21 noddy kernel:  ffff810039190978 ffff8100391906b8 ffff810039190978 ffffffff8021ca3f
> Mar 21 06:30:21 noddy kernel:  ffff81002070bce0 ffff81002070bce0 ffff810055860608 ffff810062e7d600
> Mar 21 06:30:21 noddy kernel: Call Trace:
> Mar 21 06:30:21 noddy kernel:  [<ffffffff8021c6f2>] unlink_file_vma+0x31/0x3d
> Mar 21 06:30:21 noddy kernel:  [<ffffffff8021ca3f>] free_pgtables+0x69/0x99
> Mar 21 06:30:21 noddy kernel:  [<ffffffff80237c76>] exit_mmap+0x91/0xf1
> Mar 21 06:30:21 noddy kernel:  [<ffffffff80239d12>] mmput+0x28/0x98
> Mar 21 06:30:21 noddy kernel:  [<ffffffff8022a613>] flush_old_exec+0x802/0xb09
> Mar 21 06:30:21 noddy kernel:  [<ffffffff8020b009>] vfs_read+0x13c/0x171
> Mar 21 06:30:21 noddy kernel:  [<ffffffff8021636f>] load_elf_binary+0x447/0x199c
> Mar 21 06:30:21 noddy kernel:  [<ffffffff8020de4a>] __alloc_pages+0x5c/0x2a9
> Mar 21 06:30:21 noddy kernel:  [<ffffffff8020de4a>] __alloc_pages+0x5c/0x2a9
> Mar 21 06:30:21 noddy kernel:  [<ffffffff8023d73f>] search_binary_handler+0xa8/0x254
> Mar 21 06:30:21 noddy kernel:  [<ffffffff8023cda4>] do_execve+0x18c/0x242
> Mar 21 06:30:21 noddy kernel:  [<ffffffff80250732>] sys_execve+0x36/0x90
> Mar 21 06:30:21 noddy kernel:  [<ffffffff8025888f>] stub_execve+0x67/0xb0
> Mar 21 06:30:21 noddy kernel:
> Mar 21 06:30:21 noddy kernel:
> Mar 21 06:30:21 noddy kernel: Code: 48 89 10 48 89 76 08 48 89 77 48 e9 a9 00 00 00 4c 89 c7 41
> Mar 21 06:30:21 noddy kernel: RIP  [<ffffffff80221c19>] vma_prio_tree_remove+0x29/0xe6
> Mar 21 06:30:21 noddy kernel:  RSP <ffff81002070bc58>

vma_prio_tree_remove+{0x25,0x29}:
  25:   48 89 42 08             mov    %rax,0x8(%rdx)
  29:   48 89 10                mov    %rdx,(%rax)

and this is the code:

static inline void __list_del(struct list_head * prev, struct list_head * next)
{
        next->prev = prev;
        prev->next = next;
}

So, 'prev' entry seems to have a wrong address:
      RAX: fffc810047b53390
while everything else is in address
           ffff8100.....

> Mar 21 06:30:30 noddy kernel:
> Mar 21 06:30:30 noddy kernel: Call Trace:
> Mar 21 06:30:30 noddy kernel:  <IRQ> [<ffffffff802a3fec>] softlockup_tick+0xdb/0xed
> Mar 21 06:30:30 noddy kernel:  [<ffffffff802881df>] update_process_times+0x42/0x68
> Mar 21 06:30:30 noddy kernel:  [<ffffffff8026cbd8>] smp_local_timer_interrupt+0x23/0x47
> Mar 21 06:30:30 noddy kernel:  [<ffffffff8026d2cc>] smp_apic_timer_interrupt+0x41/0x47
> Mar 21 06:30:30 noddy kernel:  [<ffffffff8025904a>] apic_timer_interrupt+0x66/0x6c
> Mar 21 06:30:30 noddy kernel:  <EOI> [<ffffffff8020823e>] copy_page_range+0x4e0/0x645
> Mar 21 06:30:30 noddy kernel:  [<ffffffff8025e906>] .text.lock.spinlock+0x2/0x8a
> Mar 21 06:30:30 noddy kernel:  [<ffffffff8021d743>] copy_process+0xbc4/0x1490
> Mar 21 06:30:30 noddy kernel:  [<ffffffff8022f091>] do_fork+0xcd/0x1d0
> Mar 21 06:30:30 noddy kernel:  [<ffffffff802584d6>] system_call+0x7e/0x83
> Mar 21 06:30:30 noddy kernel:  [<ffffffff802587e3>] ptregscall_common+0x67/0xac
> Mar 21 06:30:30 noddy kernel:
> 
____
