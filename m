Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbZA3AbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbZA3AbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbZA3Aa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:30:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755643AbZA3Aaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:30:55 -0500
Date: Thu, 29 Jan 2009 16:30:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kerolasa@gmail.com
Cc: kerolasa@iki.fi, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@linux.ie>,
       Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: PROBLEM: kernel BUG at drivers/gpu/drm/drm_fops.c:146!
Message-Id: <20090129163032.f97901c5.akpm@linux-foundation.org>
In-Reply-To: <a6f8318b0901210427o33af879byd352adaf5fde1c29@mail.gmail.com>
References: <a6f8318b0901210358w7cced8e9yab86c487b3587d75@mail.gmail.com>
	<a6f8318b0901210427o33af879byd352adaf5fde1c29@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Wed, 21 Jan 2009 13:27:48 +0100
Sami Kerola <kerolasa@iki.fi> wrote:

> I compiled the Torvalds git kernel 2.6.29-rc2-00013 and I got an oops.
> The oops happens when ever X starts. Initially I was booting with run
> level 5 and it hung. I tried to use run level to 3 and an operating
> system started just fine. When I type startx the hung happen again.
> Please let me know if you need some more information besides oops from
> messages file and lspci output.
> 
> 
> Jan 21 08:53:58 lelux kernel: ------------[ cut here ]------------
> Jan 21 08:53:58 lelux kernel: kernel BUG at drivers/gpu/drm/drm_fops.c:146!

I assume that 2.6.28 didn't do this?

Seems odd - nothing much has changed around there lately.

