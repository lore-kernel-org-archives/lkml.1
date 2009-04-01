Return-Path: <linux-kernel-owner+w=401wt.eu-S1761017AbZDAI2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017AbZDAI2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZDAI2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:28:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:24305 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbZDAI2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:28:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vAuluD/7ESBFlU0RAXFEP3T38W3s23nWCPDXJ2lj+ljZ9TVeam44wZSVN1wQEM+FcT
         jXi+uEnFrLR64R9WwikLzjptCsitvwsygla1bO9BaFfyu3J597DUIEx8dg3geRtLv5rP
         oVwGoyFMEnTW+9LIBbwOc53d73ktTtwP7/17Q=
MIME-Version: 1.0
Date: Wed, 1 Apr 2009 16:28:16 +0800
Message-ID: <b6a2187b0904010128y7294b6c4p315d286c42c6f778@mail.gmail.com>
Subject: Intel HD Audio oops
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Takashi Iwai <tiwai@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest linux git oops with Intel HD Audio ...

CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_GENERIC=y


I bisect down to this ...
bb798169d1bb860b07192cf9c75937fadc8610b4 is first bad commit

Simply copying older hda folder (from last week) makes it works again.

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
