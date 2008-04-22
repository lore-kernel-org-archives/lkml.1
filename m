Return-Path: <linux-kernel-owner+w=401wt.eu-S1765037AbYDVNlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765037AbYDVNlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbYDVNkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:40:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48326 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764960AbYDVNkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:40:52 -0400
Date: Tue, 22 Apr 2008 15:40:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Pete Zaitcev <zaitcev@redhat.com>,
       linux-usb@vger.kernel.org, gregkh@suse.de, penberg@cs.helsinki.fi
Subject: Re: [sched-devel/latest] WARNING: at mm/slub.c:2443
Message-ID: <20080422134034.GF7311@elte.hu>
References: <200804212310.41729.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804212310.41729.elendil@planet.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frans Pop <elendil@planet.nl> wrote:

> I got the following warning while running sched-devel/latest.
> 
> I was not doing any tracing at that point (for the glibc compilation 
> issue). I suspect it was while I was using a KDE application (amarok) 
> as the desktop froze for a few seconds at one point.

i think this message is harmless to system stability.

Cc:-ing USB folks as the kmem_cache_destroy() comes from 
drivers/usb/mon/mon_text.c.

Context: SLUB recently started warning about caches that get destroyed 
with still outstanding allocations.

Pekka, it might make sense to turn this SLUB warning into something more 
specific? It does seem to trigger in practice.

> Cheers,
> FJP
> 
> ------------[ cut here ]------------
> WARNING: at mm/slub.c:2443 kmem_cache_destroy+0x168/0x1a9()
> Modules linked in: snd_rtctimer i915 drm tun ppdev lp ac battery nfs lockd 
> nfs_acl sunrpc bridge llc fuse lm85 hwmon_vid cpufreq_ondemand acpi_cpufreq 
> freq_table firewire_sbp2 ipv6 snd_hda_intel snd_pcm_oss snd_mixer_oss 
> snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi 
> snd_seq_midi_event snd_seq snd_timer snd_seq_device psmouse snd parport_pc 
> i2c_i801 button iTCO_wdt parport serio_raw i2c_core intel_agp joydev 
> soundcore evdev pcspkr snd_page_alloc ext3 jbd mbcache dm_mirror 
> dm_snapshot dm_mod ide_cd_mod ata_piix ata_generic sg sr_mod cdrom sd_mod 
> piix usbhid hid floppy ahci libata scsi_mod dock ide_pci_generic ide_core 
> firewire_ohci firewire_core crc_itu_t ehci_hcd uhci_hcd e1000e thermal 
> processor fan
> Pid: 32428, comm: cat Not tainted 2.6.26-rc0-sched-devel.git-x86-latest.git 
> #3
> 
> Call Trace:
>  [<ffffffff80237c7b>] warn_on_slowpath+0x58/0x6b
>  [<ffffffff80273676>] ? get_pageblock_migratetype+0x1b/0x1d
>  [<ffffffff80274291>] ? free_hot_page+0xb/0xd
>  [<ffffffff802742ab>] ? __free_pages+0x18/0x21
>  [<ffffffff80292170>] ? __free_slab+0xdc/0xe9
>  [<ffffffff80293c5d>] kmem_cache_destroy+0x168/0x1a9
>  [<ffffffff803974d8>] mon_text_release+0x89/0xae
>  [<ffffffff80299254>] __fput+0xb9/0x161
>  [<ffffffff8029957b>] fput+0x14/0x16
>  [<ffffffff80296892>] filp_close+0x66/0x71
>  [<ffffffff80239eea>] put_files_struct+0x77/0xcb
>  [<ffffffff80239f72>] __exit_files+0x34/0x39
>  [<ffffffff8023b1ec>] do_exit+0x256/0x683
>  [<ffffffff8023b694>] do_group_exit+0x7b/0x96
>  [<ffffffff8024409f>] get_signal_to_deliver+0x2c4/0x2f1
>  [<ffffffff8020b9bb>] do_notify_resume+0xd0/0x8d5
>  [<ffffffff80232e0d>] ? default_wake_function+0x0/0xf
>  [<ffffffff80397b45>] ? mon_text_read_u+0x2b/0x2b6
>  [<ffffffff802eb576>] ? security_file_permission+0x11/0x13
>  [<ffffffff80298bce>] ? vfs_read+0xa4/0xde
>  [<ffffffff8020c374>] ? sysret_signal+0x1c/0x27
>  [<ffffffff8020c5f7>] ptregscall_common+0x67/0xb0
> 
> ---[ end trace 55672de67f8b5497 ]---