> Jan 21 08:53:58 lelux kernel: invalid opcode: 0000 [#1] SMP
> Jan 21 08:53:58 lelux kernel: last sysfs file:
> /sys/devices/pci0000:00/0000:00:02.0/drm/card0/dri_library_name
> Jan 21 08:53:58 lelux kernel: CPU 0
> Jan 21 08:53:58 lelux kernel: Modules linked in: i915 drm i2c_algo_bit
> ipv6 fuse acpi_cpufreq dm_multipath snd_hda_codec_idt arc4 ecb
> snd_hda_intel snd_hda_codec iwlag
> n snd_hwdep snd_seq_dummy snd_seq_oss iwlcore snd_seq_midi_event
> snd_seq rfkill snd_seq_device lib80211 snd_pcm_oss mac80211
> snd_mixer_oss snd_pcm firewire_ohci i2c_i8
> 01 snd_timer firewire_core ppdev snd sr_mod pcspkr joydev yenta_socket
> i2c_core video sg iTCO_wdt tg3 rsrc_nonstatic cdrom crc_itu_t
> iTCO_vendor_support parport_pc out
> put parport libphy soundcore cfg80211 wmi battery snd_page_alloc ac
> pata_acpi ata_generic ata_piix libata sd_mod scsi_mod sha256_generic
> cbc aes_x86_64 aes_generic dm_
> crypt dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ext3
> jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
> Jan 21 08:53:58 lelux kernel: Pid: 2902, comm: X Not tainted
> 2.6.29-rc2-00013-gf3b8436-dirty #1
> Jan 21 08:53:58 lelux kernel: RIP: 0010:[<ffffffffa0486f7b>]
> [<ffffffffa0486f7b>] drm_open+0x4b7/0x4f0 [drm]
> Jan 21 08:53:58 lelux kernel: RSP: 0018:ffff88006ec01cd8  EFLAGS: 00010293
> Jan 21 08:53:58 lelux kernel: RAX: ffff88006f8e2100 RBX:
> ffff88006f47d060 RCX: 0000000000000000
> Jan 21 08:53:58 lelux kernel: RDX: ffff88007a016b90 RSI:
> ffff88006ec40000 RDI: ffff88006ec01c28
> Jan 21 08:53:58 lelux kernel: RBP: ffff88006ec01d18 R08:
> ffff88006ec40760 R09: 00000000000002e7
> Jan 21 08:53:58 lelux kernel: R10: ffff88006ec40000 R11:
> 0000000000000006 R12: 0000000000000000
> Jan 21 08:53:58 lelux kernel: R13: ffff88006f47d000 R14:
> ffff88006f47d060 R15: ffff88006ec33918
> Jan 21 08:53:58 lelux kernel: FS:  00007f4495429780(0000)
> GS:ffffffff8192e000(0000) knlGS:0000000000000000
> Jan 21 08:53:58 lelux kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Jan 21 08:53:58 lelux kernel: CR2: 00007f4494de01a0 CR3:
> 0000000070460000 CR4: 00000000000006e0
> Jan 21 08:53:58 lelux kernel: DR0: 0000000000000000 DR1:
> 0000000000000000 DR2: 0000000000000000
> Jan 21 08:53:58 lelux kernel: DR3: 0000000000000000 DR6:
> 00000000ffff0ff0 DR7: 0000000000000400
> Jan 21 08:53:58 lelux kernel: Process X (pid: 2902, threadinfo
> ffff88006ec00000, task ffff88006ec40000)
> Jan 21 08:53:58 lelux kernel: Stack:
> Jan 21 08:53:58 lelux kernel: ffff88006d071000 ffff88007a016b90
> ffff88006d044000 00000000ffffffed
> Jan 21 08:53:58 lelux kernel: ffffffffa04959d0 ffff88006d071000
> ffff88007a016b90 ffff88007a016b90
> Jan 21 08:53:58 lelux kernel: ffff88006ec01d48 ffffffffa0486a53
> 0000000000000000 ffff88007c9adc00
> Jan 21 08:53:58 lelux kernel: Call Trace:
> Jan 21 08:53:58 lelux kernel: [<ffffffffa0486a53>]
> drm_stub_open+0xd2/0x143 [drm]
> Jan 21 08:53:58 lelux kernel: [<ffffffff810df703>] chrdev_open+0x149/0x168
> Jan 21 08:53:58 lelux kernel: [<ffffffff8114e8b9>] ?
> selinux_dentry_open+0xeb/0xf4
> Jan 21 08:53:58 lelux kernel: [<ffffffff810df5ba>] ? chrdev_open+0x0/0x168
> Jan 21 08:53:58 lelux kernel: [<ffffffff810db03f>] __dentry_open+0x151/0x270
> Jan 21 08:53:58 lelux kernel: [<ffffffff810db235>] nameidata_to_filp+0x46/0x57
> Jan 21 08:53:58 lelux kernel: [<ffffffff810e84fb>] do_filp_open+0x44f/0x8a7
> Jan 21 08:53:58 lelux kernel: [<ffffffff81065661>] ?
> lock_release_holdtime+0x1c/0x173
> Jan 21 08:53:58 lelux kernel: [<ffffffff8118a136>] ? _raw_spin_unlock+0x8e/0x94
> Jan 21 08:53:58 lelux kernel: [<ffffffff810f14c5>] ? alloc_fd+0x122/0x133
> Jan 21 08:53:58 lelux kernel: [<ffffffff810dae22>] do_sys_open+0x58/0xd8
> Jan 21 08:53:58 lelux kernel: [<ffffffff810daed5>] sys_open+0x20/0x22
> Jan 21 08:53:58 lelux kernel: [<ffffffff8100c42a>]
> system_call_fastpath+0x16/0x1b
> Jan 21 08:53:58 lelux kernel: Code: 48 89 df e8 55 e4 ea e0 48 8b 45
> d0 83 78 04 01 75 2f 49 8b 85 00 06 00 00 48 85 c0 74 11 48 8b 55 c8
> 48 3b 82 30 02 00 00 74 16 <0f> 0b eb fe 48 8b 55 c8 48 8b 82 30 02 00
> 00 49 89 85 00 06 00
