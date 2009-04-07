Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbZDGGEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbZDGGEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZDGGEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:04:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:31103 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZDGGEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:04:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uaGFQDfkkHHMWFznsz4DHk2FhCrGnvGIDoA3GxBcJkBQxk3c1CYy43LV1WCMNrRvUi
         aQ0Q+pM4IJ2EnRIVB8tQRnholytN7tTJA25v9vKRIW2bGx9CA6ZUgJD4JI6hLCZJQUVb
         tG+BYzghRmqCyijXAQdGt3NgIu1Nk9eF+zWUk=
MIME-Version: 1.0
In-Reply-To: <s5hskkli38v.wl%tiwai@suse.de>
References: <s5hskkli38v.wl%tiwai@suse.de>
Date: Tue, 7 Apr 2009 14:04:28 +0800
Message-ID: <b6a2187b0904062304u609c6598i6d76a991b5ab0122@mail.gmail.com>
Subject: Re: [GIT PULL] sound updates for 2.6.30
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, perex@perex.cz,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I encountered this oops with the latest linux git pull. Will this
update fix the problem? When I rolled back to 2.6.29-stable, the sound
works find.

Oops from dmesg ...

HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
hda_intel: probe_mask set to 0x1 for device 17aa:20ac
HDA Intel 0000:00:1b.0: setting latency timer to 64
BUG: unable to handle kernel paging request at 6c000002
IP: [<c023d876>] strcpy+0xe/0x1b
*pdpt = 0000000036836001 *pde = 0000000000000000
Oops: 0000 [#1] PREEMPT SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda15/dev
Modules linked in: snd_hda_codec_analog snd_hda_intel(+) snd_hda_codec

Pid: 3067, comm: modprobe Not tainted (2.6.29 #3) 7676A24
EIP: 0060:[<c023d876>] EFLAGS: 00010286 CPU: 0
EIP is at strcpy+0xe/0x1b
EAX: f7605d78 EBX: 00000000 ECX: f7605d78 EDX: 6c000002
ESI: 6c000002 EDI: f7605d78 EBP: f7605d50 ESP: f7605d44
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 3067, ti=f7605000 task=f7537020 task.ti=f7605000)
Stack:
 00000000 f692b000 f7605da8 f7605db4 fa7e8e53 f7605d68 00000000 00000000
 00000000 00000000 00000002 00000000 00000000 00000000 00000000 00000000
 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
Call Trace:
 [<fa7e8e53>] ? _snd_hda_find_mixer_ctl+0x36/0x4a [snd_hda_codec]
 [<fa7e95b0>] ? snd_hda_add_vmaster+0x64/0x8a [snd_hda_codec]
 [<f8345420>] ? ad198x_build_controls+0x106/0x150 [snd_hda_codec_analog]
 [<fa7e72a8>] ? snd_hda_codec_build_controls+0x20/0x2c [snd_hda_codec]
 [<fa7e9df0>] ? snd_hda_build_controls+0x18/0x67 [snd_hda_codec]
 [<fa803f81>] ? azx_probe+0x715/0x78a [snd_hda_intel]
 [<fa802e29>] ? azx_send_cmd+0x0/0xbf [snd_hda_intel]
 [<fa802ee8>] ? azx_get_response+0x0/0x196 [snd_hda_intel]
 [<fa8028e0>] ? azx_attach_pcm_stream+0x0/0x133 [snd_hda_intel]
 [<c024b934>] ? local_pci_probe+0xe/0x10
 [<c024c26a>] ? pci_device_probe+0x48/0x66
 [<c02c837f>] ? driver_probe_device+0x7b/0xef
 [<c02c8436>] ? __driver_attach+0x43/0x5f
 [<c02c7aac>] ? bus_for_each_dev+0x39/0x5a
 [<c02c8256>] ? driver_attach+0x14/0x16
 [<c02c83f3>] ? __driver_attach+0x0/0x5f
 [<c02c7f07>] ? bus_add_driver+0x97/0x1a7
 [<c02c863d>] ? driver_register+0x7b/0xd7
 [<c024c45b>] ? __pci_register_driver+0x35/0x61
 [<fa80a017>] ? alsa_card_azx_init+0x17/0x19 [snd_hda_intel]
 [<c0101137>] ? do_one_initcall+0x4a/0x115
 [<fa80a000>] ? alsa_card_azx_init+0x0/0x19 [snd_hda_intel]
 [<c0144660>] ? sys_init_module+0x87/0x18b
 [<c0102a10>] ? sysenter_do_call+0x12/0x2c
Code: ff ff 21 e3 8b 5b 18 83 eb 07 39 d9 73 08 89 01 89 51 04 31 c0
c3 b8 f2 ff ff ff c3 90 55 89 c1 89 e5 57 89 c7 56 89 d6 83 ec 04 <ac>
aa 84 c0 75 fa 5a 89 c8 5e 5f 5d c3 55 89 e5 57 89 c7 56 89
EIP: [<c023d876>] strcpy+0xe/0x1b SS:ESP 0068:f7605d44
CR2: 000000006c000002
---[ end trace 6160ed88b8798d2d ]---


Thanks,
Jeff.


On Tue, Apr 7, 2009 at 10:53 AM, Takashi Iwai <tiwai@suse.de> wrote:
> Linus,
>
> please pull more ALSA updates for v2.6.30 from:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git for-linus
>
> Mostly small fixes for atmel drivers, usb-audio and others as below.
> Still one ASoC driver addition that was missing in the last pull
> request, but it's safe to apply as it's a very local one.
>
>
> Thanks!
>
> Takashi
>
> ===
>
> Akinobu Mita (1):
>      ALSA: hda - add missing comma in ad1884_slave_vols
>
> Anton Vorontsov (1):
>      ASoC: fsl_dma: Pass the proper device for dma mapping routines
>
> Clemens Ladisch (4):
>      sound: usb-audio: show sample format width in proc file
>      sound: usb-audio: remove check_hw_params_convention()
>      sound: usb-audio: save data packet interval in audioformat structure
>      sound: usb-audio: allow period sizes less than 1 ms
>
> Dan Carpenter (1):
>      ASoC: Fix null dereference in ak4535_remove()
>
> Deepika Makhija (1):
>      ALSA: oss - volume control for CSWITCH and CROUTE
>
> Hans-Christian Egtvedt (10):
>      ALSA: snd-atmel-ac97c: cleanup register definitions
>      ALSA: snd-atmel-ac97c: remove dead break statements after return in switch case
>      ALSA: snd-atmel-ac97c: do not overwrite OCA and ICA when assigning channels
>      ALSA: snd-atmel-ac97c: set correct size for buffer hardware parameter
>      ALSA: snd-atmel-ac97c: enable interrupts to catch events for error reporting
>      ALSA: snd-atmel-ac97c: do a proper reset of the external codec
>      ALSA: snd-atmel-ac97c: cleanup registers when removing driver
>      ALSA: snd-atmel-ac97c: replace bus_id with dev_name()
>      ALSA: snd-atmel-abdac: replace bus_id with dev_name()
>      ALSA: snd-atmel-abdac: increase periods_min to 6 instead of 4
>
> Jarkko Nikula (1):
>      ASoC: OMAP: Set minimum buffer size constraint for McBSP2 in OMAP3
>
> Krzysztof Helt (1):
>      ALSA: opl3sa2: add ZV port control
>
> Luotao Fu (1):
>      pxa2xx-ac97: fix displaying GSR after reset timeout
>
> Mark Brown (4):
>      ASoC: Add some documentation for the ASoC jack API
>      ASoC: Don't defer resume work for AC97 codecs
>      ASoC: Set parent for AC97 devices we register
>      ASoC: Implement suspend and resume operations for WM9705
>
> Matthew Ranostay (2):
>      ALSA: Add 92HD81B1C device id
>      ALSA: hda - Add VREF powerdown sequence for another board
>
> Peter Ujfalusi (3):
>      ASoC: TWL4030: 96KHz playback support
>      ASoC: TWL4030: Add constrains for second stream
>      ASoC: TWL4030: Add actual support for 96KHz playback support
>
> Philipp Zabel (2):
>      ASoC: pxa-ssp: Use 16-bit DMA for magician stereo
>      ASoC: Add Magician machine support
>
> Timur Tabi (2):
>      ASoC: remove trigger delay in Freescale MPC8610 sound driver
>      ASoC: trim SSI sysfs statistics in Freescale MPC8610 sound drivers
>
> Uwe Kleine-König (1):
>      ALSA: move snd_powermac's probe function to .devinit.text
>
> Wu Fengguang (1):
>      ALSA: hda - enable SPDIF output for Intel DX58SO board
>
> ---
>  Documentation/sound/alsa/soc/jack.txt |   71 +++++
>  sound/arm/pxa2xx-ac97-lib.c           |   15 +-
>  sound/atmel/abdac.c                   |    4 +-
>  sound/atmel/ac97c.c                   |  128 +++++++--
>  sound/atmel/ac97c.h                   |   14 +-
>  sound/core/oss/mixer_oss.c            |    8 +
>  sound/isa/opl3sa2.c                   |    1 +
>  sound/pci/hda/patch_analog.c          |    2 +-
>  sound/pci/hda/patch_realtek.c         |    5 +
>  sound/pci/hda/patch_sigmatel.c        |   20 ++
>  sound/ppc/powermac.c                  |    2 +-
>  sound/soc/codecs/ak4535.c             |    3 +-
>  sound/soc/codecs/twl4030.c            |   59 ++++-
>  sound/soc/codecs/twl4030.h            |    1 +
>  sound/soc/codecs/wm9705.c             |   37 +++
>  sound/soc/fsl/fsl_dma.c               |   29 ++-
>  sound/soc/fsl/fsl_ssi.c               |   99 +++---
>  sound/soc/omap/omap-mcbsp.c           |   11 +
>  sound/soc/pxa/Kconfig                 |   10 +
>  sound/soc/pxa/Makefile                |    2 +
>  sound/soc/pxa/magician.c              |  560 +++++++++++++++++++++++++++++++++
>  sound/soc/pxa/pxa-ssp.c               |   12 +-
>  sound/soc/soc-core.c                  |   20 +-
>  sound/usb/usbaudio.c                  |  255 +++++++--------
>  24 files changed, 1133 insertions(+), 235 deletions(-)
>  create mode 100644 Documentation/sound/alsa/soc/jack.txt
>  create mode 100644 sound/soc/pxa/magician.c
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
