Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbZDMJ6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbZDMJ6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 05:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZDMJ55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 05:57:57 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:17078 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754838AbZDMJ54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 05:57:56 -0400
Message-ID: <49E30C98.8050007@panasas.com>
Date: Mon, 13 Apr 2009 12:57:44 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc1 NULL pointer dereference in dup_fd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Apr 2009 09:57:51.0958 (UTC) FILETIME=[4F242760:01C9BC1E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

I'm sending you this report since you seem to be the last one
that touched this code.  I've hit this NULL deref when
developing nfs-utils code and restarting the nfs daemon
while testing my new code.  That said, it happened only once
and I could not reproduce it.  The kernel is the linux-pnfs
kernel based on v2.6.30-rc1.  It can be built from
git://linux-nfs/~bhalevy/linux-pnfs.git
tag pnfs-all-2.6.30-rc1-2009-04-10

Apr 13 09:46:39 tl1 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000032
Apr 13 09:46:39 tl1 kernel: IP: [<ffffffff810da95b>] dup_fd+0x23e/0x2fb
Apr 13 09:46:39 tl1 kernel: PGD 38d86067 PUD 375a0067 PMD 0 
Apr 13 09:46:39 tl1 kernel: Oops: 0002 [#1] SMP 
Apr 13 09:46:39 tl1 kernel: last sysfs file: /sys/devices/platform/i8042/serio1/input/input1/capabilities/sw
Apr 13 09:46:39 tl1 kernel: CPU 0 
Apr 13 09:46:39 tl1 kernel: Modules linked in: nfslayoutdriver nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc ipv6 cpufreq_ondemand powernow_k8 freq_table dm_mirror dm_region_hash dm_log dm_multipath 
dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm sr_mod snd_timer cdrom snd k8temp soundcore hwmon forcedeth snd_page_alloc pata_amd sg i2c_nforce2 i2c_core button sata_nv ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Apr 13 09:46:39 tl1 kernel: Pid: 22338, comm: rpcsvcgssd Not tainted 2.6.30-rc1-pnfs #1 MS-7260
Apr 13 09:46:39 tl1 kernel: RIP: 0010:[<ffffffff810da95b>]  [<ffffffff810da95b>] dup_fd+0x23e/0x2fb
Apr 13 09:46:39 tl1 kernel: RSP: 0018:ffff88003784bd60  EFLAGS: 00010202
Apr 13 09:46:39 tl1 kernel: RAX: 0000000000000032 RBX: ffff8800325ea980 RCX: ffffffffffffefff
Apr 13 09:46:39 tl1 kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000068
Apr 13 09:46:39 tl1 kernel: RBP: ffff88003784bdf0 R08: 000000000000000d R09: 00000000000000f3
Apr 13 09:46:39 tl1 kernel: R10: ffff88003e5a5000 R11: 0000000000000001 R12: 0000000000000100
Apr 13 09:46:39 tl1 kernel: R13: ffff88003263d340 R14: ffff88003e0ae800 R15: 0000000000001000
Apr 13 09:46:39 tl1 kernel: FS:  00007f11e4bcd6f0(0000) GS:ffff88000100a000(0000) knlGS:0000000000000000
Apr 13 09:46:39 tl1 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Apr 13 09:46:39 tl1 kernel: CR2: 0000000000000032 CR3: 000000003742d000 CR4: 00000000000006e0
Apr 13 09:46:39 tl1 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Apr 13 09:46:39 tl1 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr 13 09:46:39 tl1 kernel: Process rpcsvcgssd (pid: 22338, threadinfo ffff88003784a000, task ffff88003743d9c0)
Apr 13 09:46:39 tl1 kernel: Stack:
Apr 13 09:46:39 tl1 kernel: ffff88003784bdb0 0000000000000800 000008003743d9c0 ffffffff81434ab0
Apr 13 09:46:39 tl1 kernel: ffff88003784bdc4 0000000000000002 0000000000000000 0000000001200011
Apr 13 09:46:39 tl1 kernel: ffff88003784bdf0 ffffffff8107c71a ffff88003263d608 ffff88003263d680
Apr 13 09:46:39 tl1 kernel: Call Trace:
Apr 13 09:46:39 tl1 kernel: [<ffffffff8107c71a>] ? audit_alloc+0x9f/0x159
Apr 13 09:46:39 tl1 kernel: [<ffffffff8103ccce>] copy_process+0x58d/0x1245
Apr 13 09:46:39 tl1 kernel: [<ffffffff8103daca>] do_fork+0x144/0x31c
Apr 13 09:46:39 tl1 kernel: [<ffffffff810550eb>] ? up_read+0x9/0xb
Apr 13 09:46:39 tl1 kernel: [<ffffffff812cdfc8>] ? do_page_fault+0x24b/0x273
Apr 13 09:46:39 tl1 kernel: [<ffffffff8100a529>] sys_clone+0x23/0x25
Apr 13 09:46:39 tl1 kernel: [<ffffffff8100bf63>] stub_clone+0x13/0x20
Apr 13 09:46:39 tl1 kernel: [<ffffffff8100bbc2>] ? system_call_fastpath+0x16/0x1b
Apr 13 09:46:39 tl1 kernel: Code: 00 00 00 48 98 48 89 c1 f3 a4 48 89 c1 49 8b 70 10 48 8b 7b 10 45 31 c0 f3 a4 31 ff eb 43 49 8b 34 3a 48 85 f6 74 0b 48 8d 46 30 <3e> 48 ff 46 30 eb 21 49 63 c8 48 8b 43 18 4d 89 df 48 89 ca 83 
Apr 13 09:46:39 tl1 kernel: RIP  [<ffffffff810da95b>] dup_fd+0x23e/0x2fb
Apr 13 09:46:39 tl1 kernel: RSP <ffff88003784bd60>
Apr 13 09:46:39 tl1 kernel: CR2: 0000000000000032
Apr 13 09:46:39 tl1 kernel: ---[ end trace cee59c9a3de49750 ]---

The IP corresponds to the get_file call on line 369
where f (stored in RSI) equals 2.

366	for (i = open_files; i != 0; i--) {
367		struct file *f = *old_fds++;
368		if (f) {
369			get_file(f);
370		} else {
371			/*
372			 * The fd may be claimed in the fd bitmap but not yet

I'm not sure how helpful this report is when I can't
readily reproduce this bug.  Let me know if there's anything else
I can help with to get to the bottom of this bug.

Benny
