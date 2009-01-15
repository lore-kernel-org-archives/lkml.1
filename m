Return-Path: <linux-kernel-owner+w=401wt.eu-S1761853AbZAOA0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761853AbZAOA0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760088AbZAOA0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:26:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759166AbZAOA0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:26:13 -0500
Date: Wed, 14 Jan 2009 16:26:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: elendil@planet.nl, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [2.6.28] Kernel panic after closing lid on HP 2510p
Message-Id: <20090114162603.c632d82e.akpm@linux-foundation.org>
In-Reply-To: <20090113123056.GA2464@deprecation.cyrius.com>
References: <200901121356.46236.elendil@planet.nl>
	<20090113123056.GA2464@deprecation.cyrius.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-acpi)

On Tue, 13 Jan 2009 13:30:56 +0100
Martin Michlmayr <tbm@cyrius.com> wrote:

> * Frans Pop <elendil@planet.nl> [2009-01-12 13:56]:
> > I got the following series of errors while closing the lid of my notebook.
> > The end result was a frozen system that needed a hard power off.
> ...
> > System is HP 2510p notebook running 2.6.28 (x86_64, Debian amd64/lenny)
> > with a few additional patches on top. 
> 
> This came up on lkml and elsewhere before.  It's probably a BIOS bug.
> You can work around it with:
> 
>   echo 7 > /proc/acpi/video/C09A/DOS
> 

It'd be a very special BIOS bug if it can reach out and make the kernel
oops.


> I got the following series of errors while closing the lid of my notebook.
> The end result was a frozen system that needed a hard power off.
> 
> The notebook was docked and connected to external monitor. Closing the lid
> will only power off both displays, not suspend.
> 
> I possibly tried to do a few things too quickly in succession, but
> AFAIK that should still not result in the kernel crapping out on me ;-)
> 
> System is HP 2510p notebook running 2.6.28 (x86_64, Debian amd64/lenny)
> with a few additional patches on top. 
> 
> Cheers,
> FJP
> 
> Errors in kern.log after rebooting:
> 
> BUG: unable to handle kernel paging request at ffff88007ceeb5a0
> IP: [<ffffffff8034e077>] acpi_ex_field_datum_io+0xec/0x17e
> PGD 202063 PUD 8067 PMD 6ff52163 PTE 800000007ceeb163
> Oops: 0011 [#1] SMP
> last sysfs file: /sys/class/power_supply/C23D/charge_full
> CPU 1
> Modules linked in: iwlagn iwlcore mac80211 cfg80211 isofs zlib_inflate usbhid hid vboxdrv tcp_diag inet_diag i915 
> drm ppdev parport_pc lp parport nfs lockd nfs_acl sunrpc ipv6 ext2 coretemp hp_wmi acpi_cpufreq loop joydev 
> snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy ecb snd_seq_oss snd_seq_midi snd_rawmidi 
> snd_seq_midi_event snd_seq snd_timer rfkill snd_seq_device pcmcia snd soundcore psmouse yenta_socket 
> rsrc_nonstatic iTCO_wdt snd_page_alloc serio_raw pcspkr pcmcia_core intel_agp battery video output wmi 
> leds_hp_disk led_class container ac button evdev ext3 jbd mbcache sha256_generic aes_x86_64 aes_generic cbc 
> dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sg sr_mod cdrom sd_mod piix ata_piix ide_pci_generic 
> ide_core pata_acpi ricoh_mmc sdhci_pci sdhci mmc_core ohci1394 ieee1394 ata_generic ehci_hcd libata uhci_hcd 
> e1000e scsi_mod thermal processor fan thermal_sys [last unloaded: cfg80211]
> Pid: 70, comm: kacpid Not tainted 2.6.28-rjw #83
> RIP: 61a0:[<ffffffff803534ed>]  [<ffffffff803534ed>] acpi_ns_search_one_scope+0x1d/0x46
> RSP: ffffffff8028fbf2:ffff88007e1d7b10  EFLAGS: 00000005
> RAX: ffff88007e046510 RBX: ffff88007ceeb5a0 RCX: ffff88007e1d7b70
> RDX: 0000000000000000 RSI: ffff88007e1d7ae0 RDI: ffffffff8028fbf2
> RBP: ffff88007e1d7b80 R08: 00000003000000b2 R09: ffff88007e1d7b70
> R10: 0000000000000000 R11: ffff88007e1d7c60 R12: ffff88007e1d7b10
> R13: ffffffff8034df7e R14: ffff88007e1d7ad0 R15: ffff88007e046510
> FS:  0000000000000000(0000) GS:ffff88007e002a80(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: ffff88007ceeb5a0 CR3: 0000000063b35000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kacpid (pid: 70, threadinfo ffff88007e1d6000, task ffff88007e1d95f0)
> Stack:
> BUG: unable to handle kernel paging request at 000000007e1d7b00
> IP: [<ffffffff8020f140>] show_stack_log_lvl+0xb0/0x125
> PGD 63b00067 PUD 73867067 PMD 0

If the BIOS is bad then the kernel would ideally report that fact and
then take some sort of avoiding action.  It shouldn't oops!

Frans, please raise a bugzilla against acpi for this if nothing happens
in the next few days, thanks.

