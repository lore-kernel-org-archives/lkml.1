Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZAILbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZAILbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 06:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZAILbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 06:31:34 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:50423 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZAILbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 06:31:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=F28s+m7qMUT6/GDLYD62sEo5Uwtd67pOfWdzAZ+3yc1KhdtzndnHeo5TZIU3ArllpT
         DPpQ/AczLw1RvwYReH8DZYVsSv2AsVNBXQx/i3U3p4jc9L41qucS+vtczEBRv+DRaO1j
         d9c3+Khl+XLltXVgIk6B77+GtaDJeUwtGZRn8=
Message-ID: <c4e36d110901090331r7c1cf06cy25c4a3a3579e47de@mail.gmail.com>
Date: Fri, 9 Jan 2009 12:31:29 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: [PATCH] libata: use WARN_ON_ONCE on hot paths
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeff Garzik" <jgarzik@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
In-Reply-To: <496724A2.5030400@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com>
	 <20090108221753.78648cd6@daedalus.pq.iki.fi>
	 <20090108125317.648397d2@infradead.org> <49667C36.4080300@gmail.com>
	 <20090108143127.437c15de@infradead.org> <4966974B.3090700@gmail.com>
	 <49672166.4050606@gmail.com> <496724A2.5030400@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/9 Tejun Heo <tj@kernel.org>:
> Convert WARN_ON() on command issue/completion paths to WARN_ON_ONCE()
> so that libata doesn't spam the machine even when one of those
> conditions triggers repeatedly.
>


Hi

I've not yet applied this patch - but now I'm getting these WARNS on my T61:
(commit: 2150edc6c5cf00f7adb54538b9ea2a3e9cedca3f)

Is this patch solving the problem or just hiding warnings ?

--

