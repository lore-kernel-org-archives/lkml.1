Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbZJ0XkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbZJ0XkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 19:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756852AbZJ0XkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 19:40:19 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:33075 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843AbZJ0XkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 19:40:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=pXeW509mSboXTfZnHpaB/oG335PSqDJe2e6m8YobmoG0NZuQNoYjcz4dRIDlepxOIk
         G+SeLuydYJXbTnWYSEtg2MdggOBOZPc9QAs8dB4mJBT2A5J6wBu/9h+CGtPRHQARFRA0
         6YqwEIqP0qKDed+66g7XAeQkpGPl/MMuY0pvs=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 27 Oct 2009 16:40:03 -0700
Message-ID: <43e72e890910271640n7fafc8edpc14143fcfca7df60@mail.gmail.com>
Subject: scheduling while atomic acpi_idle_enter_bm
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get this when modprobing some module I am working on. I figured it
was the module's fault but the EIP points to something else so I am
not sure. I get the following repeating about 4 times on 2.6.32-rc5:

[ 4806.829545] BUG: scheduling while atomic: swapper/0/0x10010000
[ 4806.829551] Modules linked in: ath9k_htc ath9k_hw ath_hif_usb
ath_htc binfmt_misc i915 drm_kms_helper drm i2c_algo_bit bri
dge stp bnep lp snd_hda_codec_analog snd_hda_intel snd_hda_codec
snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy snd_seq
_oss snd_seq_midi snd_rawmidi ath5k snd_seq_midi_event snd_seq
snd_timer snd_seq_device mac80211 ath joydev pcmcia ppdev thin
kpad_acpi snd hid_microsoft video parport_pc psmouse soundcore
cfg80211 usbhid output yenta_socket rsrc_nonstatic pcmcia_core
 parport btusb serio_raw pcspkr nvram snd_page_alloc led_class
intel_agp agpgart iTCO_wdt iTCO_vendor_support ohci1394 ieee13
94 e1000e
[ 4806.829683]
[ 4806.829690] Pid: 0, comm: swapper Not tainted (2.6.32-rc5-wl #27) 7660A14
[ 4806.829700] EIP: 0060:[<c03a1a7b>] EFLAGS: 00000292 CPU: 0
[ 4806.829714] EIP is at acpi_idle_enter_bm+0x251/0x282
[ 4806.829720] EAX: c0884bec EBX: 000002ba ECX: 00000000 EDX: 0137f000
[ 4806.829727] ESI: 00000000 EDI: f70bacc0 EBP: c0773f9c ESP: c0773f70
[ 4806.829733]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 4806.829740] CR0: 8005003b CR2: 0804c000 CR3: 00892000 CR4: 00000690
[ 4806.829748] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 4806.829753] DR6: ffff0ff0 DR7: 00000400
[ 4806.829758] Call Trace:
[ 4806.829773]  [<c04a9537>] cpuidle_idle_call+0x77/0xf0
[ 4806.829784]  [<c01020da>] cpu_idle+0x5a/0x90
[ 4806.829795]  [<c05913c8>] rest_init+0x58/0x70
[ 4806.829808]  [<c07e8945>] start_kernel+0x330/0x398
[ 4806.829818]  [<c07e83ce>] ? unknown_bootoption+0x0/0x1f6
[ 4806.829828]  [<c07e807e>] i386_start_kernel+0x7e/0xa8

Then I get some 3 of these:

[ 4808.518136] BUG: scheduling while atomic: swapper/0/0x10010000
[ 4808.518143] Modules linked in: ath9k_htc ath9k_hw ath_hif_usb
ath_htc binfmt_misc i915 drm_kms_helper drm i2c_algo_bit bridge stp
bnep lp snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss
snd_mixer_oss snd_pcm arc4 snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi ath5k snd_seq_midi_event snd_seq snd_timer snd_seq_device
mac80211 ath joydev pcmcia ppdev thinkpad_acpi snd hid_microsoft video
parport_pc psmouse soundcore cfg80211 usbhid output yenta_socket
rsrc_nonstatic pcmcia_core parport btusb serio_raw pcspkr nvram
snd_page_alloc led_class intel_agp agpgart iTCO_wdt
iTCO_vendor_support ohci1394 ieee1394 e1000e
[ 4808.518258]
[ 4808.518264] Pid: 0, comm: swapper Not tainted (2.6.32-rc5-wl #27) 7660A14
[ 4808.518271] EIP: 0060:[<c05a65cf>] EFLAGS: 00000296 CPU: 1
[ 4808.518280] EIP is at _spin_unlock_irqrestore+0xf/0x20
[ 4808.518286] EAX: 00000296 EBX: f70bb008 ECX: 0000195e EDX: 00000296
[ 4808.518292] ESI: 00000005 EDI: 00000296 EBP: f70b3f20 ESP: f70b3f20
[ 4808.518299]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 4808.518304] CR0: 8005003b CR2: 08204008 CR3: 36b26000 CR4: 00000690
[ 4808.518310] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 4808.518315] DR6: ffff0ff0 DR7: 00000400
[ 4808.518319] Call Trace:
[ 4808.518328]  [<c017615a>] clockevents_notify+0x3a/0x80
[ 4808.518338]  [<c03a14d4>] lapic_timer_state_broadcast+0x36/0x39
[ 4808.518347]  [<c03a1a99>] acpi_idle_enter_bm+0x26f/0x282
[ 4808.518356]  [<c04a9537>] cpuidle_idle_call+0x77/0xf0
[ 4808.518364]  [<c01020da>] cpu_idle+0x5a/0x90
[ 4808.518373]  [<c05a1204>] start_secondary+0x170/0x1dc
[ 4808.518382]  [<c05a1204>] ? start_secondary+0x170/0x1dc

  Luis


  Luis
