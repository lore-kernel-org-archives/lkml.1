Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab0BNSLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 13:11:35 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:58278 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab0BNSLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 13:11:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xZpT/bLCOWnZvP8ltJ46/LQspKp5Wkz8VpQTOpRiSfm4+j+1D7HN/Ru8ZW4sXddmde
         MOpfl/ElamEfKpSpvSDJYqHPKwJ27aA6pHNUOIvCEIIym0h/QesSBuWhmu6AaXs6cMfz
         zh56s63PuVAzM0pBs2g7DQkXSZqkuA1eVds5Q=
Message-ID: <4B783CD2.1040209@gmail.com>
Date: Sun, 14 Feb 2010 12:11:30 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: Linux kernel list <linux-kernel@vger.kernel.org>,
       nikola.ciprich@linuxbox.cz
Subject: Re: reading /proc/ioports causes OOPS
References: <20100214174513.GA4466@nik-comp.linuxbox.cz>
In-Reply-To: <20100214174513.GA4466@nik-comp.linuxbox.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2010 11:45 AM, Nikola Ciprich wrote:
> Hello,
> on one of our servers, trying to read /proc/ioports
> causes OOPS/BUG and application which is trying to access
> the file is killed. I'm seeing this using recent 2.6.32 kernels,
> not sure how about older/newer ones - it's production machine, so
> my testing possibilities are somehow limited...
> But I can plan some tests/reboots/whatever should it be needed.
> I can't reproduce it on any other machine, so my guess is it
> might be related to some hardware contained...
> The problem doesn't really worry me that much, but it certainly
> would be nice to fix the bug. I'll gladly provide any help I can,
> if somebody would like to have a look at it.
> Thanks a lot in advance
> nik
>
> here's the backtrace:
>
> [339712.773057] BUG: unable to handle kernel paging request at ffffffffa0127b75
> [339712.775660] IP: [<ffffffff811c19ee>] strnlen+0xe/0x40
> [339712.775660] PGD 1003067 PUD 1007063 PMD 41fa73067 PTE 0
> [339712.775660] Oops: 0000 [#11] PREEMPT SMP
> [339712.775660] last sysfs file: /sys/module/drbd/parameters/cn_idx
> [339712.775660] CPU 6
> [339712.775660] Modules linked in: tun bitrev ocfs2 jbd2 ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager drbd crc32 cn ocfs2_stackglue dlm configfs ipmi_si ipmi_devintf ipmi_msghandler ipt_REJECT xt_multiport xt_comment xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables netconsole nfs lockd nfs_acl auth_rpcgss sunrpc 8021q bridge stp llc bonding ipv6 dm_mirror dm_region_hash dm_log dm_mod video backlight output sbs sbshc fan battery ac kvm_intel kvm piix pata_acpi ide_pci_generic ide_core ppdev parport_pc joydev ata_piix parport rng_core i2c_i801 i2c_core usbhid pcspkr iTCO_wdt ata_generic container i5k_amb hwmon i5000_edac edac_core shpchp sg pci_hotplug ioatdma e1000e dca thermal thermal_sys button aic94xx libsas scsi_transport_sas
>    ahci libata sd_mod scsi_mod crc_t10dif raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: freq_table]
> [339712.865216] Pid: 19335, comm: cat Tainted: G      D    2.6.32lb.07 #1 X7DB8
> [339712.865216] RIP: 0010:[<ffffffff811c19ee>]  [<ffffffff811c19ee>] strnlen+0xe/0x40
> [339712.911762] RSP: 0018:ffff880011313c38  EFLAGS: 00010297
> [339712.917882] RAX: ffffffff8147e4c9 RBX: 0000000000000000 RCX: 0000000000000000
> [339712.925284] RDX: fffffffffffffffe RSI: ffffffffffffffff RDI: ffffffffa0127b75
> [339712.932514] RBP: ffff880011313c38 R08: 0000000000000004 R09: 0000000000000020
> [339712.940522] R10: 0000000000000010 R11: 0000000000000004 R12: ffffffffa0127b75
> [339712.949011] R13: ffff88041b2fc302 R14: ffff88041b2fd000 R15: 00000000ffffffff
> [339712.956511] FS:  00007f08fb2af6e0(0000) GS:ffff880028380000(0000) knlGS:0000000000000000
> [339712.965408] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [339712.971820] CR2: ffffffffa0127b75 CR3: 000000029e47f000 CR4: 00000000000026e0
> [339712.979619] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [339712.987189] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [339712.995131] Process cat (pid: 19335, threadinfo ffff880011312000, task ffff88041ad22720)
> [339713.003480] Stack:
> [339713.005007]  ffff880011313c78 ffffffff811c381f 00000000000000c0 ffffffff81462361
> [339713.014176]<0>  0000000000000002 ffff88041b2fc302 ffff880011313d28 ffff88041b2fd000
> [339713.022471]<0>  ffff880011313d18 ffffffff811c4552 0000000000000004 0000000affffffff
> [339713.031420] Call Trace:
> [339713.033793]  [<ffffffff811c381f>] string+0x3f/0xd0
> [339713.039516]  [<ffffffff811c4552>] vsnprintf+0x242/0x580
> [339713.045010]  [<ffffffff811328ce>] seq_printf+0x7e/0xc0
> [339713.051123]  [<ffffffff8105818e>] ? r_start+0x2e/0x70
> [339713.056559]  [<ffffffff813440d1>] ? _read_lock+0x41/0x50
> [339713.061799]  [<ffffffff8105818e>] ? r_start+0x2e/0x70
> [339713.068159]  [<ffffffff81058077>] r_show+0x77/0x80
> [339713.073411]  [<ffffffff81132ea0>] ? seq_read+0x0/0x3c0
> [339713.077678]  [<ffffffff8113310b>] seq_read+0x26b/0x3c0
> [339713.084514]  [<ffffffff81132ea0>] ? seq_read+0x0/0x3c0
> [339713.089988]  [<ffffffff8116ba8a>] proc_reg_read+0x7a/0xb0
> [339713.096139]  [<ffffffff81115f44>] vfs_read+0xc4/0x190
> [339713.101251]  [<ffffffff81116420>] sys_read+0x50/0x90
> [339713.106250]  [<ffffffff8100b2eb>] system_call_fastpath+0x16/0x1b
> [339713.112511] Code: 4c 01 e0 38 10 74 0b 48 83 e8 01 49 39 c4 76 f3 31 c0 5b 41 5c c9 c3 66 0f 1f 44 00 00 48 8d 56 ff 55 48 83 fa ff 48 89 e5 74 27<80>  3f 00 74 22 48 89 f8 eb 0a 80 38 00 0f 1f 44 00 00 74 0e 48
> [339713.137012] RIP  [<ffffffff811c19ee>] strnlen+0xe/0x40
> [339713.142628]  RSP<ffff880011313c38>
> [339713.146871] CR2: ffffffffa0127b75
> [339713.150889] ---[ end trace 52fad5e07083cdb4 ]---
> [339713.154872] note: cat[19335] exited with preempt_count 1
> [339713.162238] BUG: scheduling while atomic: cat/19335/0x10000002
> [339713.168842] INFO: lockdep is turned off.
> [339713.173278] Modules linked in: ...
> [339713.264599] Pid: 19335, comm: cat Tainted: G      D    2.6.32lb.07 #1
> [339713.271579] Call Trace:
> [339713.274364]  [<ffffffff8107e875>] ? __debug_show_held_locks+0x25/0x30
> [339713.281325]  [<ffffffff81041225>] __schedule_bug+0x65/0x70
> [339713.287316]  [<ffffffff81340f95>] thread_return+0x6e8/0x823
> [339713.293399]  [<ffffffff81043a93>] __cond_resched+0x13/0x30
> [339713.299403]  [<ffffffff81341148>] _cond_resched+0x28/0x30
> [339713.305316]  [<ffffffff810ee76b>] unmap_vmas+0x93b/0x9d0
> [339713.311048]  [<ffffffff810f369e>] exit_mmap+0xde/0x190
> [339713.316663]  [<ffffffff8104d544>] mmput+0x54/0x110
> [339713.321950]  [<ffffffff810525f2>] exit_mm+0x102/0x130
> [339713.327427]  [<ffffffff81053d3d>] do_exit+0x18d/0x7d0
> [339713.332959]  [<ffffffff8100f917>] oops_end+0xa7/0xb0
> [339713.338417]  [<ffffffff8102dd3a>] no_context+0x15a/0x250
> [339713.344180]  [<ffffffff8102dfcb>] __bad_area_nosemaphore+0xdb/0x1c0
> [339713.350933]  [<ffffffff8102e14e>] bad_area_nosemaphore+0xe/0x10
> [339713.357352]  [<ffffffff8102e471>] do_page_fault+0xb1/0x2e0
> [339713.363307]  [<ffffffff813444ef>] page_fault+0x1f/0x30
> [339713.368957]  [<ffffffff811c19ee>] ? strnlen+0xe/0x40
> [339713.374504]  [<ffffffff811c381f>] string+0x3f/0xd0
> [339713.379777]  [<ffffffff811c4552>] vsnprintf+0x242/0x580
> [339713.385527]  [<ffffffff811328ce>] seq_printf+0x7e/0xc0
> [339713.391146]  [<ffffffff8105818e>] ? r_start+0x2e/0x70
> [339713.396689]  [<ffffffff813440d1>] ? _read_lock+0x41/0x50
> [339713.402514]  [<ffffffff8105818e>] ? r_start+0x2e/0x70
> [339713.408053]  [<ffffffff81058077>] r_show+0x77/0x80
> [339713.413306]  [<ffffffff81132ea0>] ? seq_read+0x0/0x3c0
> [339713.418871]  [<ffffffff8113310b>] seq_read+0x26b/0x3c0
> [339713.424474]  [<ffffffff81132ea0>] ? seq_read+0x0/0x3c0
> [339713.430102]  [<ffffffff8116ba8a>] proc_reg_read+0x7a/0xb0
> [339713.435986]  [<ffffffff81115f44>] vfs_read+0xc4/0x190
> [339713.443127]  [<ffffffff81116420>] sys_read+0x50/0x90
> [339713.448527]  [<ffffffff8100b2eb>] system_call_fastpath+0x16/0x1b

My guess is that some module got unloaded and didn't unregister its 
ioport reservation, causing a segfault when the kernel tries to read the 
description string. Can you post the full dmesg output from bootup up to 
this point?