Driver 'sr' needs updating - please use bus_type methods
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: sr_mod(+) cdrom soundcore i2c_core
iTCO_vendor_support usbhid hid lib80211 sdhci_pci sdhci mmc_core
led_class psmouse cfg80211 snd_page_alloc battery ac e1000e serio_raw
intel_agp uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
scsi_wait_scan]
Pid: 1198, comm: udevd Not tainted 2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff8026fd19>] ? __lock_acquire+0x5e9/0x1db0
 [<ffffffff8044a2d0>] ? scsi_times_out+0x70/0x90
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 6cbd13f9b20a7686 ]---
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: sr_mod(+) cdrom soundcore i2c_core
iTCO_vendor_support usbhid hid lib80211 sdhci_pci sdhci mmc_core
led_class psmouse cfg80211 snd_page_alloc battery ac e1000e serio_raw
intel_agp uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff8026fd19>] ? __lock_acquire+0x5e9/0x1db0
 [<ffffffff8026c31d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff80227298>] ? flat_send_IPI_mask+0x88/0xa0
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 [<ffffffff8024b409>] ? __do_softirq+0x69/0x180
 [<ffffffff8024b40c>] ? __do_softirq+0x6c/0x180
 [<ffffffff8024b409>] ? __do_softirq+0x69/0x180
 [<ffffffff8020d6fc>] ? call_softirq+0x1c/0x50
 [<ffffffff8020e9a5>] ? do_softirq+0x75/0xc0
 [<ffffffff8024af45>] ? irq_exit+0x85/0xb0
 [<ffffffff80221c38>] ? smp_apic_timer_interrupt+0x88/0xc0
 [<ffffffff8020d133>] ? apic_timer_interrupt+0x13/0x20
 <EOI> <4>---[ end trace 6cbd13f9b20a7687 ]---
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: sr_mod(+) cdrom soundcore i2c_core
iTCO_vendor_support usbhid hid lib80211 sdhci_pci sdhci mmc_core
led_class psmouse cfg80211 snd_page_alloc battery ac e1000e serio_raw
intel_agp uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff80470af8>] ? ata_sff_hsm_move+0x4d8/0x770
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 6cbd13f9b20a7688 ]---
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
PM: Adding info for No Bus:sr0
PM: Adding info for No Bus:11:0
sr 3:0:0:0: Attached scsi CD-ROM sr0
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: sr_mod cdrom soundcore i2c_core iTCO_vendor_support
usbhid hid lib80211 sdhci_pci sdhci mmc_core led_class psmouse
cfg80211 snd_page_alloc battery ac e1000e serio_raw intel_agp uhci_hcd
ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff8026c31d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8053e3b7>] ? _spin_unlock_irqrestore+0x57/0x70
 [<ffffffff8044a220>] ? scsi_eh_scmd_add+0xa0/0xe0
 [<ffffffff8044a2d0>] ? scsi_times_out+0x70/0x90
 [<ffffffff80395726>] ? blk_rq_timed_out+0x16/0x70
 [<ffffffff803957c7>] ? blk_abort_request+0x47/0x50
 [<ffffffff8046dacb>] ? ata_qc_schedule_eh+0x4b/0x70
 [<ffffffff80460f99>] ? ata_qc_complete+0x1f9/0x230
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 6cbd13f9b20a7689 ]---
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: sr_mod cdrom soundcore i2c_core iTCO_vendor_support
usbhid hid lib80211 sdhci_pci sdhci mmc_core led_class psmouse
cfg80211 snd_page_alloc battery ac e1000e serio_raw intel_agp uhci_hcd
ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff8026c31d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff80236fea>] ? complete+0x4a/0x60
 [<ffffffff8045f93d>] ? __ata_qc_complete+0x7d/0xf0
 [<ffffffff80460e5d>] ? ata_qc_complete+0xbd/0x230
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 6cbd13f9b20a768a ]---
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: sr_mod cdrom soundcore i2c_core iTCO_vendor_support
usbhid hid lib80211 sdhci_pci sdhci mmc_core led_class psmouse
cfg80211 snd_page_alloc battery ac e1000e serio_raw intel_agp uhci_hcd
ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff8024075b>] ? scheduler_tick+0x4b/0x230
 [<ffffffff802604b2>] ? hrtimer_get_next_event+0x42/0xf0
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 6cbd13f9b20a768b ]---
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.04
PM: Adding info for platform:iTCO_wdt
iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
PM: Adding info for No Bus:watchdog
... cut ...
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp llc bluetooth autofs4 sunrpc ipv6 binfmt_misc dm_snapshot
dm_mirror dm_region_hash dm_log dm_mod rtc_cmos rtc_core rtc_lib
kvm_intel kvm i915 drm i2c_algo_bit uinput arc4 ecb
snd_hda_codec_analog cryptomgr snd_hda_intel aead snd_hda_codec
snd_seq_oss crypto_blkcipher crypto_hash snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm crypto_algapi iwl3945
mac80211 snd_timer button thinkpad_acpi rfkill backlight nvram evdev
i2c_i801 snd iTCO_wdt sr_mod cdrom soundcore i2c_core
iTCO_vendor_support usbhid hid lib80211 sdhci_pci sdhci mmc_core
led_class psmouse cfg80211 snd_page_alloc battery ac e1000e serio_raw
intel_agp uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
Pid: 2519, comm: hald Tainted: G        W  2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff8026c31d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8053e3b7>] ? _spin_unlock_irqrestore+0x57/0x70
 [<ffffffff8023c5ef>] ? try_to_wake_up+0x13f/0x2f0
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 6cbd13f9b20a768c ]---
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp llc bluetooth autofs4 sunrpc ipv6 binfmt_misc dm_snapshot
dm_mirror dm_region_hash dm_log dm_mod rtc_cmos rtc_core rtc_lib
kvm_intel kvm i915 drm i2c_algo_bit uinput arc4 ecb
snd_hda_codec_analog cryptomgr snd_hda_intel aead snd_hda_codec
snd_seq_oss crypto_blkcipher crypto_hash snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm crypto_algapi iwl3945
mac80211 snd_timer button thinkpad_acpi rfkill backlight nvram evdev
i2c_i801 snd iTCO_wdt sr_mod cdrom soundcore i2c_core
iTCO_vendor_support usbhid hid lib80211 sdhci_pci sdhci mmc_core
led_class psmouse cfg80211 snd_page_alloc battery ac e1000e serio_raw
intel_agp uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff80390bba>] ? blk_run_queue+0x3a/0x50
 [<ffffffff8044a852>] ? scsi_run_queue+0xe2/0x3f0
 [<ffffffff80438702>] ? put_device+0x12/0x20
 [<ffffffff804450a1>] ? __scsi_put_command+0x61/0xa0
 [<ffffffff803a1757>] ? kobject_put+0x27/0x60
 [<ffffffff80438702>] ? put_device+0x12/0x20
 [<ffffffff8044bb15>] ? scsi_next_command+0x45/0x60
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 6cbd13f9b20a768d ]---
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp llc bluetooth autofs4 sunrpc ipv6 binfmt_misc dm_snapshot
dm_mirror dm_region_hash dm_log dm_mod rtc_cmos rtc_core rtc_lib
kvm_intel kvm i915 drm i2c_algo_bit uinput arc4 ecb
snd_hda_codec_analog cryptomgr snd_hda_intel aead snd_hda_codec
snd_seq_oss crypto_blkcipher crypto_hash snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm crypto_algapi iwl3945
mac80211 snd_timer button thinkpad_acpi rfkill backlight nvram evdev
i2c_i801 snd iTCO_wdt sr_mod cdrom soundcore i2c_core
iTCO_vendor_support usbhid hid lib80211 sdhci_pci sdhci mmc_core
led_class psmouse cfg80211 snd_page_alloc battery ac e1000e serio_raw
intel_agp uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
Pid: 2729, comm: hal-acl-tool Tainted: G        W  2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff8026c31d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8053e3b7>] ? _spin_unlock_irqrestore+0x57/0x70
 [<ffffffff8044a220>] ? scsi_eh_scmd_add+0xa0/0xe0
 [<ffffffff8044a2d0>] ? scsi_times_out+0x70/0x90
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 6cbd13f9b20a768e ]---
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp llc bluetooth autofs4 sunrpc ipv6 binfmt_misc dm_snapshot
dm_mirror dm_region_hash dm_log dm_mod rtc_cmos rtc_core rtc_lib
kvm_intel kvm i915 drm i2c_algo_bit uinput arc4 ecb
snd_hda_codec_analog cryptomgr snd_hda_intel aead snd_hda_codec
snd_seq_oss crypto_blkcipher crypto_hash snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm crypto_algapi iwl3945
mac80211 snd_timer button thinkpad_acpi rfkill backlight nvram evdev
i2c_i801 snd iTCO_wdt sr_mod cdrom soundcore i2c_core
iTCO_vendor_support usbhid hid lib80211 sdhci_pci sdhci mmc_core
led_class psmouse cfg80211 snd_page_alloc battery ac e1000e serio_raw
intel_agp uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff8024075b>] ? scheduler_tick+0x4b/0x230
 [<ffffffff802604b2>] ? hrtimer_get_next_event+0x42/0xf0
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 6cbd13f9b20a768f ]---
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp llc bluetooth autofs4 sunrpc ipv6 binfmt_misc dm_snapshot
dm_mirror dm_region_hash dm_log dm_mod rtc_cmos rtc_core rtc_lib
kvm_intel kvm i915 drm i2c_algo_bit uinput arc4 ecb
snd_hda_codec_analog cryptomgr snd_hda_intel aead snd_hda_codec
snd_seq_oss crypto_blkcipher crypto_hash snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm crypto_algapi iwl3945
mac80211 snd_timer button thinkpad_acpi rfkill backlight nvram evdev
i2c_i801 snd iTCO_wdt sr_mod cdrom soundcore i2c_core
iTCO_vendor_support usbhid hid lib80211 sdhci_pci sdhci mmc_core
led_class psmouse cfg80211 snd_page_alloc battery ac e1000e serio_raw
intel_agp uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff80390bba>] ? blk_run_queue+0x3a/0x50
 [<ffffffff8044a852>] ? scsi_run_queue+0xe2/0x3f0
 [<ffffffff80438702>] ? put_device+0x12/0x20
 [<ffffffff804450a1>] ? __scsi_put_command+0x61/0xa0
 [<ffffffff803a1757>] ? kobject_put+0x27/0x60
 [<ffffffff80438702>] ? put_device+0x12/0x20
 [<ffffffff8044bb15>] ? scsi_next_command+0x45/0x60
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 6cbd13f9b20a7690 ]---
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp llc bluetooth autofs4 sunrpc ipv6 binfmt_misc dm_snapshot
dm_mirror dm_region_hash dm_log dm_mod rtc_cmos rtc_core rtc_lib
kvm_intel kvm i915 drm i2c_algo_bit uinput arc4 ecb
snd_hda_codec_analog cryptomgr snd_hda_intel aead snd_hda_codec
snd_seq_oss crypto_blkcipher crypto_hash snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm crypto_algapi iwl3945
mac80211 snd_timer button thinkpad_acpi rfkill backlight nvram evdev
i2c_i801 snd iTCO_wdt sr_mod cdrom soundcore i2c_core
iTCO_vendor_support usbhid hid lib80211 sdhci_pci sdhci mmc_core
led_class psmouse cfg80211 snd_page_alloc battery ac e1000e serio_raw
intel_agp uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff8024075b>] ? scheduler_tick+0x4b/0x230
 [<ffffffff802604b2>] ? hrtimer_get_next_event+0x42/0xf0
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 6cbd13f9b20a7691 ]---
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp llc bluetooth autofs4 sunrpc ipv6 binfmt_misc dm_snapshot
dm_mirror dm_region_hash dm_log dm_mod rtc_cmos rtc_core rtc_lib
kvm_intel kvm i915 drm i2c_algo_bit uinput arc4 ecb
snd_hda_codec_analog cryptomgr snd_hda_intel aead snd_hda_codec
snd_seq_oss crypto_blkcipher crypto_hash snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm crypto_algapi iwl3945
mac80211 snd_timer button thinkpad_acpi rfkill backlight nvram evdev
i2c_i801 snd iTCO_wdt sr_mod cdrom soundcore i2c_core
iTCO_vendor_support usbhid hid lib80211 sdhci_pci sdhci mmc_core
led_class psmouse cfg80211 snd_page_alloc battery ac e1000e serio_raw
intel_agp uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff8024075b>] ? scheduler_tick+0x4b/0x230
 [<ffffffff802604b2>] ? hrtimer_get_next_event+0x42/0xf0
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 6cbd13f9b20a7692 ]---
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp llc bluetooth autofs4 sunrpc ipv6 binfmt_misc dm_snapshot
dm_mirror dm_region_hash dm_log dm_mod rtc_cmos rtc_core rtc_lib
kvm_intel kvm i915 drm i2c_algo_bit uinput arc4 ecb
snd_hda_codec_analog cryptomgr snd_hda_intel aead snd_hda_codec
snd_seq_oss crypto_blkcipher crypto_hash snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm crypto_algapi iwl3945
mac80211 snd_timer button thinkpad_acpi rfkill backlight nvram evdev
i2c_i801 snd iTCO_wdt sr_mod cdrom soundcore i2c_core
iTCO_vendor_support usbhid hid lib80211 sdhci_pci sdhci mmc_core
led_class psmouse cfg80211 snd_page_alloc battery ac e1000e serio_raw
intel_agp uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff80390bba>] ? blk_run_queue+0x3a/0x50
 [<ffffffff8044a852>] ? scsi_run_queue+0xe2/0x3f0
 [<ffffffff80438702>] ? put_device+0x12/0x20
 [<ffffffff804450a1>] ? __scsi_put_command+0x61/0xa0
 [<ffffffff803a1757>] ? kobject_put+0x27/0x60
 [<ffffffff80438702>] ? put_device+0x12/0x20
 [<ffffffff8044bb15>] ? scsi_next_command+0x45/0x60
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 6cbd13f9b20a7693 ]---
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4c6/0x770()
Hardware name: 6464CTO
Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp llc bluetooth autofs4 sunrpc ipv6 binfmt_misc dm_snapshot
dm_mirror dm_region_hash dm_log dm_mod rtc_cmos rtc_core rtc_lib
kvm_intel kvm i915 drm i2c_algo_bit uinput arc4 ecb
snd_hda_codec_analog cryptomgr snd_hda_intel aead snd_hda_codec
snd_seq_oss crypto_blkcipher crypto_hash snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm crypto_algapi iwl3945
mac80211 snd_timer button thinkpad_acpi rfkill backlight nvram evdev
i2c_i801 snd iTCO_wdt sr_mod cdrom soundcore i2c_core
iTCO_vendor_support usbhid hid lib80211 sdhci_pci sdhci mmc_core
led_class psmouse cfg80211 snd_page_alloc battery ac e1000e serio_raw
intel_agp uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #3
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff802604b2>] ? hrtimer_get_next_event+0x42/0xf0
 [<ffffffff804713b6>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80470ae6>] ata_sff_hsm_move+0x4c6/0x770
 [<ffffffff804710e9>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294aa5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029631c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 6cbd13f9b20a7694 ]---


Zdenek
