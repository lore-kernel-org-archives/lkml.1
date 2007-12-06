Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbXLFXZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbXLFXZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXLFXZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:25:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40829 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882AbXLFXZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:25:43 -0500
Date: Thu, 6 Dec 2007 15:25:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, trond.myklebust@fys.uio.no,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: BUG fs/dcache.c:595 in 2.4.24rc3-git3 during NFS umount
Message-Id: <20071206152511.9310ca95.akpm@linux-foundation.org>
In-Reply-To: <200712031623.58223.ak@suse.de>
References: <200712031623.58223.ak@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 16:23:58 +0100
Andi Kleen <ak@suse.de> wrote:

> 
> FYI
> 
> Just saw this on a test system of mine running 2.4.24rc3 (+ some suse patches,
> but they're not changing anything near this AFAIK)
> 
> -Andi
> 
> [101109.104881] ------------[ cut here ]------------
> [101109.114487] kernel BUG at fs/dcache.c:595!
> [101109.123053] invalid opcode: 0000 [1] SMP 
> [101109.131492] last sysfs file: /devices/system/cpu/cpu7/cache/index2/shared_cpu_map
> [101109.147023] CPU 0 
> [101109.151458] Modules linked in: nfs lockd nfs_acl sunrpc autofs4 iptable_filter ip_tables ip6table_filter ip6_tables x_tables af_packet ipv6 cpufreq_conserv
> ative cpufreq_userspace cpufreq_powersave acpi_cpufreq dm_crypt ext2 ext3 jbd mbcache loop dm_mod iTCO_wdt e1000 container button rtc_cmos rtc_core i2c_i801 sh
> pchp iTCO_vendor_support i2c_core rtc_lib sr_mod pci_hotplug cdrom sg floppy ehci_hcd uhci_hcd sd_mod usbcore edd reiserfs fan aic79xx scsi_transport_spi ata_p
> iix ahci libata scsi_mod thermal processor
> [101109.245056] Pid: 8365, comm: umount.nfs Tainted: G       N 2.6.24-rc3-git3-2-default #1
> [101109.261620] RIP: 0010:[<ffffffff802a63b2>]  [<ffffffff802a63b2>] shrink_dcache_for_umount_subtree+0x16/0x241
> [101109.281862] RSP: 0018:ffff81019294be18  EFLAGS: 00010202
> [101109.299219] RAX: 0000000000000000 RBX: ffff81009500ad80 RCX: 0000000000000000
> [101109.314048] RDX: 00000000ffffffff RSI: 0000000000000296 RDI: ffff81009500ad80
> [101109.328868] RBP: ffff81003679a970 R08: ffff81007311f510 R09: 0000000000000296
> [101109.343687] R10: ffff81007311f510 R11: 0000000000000400 R12: ffff810225719c00
> [101109.358507] R13: 0000000000000000 R14: 00007f3173a7d3f0 R15: 0000000000000000
> [101109.373332] FS:  00007f31729c56f0(0000) GS:ffffffff8051b000(0000) knlGS:0000000000000000
> [101109.390081] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [101109.401934] CR2: 0000000040d4bebc CR3: 00000001e61e7000 CR4: 00000000000006e0
> [101109.416761] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [101109.431600] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [101109.446432] Process umount.nfs (pid: 8365, threadinfo ffff81019294a000, task ffff8102250f87e0)
> [101109.464203] Stack:  0000000000000296 ffff810225719c00 ffffffff883e9be0 ffff810225719c00
> [101109.480929]  0000000000000000 ffffffff802a660c ffff810225719c00 ffffffff80297d34
> [101109.496407]  ffff81007311f480 0000000000000017 ffffffff88401e90 ffffffff80297e33
> [101109.511304] Call Trace:
> [101109.517158]  [<ffffffff802a660c>] shrink_dcache_for_umount+0x2f/0x3d
> [101109.530218]  [<ffffffff80297d34>] generic_shutdown_super+0x19/0xf1
> [101109.542941]  [<ffffffff80297e33>] kill_anon_super+0x9/0x35
> [101109.554281]  [<ffffffff883cd1ba>] :nfs:nfs_kill_super+0xd/0x16
> [101109.566301]  [<ffffffff80297ee4>] deactivate_super+0x6a/0x83
> [101109.577988]  [<ffffffff802ab78f>] sys_umount+0x23c/0x24d
> [101109.588979]  [<ffffffff802a5b6e>] d_kill+0x40/0x55
> [101109.598919]  [<ffffffff802a70fb>] dput+0x26/0x115
> [101109.608684]  [<ffffffff80296fc0>] __fput+0x14a/0x179
> [101109.618987]  [<ffffffff802aaab5>] mntput_no_expire+0x1f/0x86
> [101109.630671]  [<ffffffff802945ea>] filp_close+0x5a/0x61
> [101109.641307]  [<ffffffff8020bfde>] system_call+0x7e/0x83
> [101109.652126] 
> [101109.655477] 
> [101109.655478] Code: 0f 0b eb fe 48 c7 c7 80 f6 62 80 e8 eb 70 17 00 48 8b 53 40 
> [101109.674552] RIP  [<ffffffff802a63b2>] shrink_dcache_for_umount_subtree+0x16/0x241
> [101109.690110]  RSP <ffff81019294be18>
> 

wth?  sb->s_root->d_parent != sb->s_root.

Is it repeatable?
