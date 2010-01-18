Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979Ab0ARIP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0ARIP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578Ab0ARIP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:15:26 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49349 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab0ARIPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:15:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tLYPipuCqXjW1KJcGa6vePCye3LtITOnwApdIt4ZjCfYREAkfBFNsqrodGp+1y0v6y
         ERBoAKpBLzlO+URPVBOPxptQ392oupksvEKaH2Jd1CYrR68yqB9V3WPQSSUJO0rMDNDO
         Nukv1+fyzwcRDHFQJW6bzj+WRaQq+EGlwsfGM=
MIME-Version: 1.0
In-Reply-To: <s5hzl4j66pr.wl%tiwai@suse.de>
References: <520f0cf11001060853i5c296744rf94c947cb7798774@mail.gmail.com>
	 <s5hzl4j66pr.wl%tiwai@suse.de>
Date: Mon, 18 Jan 2010 09:15:23 +0100
X-Google-Sender-Auth: a5d75804efe27c97
Message-ID: <520f0cf11001180015ub28da4fp4c8c38d3c02c78d5@mail.gmail.com>
Subject: Re: WARNING: at sound/core/sound_oss.c:96 snd_oss_kernel_minor+0xdf/0x120 
	[snd]()
From: John Kacur <jkacur@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jaroslav Kysela <perex@perex.cz>,
       alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 9:57 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 6 Jan 2010 17:53:24 +0100,
> John Kacur wrote:
>>
>> The following was in my 2.6.33-rc3 dmesg (of course that doesn't mean
>> that the problem didn't exist earlier too)
>>
>> WARNING: at /home/jkacur/rt.linux.git/sound/core/sound_oss.c:96
>> snd_oss_kernel_minor+0xdf/0x120 [snd]()
>> Hardware name: 2241B48
>> BUG? (minor < 0 || minor >= 128)
>> Modules linked in: snd_mixer_oss thinkpad_acpi(+) sdhci hwmon i2c_i801
>> firewire_ohci snd_pcm mmc_core snd_timer cfg80211 firewire_core btusb
>> joydev iTCO_wdt bluetooth ata_generic e1000e i2c_core ppdev snd
>> battery ac iTCO_vendor_support parport_pc ricoh_mmc intel_agp
>> pata_acpi pcspkr parport tpm_tis video wmi output soundcore button tpm
>> rfkill sr_mod tpm_bios snd_page_alloc crc_itu_t cdrom sg ahci libata
>> sd_mod scsi_mod crc_t10dif xfs exportfs uhci_hcd ohci_hcd ehci_hcd
>> [last unloaded: scsi_wait_scan]
>> Pid: 1317, comm: modprobe Not tainted 2.6.33-rc3 #1
>> Call Trace:
>>  [<ffffffffa027bb25>] ? snd_oss_kernel_minor+0xdf/0x120 [snd]
>>  [<ffffffff8104338c>] warn_slowpath_common+0x7c/0xa9
>>  [<ffffffff81043410>] warn_slowpath_fmt+0x41/0x43
>>  [<ffffffffa027bb25>] snd_oss_kernel_minor+0xdf/0x120 [snd]
>>  [<ffffffffa027bc7e>] snd_register_oss_device+0x2c/0x21a [snd]
>>  [<ffffffffa0271e1e>] snd_mixer_oss_notify_handler+0xa5/0x2e5 [snd_mixer_oss]
>>  [<ffffffff81375e00>] ? __mutex_unlock_slowpath+0x5c/0x141
>>  [<ffffffff810710d5>] ? trace_hardirqs_on_caller+0x11f/0x14a
>>  [<ffffffff8107110d>] ? trace_hardirqs_on+0xd/0xf
>> sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 21)
>> sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
>>  [<ffffffff81375ed3>] ? __mutex_unlock_slowpath+0x12f/0x141
>> sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully
>> claim to support it.
>> Registered led device: mmc0::
>> mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
>>  [<ffffffffa027628a>] snd_card_register+0x135/0x14b [snd]
>>  [<ffffffffa0370c88>] volume_init+0x335/0x3d2 [thinkpad_acpi]
>>  [<ffffffffa037289b>] thinkpad_acpi_module_init+0x61f/0xa4f [thinkpad_acpi]
>>  [<ffffffffa037227c>] ? thinkpad_acpi_module_init+0x0/0xa4f [thinkpad_acpi]
>>  [<ffffffff810001fa>] do_one_initcall+0x5f/0x154
>>  [<ffffffff8107ff34>] sys_init_module+0xd7/0x234
>>  [<ffffffff81002d5b>] system_call_fastpath+0x16/0x1b
>> ---[ end trace a6d53dc318f09cb5 ]---
>
> Looks like the code path from thinkpad-acpi...
>
> Could you add some printk's in sound/core/sound_oss.c:snd_oss_kernel_minor()
> to inspect which values are taken and calculated?
>

I'm getting a card->number equal to 29, and a dev equal to 0.
The case is SNDRV_OSS_DEVICE_TYPE_MIXER:
So that does 	minor = SNDRV_MINOR_OSS(card->number, (dev ?
SNDRV_MINOR_OSS_MIXER1 : SNDRV_MINOR_OSS_MIXER));
and according to the formula #define SNDRV_MINOR_OSS(card,
dev)	(((card) << 4) | (dev))
That works out to 464 which of course is not in the acceptable range
between 0 and 128.

John
