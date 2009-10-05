Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbZJEIzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbZJEIzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758704AbZJEIzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:55:00 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:55297 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758660AbZJEIy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:54:56 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Mon, 5 Oct 2009 10:54:16 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>, linux-mm@kvack.org
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910050714.01908.elendil@planet.nl> <200910050851.02056.elendil@planet.nl>
In-Reply-To: <200910050851.02056.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910051054.18958.elendil@planet.nl>
X-OriginalArrivalTime: 05 Oct 2009 08:54:19.0533 (UTC) FILETIME=[6D0C83D0:01CA4599]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009, Frans Pop wrote:
> With .32 it was obviously impossible to get that info due to the total
> freeze of the desktop. Not sure if the scheduler changes in .32
> contribute to this. Guess I could find out by doing the same test with
> .31.

I've tried with .31.1 too now and there does seem to be a scheduler
component too. With .31.1 I also get the SKB allocation errors, but the
desktop freeze seems to be less severe than with .32-rc3. I would suggest
looking into that _after_ the allocation issue has been traced/solved.

I did manage to really (partially) hang up the desktop with .31.1: music
did not come back and the task manager of the KDE desktop remained frozen,
but I could still use konsole [1].
I suspect this is because I also got an OOPS in between the SKB failures:

IP: [<ffffffffa0444ea2>] rpcauth_checkverf+0x4e/0x5a[sunrpc]
PGD 77b83067 PUD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/class/power_supply/C23D/charge_full
CPU 0
Modules linked in: i915 drm i2c_algo_bit i2c_core ppdev parport_pc lp parport cpufreq_conservative
   cpufreq_userspace cpufreq_stats cpufreq_powersave ipv6 nfsd exportfs nfs lockd nfs_acl auth_rpcgss
   sunrpc ext2 coretemp hp_wmi acpi_cpufreq loop snd_hda_codec_analog snd_hda_intel snd_hda_codec
   arc4 snd_pcm_oss snd_mixer_oss ecb snd_pcm snd_seq_dummy snd_seq_oss iwlagn iwlcore snd_seq_midi
   pcmcia mac80211 snd_rawmidi usblp snd_seq_midi_event snd_seq pcspkr cfg80211 yenta_socket
   rsrc_nonstatic pcmcia_core psmouse snd_timer snd_seq_device rfkill serio_raw snd soundcore
   snd_page_alloc hp_accel lis3lv02d video container output wmi intel_agp input_polldev battery ac
   processor button joydev evdev ext3 jbd mbcache sha256_generic aes_x86_64 aes_generic cbc usbhid hid
   dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sg sr_mod sd_mod cdrom ide_pci_generic piix
   ide_core pata_acpi uhci_hcd ata_piix ohci1394 sdhci_pci sdhci mmc_core led_class ieee1394 ricoh_mmc
   ata_generic ehci_hcd libta e1000e scsi_mod thermal fan thermal_sys [last unloaded: scsi_wait_scan]
Pid: 3226, comm: rpciod/0 Not tainted 2.6.31.1 #20 HP Compaq 2510p Notebook PC
RIP: 0010:[<ffffffffa0444ea2>]  [<ffffffffa0444ea2>]rpcauth_checkverf+0x4e/0x5a [sunrpc]
RSP: 0018:ffff88007aafbda0  EFLAGS: 00010246
RAX: 0000000400001000 RBX: ffff88003a718e40 RCX: 0000000000000001
RDX: ffff880038b821bc RSI: ffff880038b821c8 RDI: ffff8800618358c8
RBP: ffff88007aafbdc0 R08: 0000000000000000 R09: 0000000000000000
R10: ffff880001514d80 R11: ffff8800536401f0 R12: ffff8800618358c8
R13: ffff880038b821c8 R14: ffff880037bb4bd0 R15: ffffffffa04bf52b
FS:  0000000000000000(0000) GS:ffff880001504000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000400001038 CR3: 0000000067ee5000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rpciod/0 (pid: 3226, threadinfo ffff88007aafa000, task ffff88007c431670)
Stack:
 ffff88007aafbde0 ffff880037bb4bd0 ffff8800618358c8 ffff880061835958
<0> ffff88007aafbe00 ffffffffa043e24a ffff88007c4319e0 ffff8800618358c8
<0> ffff880061835970 ffff880061835958 0000000000000000 0000000000000001
Call Trace:
 [<ffffffffa043e24a>] call_decode+0x374/0x68e [sunrpc]
 [<ffffffffa044430e>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa04444f8>] ? rpc_async_schedule+0x0/0x12 [sunrpc]
 [<ffffffffa0444508>] rpc_async_schedule+0x10/0x12 [sunrpc]
 [<ffffffff81048bd5>] worker_thread+0x132/0x1ca
 [<ffffffff8104c657>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff81048aa3>] ? worker_thread+0x0/0x1ca
 [<ffffffff8104c335>] kthread+0x8f/0x97
 [<ffffffff8100ca7a>] child_rip+0xa/0x20
 [<ffffffff8104c2a6>] ? kthread+0x0/0x97
 [<ffffffff8100ca70>] ? child_rip+0x0/0x20
Code: 30 0f b7 b7 06 01 00 00 48 89 d9 48 c7 c7 30 42
 45 a0 48 8b 40 10 48 8b 50 10 31 c0 e8 73 f8 e0 e0 48 8b 43 38 4c 89 ee 4c 89 e7 <ff> 50 38 41 59 5b 41 5c 41 5d c9 c3 55 48 89 e5 41 55 49 89 f5
RIP  [<ffffffffa0444ea2>] rpcauth_checkverf+0x4e/0x5a [sunrpc]
 RSP <ffff88007aafbda0>
CR2: 0000000400001038

Not sure whether it's worth following up on that as a separate issue.

Cheers,
FJP

[1] KDE's task manager freezing for short periods is normal for me while
amarok is blocked by NFS. This normally only happens when I start amarok
for the first time, but it does explain how the NFS oops can have the
same effect.
