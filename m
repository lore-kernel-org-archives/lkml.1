Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990Ab0AFRCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0AFRCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942Ab0AFRCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:02:16 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:32869 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab0AFRCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:02:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qz+a5IQKZdjjW2aMZwn/I733a/dBnRAH/HnyjUWVRl9Eh5vwEP8BeFw5aPOgfFPWzq
         jGr6DmX6vo3D/YVu4gX4b1LiWlFBFCfk+PyzZW5165cxT0KubmkSySdymzd9V+quDIxl
         JbAUrSfO+E9vj7ta4xxp6ROLC48OlQlAslT1U=
MIME-Version: 1.0
In-Reply-To: <520f0cf11001060853i5c296744rf94c947cb7798774@mail.gmail.com>
References: <520f0cf11001060853i5c296744rf94c947cb7798774@mail.gmail.com>
Date: Wed, 6 Jan 2010 18:02:12 +0100
Message-ID: <520f0cf11001060902k643758dat8d26ac9fd964679d@mail.gmail.com>
Subject: Re: WARNING: at sound/core/sound_oss.c:96 snd_oss_kernel_minor+0xdf/0x120 
	[snd]()
From: John Kacur <jkacur@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 5:53 PM, John Kacur <jkacur@gmail.com> wrote:
> The following was in my 2.6.33-rc3 dmesg (of course that doesn't mean
> that the problem didn't exist earlier too)
>
> WARNING: at /home/jkacur/rt.linux.git/sound/core/sound_oss.c:96
> snd_oss_kernel_minor+0xdf/0x120 [snd]()
> Hardware name: 2241B48
> BUG? (minor < 0 || minor >= 128)
> Modules linked in: snd_mixer_oss thinkpad_acpi(+) sdhci hwmon i2c_i801
> firewire_ohci snd_pcm mmc_core snd_timer cfg80211 firewire_core btusb
> joydev iTCO_wdt bluetooth ata_generic e1000e i2c_core ppdev snd
> battery ac iTCO_vendor_support parport_pc ricoh_mmc intel_agp
> pata_acpi pcspkr parport tpm_tis video wmi output soundcore button tpm
> rfkill sr_mod tpm_bios snd_page_alloc crc_itu_t cdrom sg ahci libata
> sd_mod scsi_mod crc_t10dif xfs exportfs uhci_hcd ohci_hcd ehci_hcd
> [last unloaded: scsi_wait_scan]
> Pid: 1317, comm: modprobe Not tainted 2.6.33-rc3 #1
> Call Trace:
>  [<ffffffffa027bb25>] ? snd_oss_kernel_minor+0xdf/0x120 [snd]
>  [<ffffffff8104338c>] warn_slowpath_common+0x7c/0xa9
>  [<ffffffff81043410>] warn_slowpath_fmt+0x41/0x43
>  [<ffffffffa027bb25>] snd_oss_kernel_minor+0xdf/0x120 [snd]
>  [<ffffffffa027bc7e>] snd_register_oss_device+0x2c/0x21a [snd]
>  [<ffffffffa0271e1e>] snd_mixer_oss_notify_handler+0xa5/0x2e5 [snd_mixer_oss]
>  [<ffffffff81375e00>] ? __mutex_unlock_slowpath+0x5c/0x141
>  [<ffffffff810710d5>] ? trace_hardirqs_on_caller+0x11f/0x14a
>  [<ffffffff8107110d>] ? trace_hardirqs_on+0xd/0xf
> sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 21)
> sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
>  [<ffffffff81375ed3>] ? __mutex_unlock_slowpath+0x12f/0x141
> sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully
> claim to support it.
> Registered led device: mmc0::
> mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
>  [<ffffffffa027628a>] snd_card_register+0x135/0x14b [snd]
>  [<ffffffffa0370c88>] volume_init+0x335/0x3d2 [thinkpad_acpi]
>  [<ffffffffa037289b>] thinkpad_acpi_module_init+0x61f/0xa4f [thinkpad_acpi]
>  [<ffffffffa037227c>] ? thinkpad_acpi_module_init+0x0/0xa4f [thinkpad_acpi]
>  [<ffffffff810001fa>] do_one_initcall+0x5f/0x154
>  [<ffffffff8107ff34>] sys_init_module+0xd7/0x234
>  [<ffffffff81002d5b>] system_call_fastpath+0x16/0x1b
> ---[ end trace a6d53dc318f09cb5 ]---
>

Here is a slightly different trace back of the same problem in case
that helps anyone
to debug it. Thanks!

WARNING: at /home/jkacur/rt.linux.git/sound/core/sound_oss.c:96
snd_oss_kernel_minor+0xdf/0x120 [snd]()
Hardware name: 2241B48
BUG? (minor < 0 || minor >= 128)
Modules linked in: snd_mixer_oss(+) snd_pcm btusb firewire_ohci
sdhci_pci thinkpad_acpi sdhci snd_timer hwmon firewire_core bluetooth
e1000e ata_generic mmc_core iTCO_wdt i2c_i801 iTCO_vendor_support
ppdev snd tpm_tis i2c_core intel_agp wmi parport_pc parport ricoh_mmc
pata_acpi joydev tpm pcspkr video tpm_bios output sr_mod crc_itu_t
snd_page_alloc button soundcore cdrom ac battery rfkill sg ahci libata
sd_mod scsi_mod crc_t10dif xfs exportfs uhci_hcd ohci_hcd ehci_hcd
[last unloaded: scsi_wait_scan]
Pid: 1571, comm: modprobe Not tainted 2.6.33-rc3 #1
Call Trace:
 [<ffffffffa029db25>] ? snd_oss_kernel_minor+0xdf/0x120 [snd]
 [<ffffffff8104338c>] warn_slowpath_common+0x7c/0xa9
 [<ffffffff81043410>] warn_slowpath_fmt+0x41/0x43
 [<ffffffffa029db25>] snd_oss_kernel_minor+0xdf/0x120 [snd]
 [<ffffffffa029dc7e>] snd_register_oss_device+0x2c/0x21a [snd]
 [<ffffffffa0240e1e>] snd_mixer_oss_notify_handler+0xa5/0x2e5 [snd_mixer_oss]
 [<ffffffff8137b1e7>] ? sub_preempt_count+0xa3/0xb6
 [<ffffffff8137816d>] ? _raw_spin_unlock_irqrestore+0x6b/0x79
 [<ffffffff811ba1fe>] ? __up_read+0x7c/0x85
 [<ffffffffa024b000>] ? alsa_mixer_oss_init+0x0/0x3e [snd_mixer_oss]
 [<ffffffffa024b02a>] alsa_mixer_oss_init+0x2a/0x3e [snd_mixer_oss]
 [<ffffffff810001fa>] do_one_initcall+0x5f/0x154
 [<ffffffff8107ff34>] sys_init_module+0xd7/0x234
 [<ffffffff81002d5b>] system_call_fastpath+0x16/0x1b
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: 00
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
cfg80211: Calling CRDA to update world regulatory domain
---[ end trace bc1eb15b8cb7671c ]---
