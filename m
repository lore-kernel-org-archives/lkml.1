Return-Path: <linux-kernel-owner+w=401wt.eu-S932633AbZJOFiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbZJOFiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 01:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZJOFiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 01:38:04 -0400
Received: from aa.81.b6.static.xlhost.com ([207.182.129.170]:53907 "EHLO
	wombat.diezmil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZJOFiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 01:38:03 -0400
Date: Thu, 15 Oct 2009 01:37:00 -0400
From: dtslinux@hotmail.com
Reply-To: dtslinux@hotmail.com
To: linux-kernel@vger.kernel.org
Message-ID: <14962053.21255585019872.JavaMail.root@wombat>
Subject: pdflush bug in rt27 patch for 2.6.24.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am having an issue in kernel 2.6.24.7 with RT-27 patch. I am using a block device driver that is doing I/O operations on a virtual device. The driver is using separate kernel threads to perform read and write operations. The driver is working fine in the normal kernels, it is also working fine in RT-27 patch with 2.6.24.7 kernel, but some times I am getting following bug when performing write test with xdd benchmark (in RT-27 patch with 2.6.24.7 kernel)  :

WARNING: at kernel/rtmutex.c:979 rt_spin_lock()
Pid: 12634, comm: pdflush Tainted: GF       2.6.24.7-rt27 #9
 [<c04046b8>] show_trace_log_lvl+0x1f/0x34
 [<c0404f67>] show_trace+0x17/0x19
 [<c04052e2>] dump_stack+0x6f/0x75
 [<c063ac74>] rt_spin_lock+0x4a/0xa2
 [<c04f33a4>] cfq_exit_io_context+0x30/0x56
 [<c04ed88f>] exit_io_context+0x68/0x72
 [<c04206c1>] do_exit+0x6c2/0x739
 [<c040432d>] kernel_thread_helper+0xd/0x10
 =======================

<1>BUG: unable to handle kernel NULL pointer dereference at virtual address 0000003d
printing eip: c043d18a *pdpt = 00000000349dd001 *pde = 0000000000000000

<0>Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
Modules linked in: sysfs_driver(F) regularcache(F) dts nls_utf8 hfsplus ramdisk_driver bridge autofs4 hidp rfcomm l2cap bluetooth sunrpc ib_iser libiscsi scsi_transport_iscsi ib_srp scsi_transport_srp ib_ipoib ipv6 rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ib_sa ib_mad ib_core dm_mirror dm_multipath dm_mod sbs sbshc battery ac lp floppy sg serio_raw parport_pc parport snd_intel8x0 snd_ac97_codec 8250_pnp ac97_bus snd_seq_dummy 8250 serial_core snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss button snd_pcm e1000 snd_timer snd soundcore i2c_i801 snd_page_alloc i2c_core pcspkr ata_piix libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd

Pid: 12634, comm: pdflush Tainted: GF       (2.6.24.7-rt27 #9)
EIP: 0060:[<c043d18a>] EFLAGS: 00010016 CPU: 0
EIP is at task_blocks_on_rt_mutex+0xf8/0x240
EAX: ef42406c EBX: 0000001a ECX: ef424044 EDX: ef424044
ESI: ef424044 EDI: 00000009 EBP: e7ba7eec ESP: e7ba7ebc
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 preempt:00000003
Process pdflush (pid: 12634, ti=e7ba7000 task=e5268060 task.ti=e7ba7000)
Stack: 00000001 ef424054 ef424044 00000296 00000000 e7ba7f04 ef424044 00000009
       e7ba7f1c 00000296 ef424044 00000296 e7ba7f58 c063a57e 00000296 00000046
       00000000 ffffffff 00000078 e7ba7f08 e7ba7f08 e7ba7f10 e7ba7f10 00000000
Call Trace:
 [<c04046b8>] show_trace_log_lvl+0x1f/0x34
 [<c0404772>] show_stack_log_lvl+0xa5/0xb9
 [<c040483a>] show_registers+0xb4/0x1b8
 [<c0404a5e>] die+0x120/0x21b
 [<c063ddfc>] do_page_fault+0x845/0xa07
 [<c063c29a>] error_code+0x6a/0x70
 [<c063a57e>] rt_spin_lock_slowlock+0xc5/0x1b7
 [<c063a9d4>] __rt_spin_lock+0x48/0x4b
 [<c063acbe>] rt_spin_lock+0x94/0xa2
 [<c04f33a4>] cfq_exit_io_context+0x30/0x56
 [<c04ed88f>] exit_io_context+0x68/0x72
 [<c04206c1>] do_exit+0x6c2/0x739
 [<c040432d>] kernel_thread_helper+0xd/0x10
 =======================
INFO: lockdep is turned off.
Code: 24 08 4c 00 00 00 c7 44 24 04 83 42 6e c0 c7 04 24 b6 78 6d c0 e8 c0 0d fe ff e8 f5 80 fc ff 8b 7f 08 8b 4d e8 83 ef 0c 89 7d ec <39> 4f 34 74 04 0f 0b eb fe 8b 7d e8 8b 45 e4 83 c7 20 89 fa e8

<0>EIP: [<c043d18a>] task_blocks_on_rt_mutex+0xf8/0x240 SS:ESP 0068:e7ba7ebc
---[ end trace 432e3e53cc0cfa18 ]---
Fixing recursive fault but reboot is needed!
BUG: scheduling with irqs disabled: pdflush/0x00000002/12634
caller is do_exit+0xcc/0x739
Pid: 12634, comm: pdflush Tainted: GF     D 2.6.24.7-rt27 #9
 [<c04046b8>] show_trace_log_lvl+0x1f/0x34
 [<c0404f67>] show_trace+0x17/0x19
 [<c04052e2>] dump_stack+0x6f/0x75
 [<c0638e41>] schedule+0x8a/0x105
 [<c04200cb>] do_exit+0xcc/0x739
 [<c0404b51>] die+0x213/0x21b
 [<c063ddfc>] do_page_fault+0x845/0xa07
 [<c063c29a>] error_code+0x6a/0x70
 [<c063a57e>] rt_spin_lock_slowlock+0xc5/0x1b7
 [<c063a9d4>] __rt_spin_lock+0x48/0x4b
 [<c063acbe>] rt_spin_lock+0x94/0xa2
 [<c04f33a4>] cfq_exit_io_context+0x30/0x56
 [<c04ed88f>] exit_io_context+0x68/0x72
 [<c04206c1>] do_exit+0x6c2/0x739
 [<c040432d>] kernel_thread_helper+0xd/0x10
 =======================

I am confuse whether my driver is causing this problem or not as in the trace above I cannot find any function of my driver. All the functions are of kernel and pdflush is causing this problem.  In the above trace "Modules linked in: sysfs_driver(F) regularcache(F) dts "     are my modules.
I am using CentOS 5 with 1GB RAM on  "Intel(R) Pentium(R) 4 CPU 2.80GHz".  Please guide me if I am doing any mistake

Thanks!
Furahm

--
This message was sent on behalf of dtslinux@hotmail.com at openSubscriber.com
http://www.opensubscriber.com/messages/linux-kernel@vger.kernel.org/topic.html
