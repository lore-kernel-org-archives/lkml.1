Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbYFZPGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbYFZPGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYFZPGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:06:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbYFZPGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:06:06 -0400
Date: Thu, 26 Jun 2008 10:59:42 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.25.6  kernel BUG at mm/highmem.c:319!
Message-ID: <20080626145942.GA25295@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone know how this can happen ?
We just got a report from a user who is hitting the 

        BUG_ON(!PageHighMem(page));

in set_page_address().

	Dave

Jun 26 00:59:02 getman kernel: ------------[ cut here ]------------
Jun 26 00:59:02 getman kernel: kernel BUG at mm/highmem.c:319!
Jun 26 00:59:02 getman kernel: invalid opcode: 0000 [#1] SMP
Jun 26 00:59:02 getman kernel: Modules linked in: autofs4 w83627ehf hwmon_vid hwmon nf_conntrack_netbios_ns ipt_REJECT ipt_LOG xt_tcpudp nf_conntrack_ipv4 xt_
state nf_conntrack iptable_filter ip_tables x_tables dm_mirror dm_mod ipv6 snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device s
nd_pcm_oss snd_mixer_oss snd_pcm i915 snd_timer snd_page_alloc snd_hwdep button drm snd iTCO_wdt e1000e soundcore iTCO_vendor_support i2c_i801 i2c_algo_bit sr
_mod pcspkr sg i2c_core floppy cdrom ata_piix ata_generic pata_acpi libata sd_mod scsi_mod raid456 async_xor async_memcpy async_tx xor raid1 ext3 jbd mbcache
uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Jun 26 00:59:02 getman kernel:
Jun 26 00:59:02 getman kernel: Pid: 17557, comm: ps Not tainted (2.6.25.6-55.fc9.i686 #1)
Jun 26 00:59:02 getman kernel: EIP: 0060:[<c046c326>] EFLAGS: 00010293 CPU: 1
Jun 26 00:59:02 getman kernel: EIP is at set_page_address+0x14b/0x152
Jun 26 00:59:02 getman kernel: EAX: 00000001 EBX: c0006004 ECX: c0006004 EDX: 00000000
Jun 26 00:59:02 getman kernel: ESI: 00000004 EDI: c0712200 EBP: e8cc9e8c ESP: e8cc9e70
Jun 26 00:59:02 getman kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jun 26 00:59:02 getman kernel: Process ps (pid: 17557, ti=e8cc9000 task=f3e96000 task.ti=e8cc9000)
Jun 26 00:59:02 getman kernel: Stack: 00000000 c16f6740 c046d7ae bff8dee5 c0006004 00000004 c0712200 e8cc9eb4
Jun 26 00:59:02 getman kernel:        c046c448 f7b3a000 00000000 c16f6740 c046c1bf c0836b88 00000400 e8cc9ec8
Jun 26 00:59:02 getman kernel:        e8cc9f18 e8cc9ee8 c046c4ad c1788ea0 ee292e20 00000001 c0791398 00000010
Jun 26 00:59:02 getman kernel: Call Trace:
Jun 26 00:59:02 getman kernel:  [<c046d7ae>] ? follow_page+0x193/0x1e0
Jun 26 00:59:02 getman kernel:  [<c046c448>] ? flush_all_zero_pkmaps+0x90/0xac
Jun 26 00:59:02 getman kernel:  [<c046c1bf>] ? page_address+0x8f/0xab
Jun 26 00:59:02 getman kernel:  [<c046c4ad>] ? kmap_high+0x49/0x185
Jun 26 00:59:02 getman kernel:  [<c041b2af>] ? kmap+0x53/0x60
Jun 26 00:59:02 getman kernel:  [<c046eea0>] ? access_process_vm+0x89/0x110
Jun 26 00:59:02 getman kernel:  [<c04b2116>] ? proc_pid_cmdline+0x53/0xc6
Jun 26 00:59:02 getman kernel:  [<c04b2ef1>] ? proc_info_read+0x51/0x9d
Jun 26 00:59:02 getman kernel:  [<c04b2ea0>] ? proc_info_read+0x0/0x9d
Jun 26 00:59:02 getman kernel:  [<c048284c>] ? vfs_read+0x87/0x12b
Jun 26 00:59:02 getman kernel:  [<c0480b8f>] ? do_sys_open+0xab/0xb5
Jun 26 00:59:02 getman kernel:  [<c0482989>] ? sys_read+0x3b/0x60
Jun 26 00:59:02 getman kernel:  [<c0405bf2>] ? syscall_call+0x7/0xb
Jun 26 00:59:02 getman kernel:  [<c0620000>] ? agp_amd64_probe+0x2e4/0x3ee
Jun 26 00:59:02 getman kernel:  =======================
Jun 26 00:59:02 getman kernel: Code: b8 10 62 83 c0 eb 17 8d 42 f8 8b 50 08 0f 18 02 90 8d 70 08 3b 75 ec 75 af 8b 55 f0 89 f8 e8 33 ec 1b 00 83 c4 10 5b 5e 5
f 5d c3 <0f> 0b e9 15 ff ff ff 55 89 e5 53 89 c3 b8 80 2e 74 c0 e8 cc eb
Jun 26 00:59:02 getman kernel: EIP: [<c046c326>] set_page_address+0x14b/0x152 SS:ESP 0068:e8cc9e70
Jun 26 00:59:02 getman kernel: ---[ end trace 5da5710ae0fc09c3 ]---


-- 
http://www.codemonkey.org.uk
