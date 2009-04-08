Return-Path: <linux-kernel-owner+w=401wt.eu-S934877AbZDHRfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934877AbZDHRfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757706AbZDHRfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:35:33 -0400
Received: from ottmail.xandros.com ([142.46.212.35]:57027 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381AbZDHRfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:35:31 -0400
Date: Wed, 8 Apr 2009 13:34:54 -0400
From: Woody Suwalski <woodys@xandros.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <49DCE03E.6030108@xandros.com>
In-Reply-To: <5a4c581d0904070407k6ba559bcra4a79b5e3e49725f@mail.gmail.com>
References: <5a4c581d0904070407k6ba559bcra4a79b5e3e49725f@mail.gmail.com>
Subject: Re: Microcode driver causing WARNING in 2.6.29-git13/14 on Dell E6400
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Suardi wrote:
> Dell Latitude E6400, F10-uptodate as of yesterday, 2.6.29-git14 plus
>  Vegard Nossum's fix to acpi/battery.c to allow booting (this specific
>  WARNING was also printed during -git13 boot, which would eventually
>  hang prior to Vegard's patch).
>
> dmesg excerpt:
>
>
>
> Adding 4096532k swap on /dev/sda5.  Priority:-1 extents:1 across:4096532k
> SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
> platform microcode: firmware: requesting intel-ucode/06-17-06
> platform microcode: firmware: requesting intel-ucode/06-17-06
> Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x60/0xef()
> Hardware name: Latitude E6400
> sysfs group ffffffffa0136850 not found for kobject 'cpu0'
> Modules linked in: microcode(-) snd_hda_codec_intelhdmi snd_hda_intel
> snd_hda_codec snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event
> snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd
> battery pcspkr video dell_laptop firewire_ohci rfkill i2c_i801 ac
> firewire_core dcdbas soundcore usb_storage crc_itu_t output i2c_core
> joydev snd_page_alloc [last unloaded: scsi_wait_scan]
> Pid: 2570, comm: rmmod Not tainted 2.6.29-git14 #1
> Call Trace:
>  [<ffffffff81047c2e>] warn_slowpath+0xcc/0x11c
>  [<ffffffff811b4fd5>] ? kobject_release+0x6d/0x8c
>  [<ffffffff811b4f68>] ? kobject_release+0x0/0x8c
>  [<ffffffff8113f208>] sysfs_remove_group+0x60/0xef
>  [<ffffffffa01344b4>] mc_sysdev_remove+0x42/0x5f [microcode]
>  [<ffffffff8125970b>] sysdev_driver_unregister+0x6c/0xb8
>  [<ffffffffa0134f9a>] microcode_exit+0x47/0x87 [microcode]
>  [<ffffffff81075317>] sys_delete_module+0x1cb/0x246
>  [<ffffffff813c2b09>] ? trace_hardirqs_on_thunk+0x3a/0x3c
>  [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b
> ---[ end trace 13427fb4ef873fae ]---
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x60/0xef()
> Hardware name: Latitude E6400
> sysfs group ffffffffa0136850 not found for kobject 'cpu1'
> Modules linked in: microcode(-) snd_hda_codec_intelhdmi snd_hda_intel
> snd_hda_codec snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event
> snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd
> battery pcspkr video dell_laptop firewire_ohci rfkill i2c_i801 ac
> firewire_core dcdbas soundcore usb_storage crc_itu_t output i2c_core
> joydev snd_page_alloc [last unloaded: scsi_wait_scan]
> Pid: 2570, comm: rmmod Tainted: G        W  2.6.29-git14 #1
> Call Trace:
>  [<ffffffff81047c2e>] warn_slowpath+0xcc/0x11c
>  [<ffffffff811b4fd5>] ? kobject_release+0x6d/0x8c
>  [<ffffffff811b4f68>] ? kobject_release+0x0/0x8c
>  [<ffffffff8113f208>] sysfs_remove_group+0x60/0xef
>  [<ffffffffa01344b4>] mc_sysdev_remove+0x42/0x5f [microcode]
>  [<ffffffff8125970b>] sysdev_driver_unregister+0x6c/0xb8
>  [<ffffffffa0134f9a>] microcode_exit+0x47/0x87 [microcode]
>  [<ffffffff81075317>] sys_delete_module+0x1cb/0x246
>  [<ffffffff813c2b09>] ? trace_hardirqs_on_thunk+0x3a/0x3c
>  [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b
> ---[ end trace 13427fb4ef873faf ]---
> Microcode Update Driver: v2.00 removed.
>
>
> System seems to work at the moment (apart from unrelated X/VT
>  issues I plan to report in a detailed fashion by the end of this week).
>
> --alessandro
>
>  "Sun keeps rising in the west / I keep on waking fully confused"
>
>    (The Replacements, "Within Your Reach")
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
For me (on 2.6.29) it is processor.ko which needs to be loaded with 
nocst=1 option or else system will day 30seconds later...

Woody

-- 
Woody Suwalski, Xandros, Ottawa, Canada, 1-613-842-3498 x414

