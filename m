Return-Path: <linux-kernel-owner+w=401wt.eu-S1762285AbYHEMmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762285AbYHEMmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 08:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762604AbYHEMln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 08:41:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51271 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761501AbYHEMlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 08:41:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Rolland <rol@as2917.net>
Subject: Re: [2.6.27-rc1] Oops in sched_power_savings_store
Date: Tue, 5 Aug 2008 14:44:16 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, rol@witbe.net
References: <20080805115447.5e9d77f0@tux.DEF.witbe.net>
In-Reply-To: <20080805115447.5e9d77f0@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051444.19135.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 5 of August 2008, Paul Rolland wrote:
> Hello,
> 
> I've booted a 2.6.27-rc1 this morning, and I got the following Oops. Previously,
> this machine was running an FC8 -2.6.25.9-40 kernel, without problem.
> 
> Attached is the config used. The machine is a Dell Inspiron 6400.

This problem should be fixed in the current mainline, by commit
f718cd4add5aea9d379faff92f162571e356cc5f
("sched: make scheduler sysfs attributes sysdev class devices").

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f718cd4add5aea9d379faff92f162571e356cc5f

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
> IP: [<ffffffff8102ee19>] sched_power_savings_store+0x13/0x55
> PGD 6811c067 PUD 5842c067 PMD 0 
> Oops: 0000 [1] SMP 
> CPU 0 
> Modules linked in: i915 drm autofs4 coretemp hwmon fuse nf_conntrack_ipv4 ipt_RE
> JECT iptable_filter ip_tables nf_conntrack_ipv6 xt_state nf_conntrack xt_tcpudp 
> ip6t_ipv6header ip6t_REJECT ip6table_filter ip6_tables x_tables cpufreq_ondemand
>  acpi_cpufreq freq_table dm_mirror dm_log dm_multipath dm_mod ipv6 snd_hda_intel
>  snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq arc4 snd_seq_device ecb sn
> d_pcm_oss hso snd_mixer_oss snd_pcm crypto_blkcipher iwl3945 snd_timer snd_page_
> alloc mac80211 rfkill snd_hwdep iTCO_wdt sr_mod i2c_i801 b44 i2c_core firewire_o
> hci video button ssb usb_storage iTCO_vendor_support firewire_core crc_itu_t wmi
>  snd cfg80211 mii output battery ac cdrom sg joydev dcdbas soundcore ata_generic
>  ata_piix pata_acpi libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd eh
> ci_hcd [last unloaded: pcspkr]
> Pid: 3179, comm: sched-powersave Not tainted 2.6.27-rc1 #1
> RIP: 0010:[<ffffffff8102ee19>]  [<ffffffff8102ee19>] sched_power_savings_store+0
> x13/0x55
> RSP: 0018:ffff880058473e88  EFLAGS: 00010296
> RAX: fffffffffffffffb RBX: 0000000000000002 RCX: 0000000000000002
> RDX: 0000000000000000 RSI: ffffffffffffffea RDI: 0000000000000002
> RBP: ffff880058473e98 R08: ffffffff8102ee71 R09: ffff88006814e000
> R10: 0000000000000000 R11: 0000000000000001 R12: ffff880065093a80
> R13: ffff88007f321730 R14: 00000000ffffffed R15: ffffffff81402a28
> FS:  00007f4cddfe66f0(0000) GS:ffffffff81433a00(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000002 CR3: 0000000058421000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process sched-powersave (pid: 3179, threadinfo ffff880058472000, task ffff880058
> 449640)
> Stack:  ffff88005a6a7540 ffffffff814023f0 ffff880058473ea8 ffffffff8102ee82
>  ffff880058473eb8 ffffffff811aeabf ffff880058473f08 ffffffff810edd56
>  ffff880058473f48 ffff880065093aa0 ffffffff814023f0 ffff88005a6a7540
> Call Trace:
>  [<ffffffff8102ee82>] sched_mc_power_savings_store+0x11/0x13
>  [<ffffffff811aeabf>] sysdev_class_store+0x24/0x26
>  [<ffffffff810edd56>] sysfs_write_file+0xe0/0x11c
>  [<ffffffff810a49c8>] vfs_write+0xae/0x157
>  [<ffffffff810a4ed6>] sys_write+0x47/0x6f
>  [<ffffffff8100befb>] system_call_fastpath+0x16/0x1b
> 
> 
> Code: c3 55 48 89 e5 e8 bf 7b 00 00 e8 f8 53 03 00 e8 01 7c 00 00 c9 31 c0 c3 55
>  48 89 e5 53 48 89 f3 48 c7 c6 ea ff ff ff 48 83 ec 08 <8a> 0f 8d 41 d0 3c 01 77
>  31 85 d2 74 10 31 c0 80 f9 31 0f 94 c0 
> RIP  [<ffffffff8102ee19>] sched_power_savings_store+0x13/0x55
>  RSP <ffff880058473e88>
> CR2: 0000000000000002
> ---[ end trace 31382a2ba39cd029 ]---
