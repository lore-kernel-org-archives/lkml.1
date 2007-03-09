Return-Path: <linux-kernel-owner+w=401wt.eu-S1767346AbXCIQPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767346AbXCIQPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767349AbXCIQPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:15:20 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:59526 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767346AbXCIQPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:15:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17905.32741.244785.543626@smtp.charter.net>
Date: Fri, 9 Mar 2007 10:40:21 -0500
From: "John Stoffel" <john@stoffel.org>
To: linux-usb-devel@lists.sourceforge.net
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: 2.6.21-rc3 - oops on remove of USB dongle
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I've just compiled and installed 2.6.21-rc3 on my Dual CPU Dell
Precision 610MT system.  Dual 550mhz Xeon, 768mb of RAM.  Mix of SCSI,
ATA drives.  I'm using the new ATA_ drivers for my PATA disks.  

After booting, I pulled my seldom used USB->serial device from the
system to toss in my bag to bring to work.  It's a Belkin F5U109
dongle.  I noticed the following oops:

  [  473.891249] usb 3-2.1: USB disconnect, address 3
  [  473.892072] pl2303 ttyUSB0: pl2303 converter now disconnected from
  ttyUSB0
  [  473.892141] pl2303 3-2.1:1.0: device disconnected
  [  482.749356] usb 3-2.2: USB disconnect, address 4
  [  482.749904] BUG: unable to handle kernel NULL pointer dereference
  at virtual 
  address 00000010
  [  482.749919]  printing eip:
  [  482.749926] c04010d4
  [  482.749932] *pde = 00000000
  [  482.749942] Oops: 0000 [#1]
  [  482.749947] SMP 
  [  482.749956] Modules linked in: dm_snapshot dm_mirror snd_pcm_oss
  snd_mixer_os
  s snd_ens1371 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm
  snd_seq_dummy sr_mod s
  nd_seq_oss cdrom snd_seq_midi_event snd_seq snd_timer snd_seq_device
  ohci1394 mc
  t_u232 pl2303 usbserial i2c_piix4 ieee1394 snd soundcore
  snd_page_alloc i2c_core
   ata_piix
  [  482.750034] CPU:    1
  [  482.750038] EIP:    0060:[<c04010d4>]    Not tainted VLI
  [  482.750043] EFLAGS: 00010296   (2.6.21-rc3 #8)
  [  482.750073] EIP is at klist_del+0x14/0x50
  [  482.750083] eax: 00000000   ebx: 00000000   ecx: 00000001   edx:
  ef94b818
  [  482.750097] esi: ef2d4084   edi: ef2d4098   ebp: ef94b818   esp:
  eff93e48
  [  482.750108] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
  [  482.750121] Process khubd (pid: 126, ti=eff92000 task=efe5b570
  task.ti=eff920
  00)
  [  482.750130] Stack: ef2d4084 ef2d4084 00000000 c02b5db5 ef2d4084
  ef282ea0 0000
  0000 ef94b818 
  [  482.750156]        c02b5f68 00000001 f0851c78 eed7b924 ef282ea0
  ef94b818 c031
  4be0 ef282ed4 
  [  482.750182]        f0851bf0 ef282ea0 c0239a3b c0401130 ef2d4000
  00000000 ef2d
  4000 ef2d4000 
  [  482.750208] Call Trace:
  [  482.750220]  [<c02b5db5>] device_del+0x15/0x1c0
  [  482.750252]  [<c02b5f68>] device_unregister+0x8/0x10
  [  482.750269]  [<f0851c78>] destroy_serial+0x88/0x110 [usbserial]
  [  482.750319]  [<c0314be0>] usb_kill_urb+0xc0/0xd0
  [  482.750353]  [<f0851bf0>] destroy_serial+0x0/0x110 [usbserial]
  [  482.750377]  [<c0239a3b>] kref_put+0x2b/0x80
  [  482.750392]  [<c0401130>] klist_release+0x0/0x30
  [  482.750410]  [<f0851a9b>] usb_serial_disconnect+0x5b/0xb0
  [usbserial]
  [  482.750435]  [<c04026ab>] mutex_lock+0xb/0x20
  [  482.750454]  [<c0314e83>] usb_disable_interface+0x33/0x40
  [  482.750474]  [<c0317588>] usb_unbind_interface+0x38/0x80
  [  482.750496]  [<c02b8458>] __device_release_driver+0x68/0xa0
  [  482.750520]  [<c02b8983>] device_release_driver+0x23/0x40
  [  482.750537]  [<c02b7ddc>] bus_remove_device+0x5c/0x90
  [  482.750553]  [<c02b5efb>] device_del+0x15b/0x1c0
  [  482.750570]  [<c0314de8>] usb_disable_device+0x78/0xe0
  [  482.750588]  [<c0311494>] usb_disconnect+0xa4/0x120
  [  482.750608]  [<c0312167>] hub_thread+0x1e7/0xb50
  [  482.750635]  [<c012ece0>] autoremove_wake_function+0x0/0x50
  [  482.750676]  [<c0311f80>] hub_thread+0x0/0xb50
  [  482.750689]  [<c012eb1b>] kthread+0xbb/0xf0
  [  482.750702]  [<c012ea60>] kthread+0x0/0xf0
  [  482.750717]  [<c01036c7>] kernel_thread_helper+0x7/0x10
  [  482.750740]  =======================
  [  482.750746] Code: 24 00 00 00 00 c6 44 24 07 00 eb ac 8b 43 04 8b
  30 eb 9b 8d
   74 26 00 83 ec 0c 89 7c 24 08 89 c7 89 1c 24 89 74 24 04 8b 18 89 d8
  <8b> 73 10
   e8 14 23 00 00 89 f8 e8 2d ff ff ff 85 c0 b8 00 00 00 
  [  482.750860] EIP: [<c04010d4>] klist_del+0x14/0x50 SS:ESP
  0068:eff93e48


The system is still running just fine.  When I get home, I can try
re-plugging it if you like, and seeing what happens.

John
