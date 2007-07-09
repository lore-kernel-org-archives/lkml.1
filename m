Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbXGIPEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbXGIPEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbXGIPD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:03:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52872 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753305AbXGIPD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:03:58 -0400
Date: Mon, 9 Jul 2007 11:03:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [2.6.22-rc7] khubd NULL deref oops...
In-Reply-To: <6bffcb0e0707081449h884c380i56ddb91041269414@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0707091101260.3851-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007, Michal Piotrowski wrote:

> Hi Daniel,
> 
> On 08/07/07, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> > When plugging in a USB 2 mass-storage device which I've been seeing
> > problems with, I caught a khubd oops [1]. Kernel is 2.6.22-rc7

> > [ 4771.448000] BUG: unable to handle kernel NULL pointer dereference
> > at virtual address 00000000
> > [ 4771.448000]  printing eip:
> > [ 4771.448000] c0255cc7
> > [ 4771.448000] *pde = 00000000
> > [ 4771.448000] Oops: 0000 [#1]
> > [ 4771.448000] SMP
> > [ 4771.448000] Modules linked in: usb_storage ide_core libusual
> > binfmt_misc nfs lockd sunrpc ipv6 sonypi ppdev acpi_cpufreq
> > cpufreq_stats cpufreq_powersave cpufreq_conservative cpufreq_userspace
> > cpufreq_ondemand freq_table button ac video dock container sbs battery
> > af_packet sbp2 parport_pc lp parport fuse snd_hda_intel snd_pcm_oss
> > snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss joydev snd_seq_midi
> > snd_rawmidi snd_seq_midi_event tifm_7xx1 pcmcia snd_seq snd_timer
> > snd_seq_device sky2 serio_raw tifm_core snd soundcore yenta_socket
> > rsrc_nonstatic pcmcia_core psmouse iTCO_wdt iTCO_vendor_support
> > snd_page_alloc shpchp pci_hotplug intel_agp agpgart evdev ext3 jbd
> > mbcache sg sd_mod sr_mod cdrom ata_generic ata_piix ohci1394 ieee1394
> > libata scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan
> > [ 4771.448000] CPU:    0
> > [ 4771.448000] EIP:    0060:[<c0255cc7>]    Not tainted VLI
> > [ 4771.448000] EFLAGS: 00010202   (2.6.22-rc7-50 #1)
> > [ 4771.448000] EIP is at make_class_name+0x27/0x80
> > [ 4771.448000] eax: 00000000   ebx: ffffffff   ecx: ffffffff   edx: 0000000b
> > [ 4771.448000] esi: f89ffca6   edi: 00000000   ebp: 00000000   esp: f7d05e5c
> > [ 4771.448000] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> > [ 4771.448000] Process khubd (pid: 2188, ti=f7d04000 task=c190f480
> > task.ti=f7d04000)
> > [ 4771.448000] Stack: dfc9a608 dfc9a494 dfc9a600 dfc9a608 f8a12ac0
> > c0255e59 00000000 f8a12b88
> > [ 4771.448000]        dfc9a600 dfc9a494 00000246 00000000 c0255ee8
> > dfc9a400 f89f9b56 dfc9a400
> > [ 4771.448000]        efc26800 f89f71fb efc26830 efc26800 f89f17e5
> > efc26af8 f41ce818 f8be1100
> > [ 4771.448000] Call Trace:
> > [ 4771.448000]  [<c0255e59>] class_device_del+0x99/0x120
> > [ 4771.448000]  [<c0255ee8>] class_device_unregister+0x8/0x10
> > [ 4771.448000]  [<f89f9b56>] __scsi_remove_device+0x26/0x60 [scsi_mod]
> > [ 4771.448000]  [<f89f71fb>] scsi_forget_host+0x4b/0x60 [scsi_mod]
> > [ 4771.448000]  [<f89f17e5>] scsi_remove_host+0x55/0xe0 [scsi_mod]
> > [ 4771.448000]  [<f8bd2c3e>] storage_disconnect+0xe/0x20 [usb_storage]
> > [ 4771.448000]  [<f8a4ea24>] usb_unbind_interface+0x44/0x90 [usbcore]
> > [ 4771.448000]  [<c0255408>] __device_release_driver+0x68/0xa0
> > [ 4771.448000]  [<c0255813>] device_release_driver+0x23/0x40
> > [ 4771.448000]  [<c0254d1c>] bus_remove_device+0x5c/0x90
> > [ 4771.448000]  [<c0253020>] device_del+0x160/0x260
> > [ 4771.448000]  [<f8a4bf28>] usb_disable_device+0x78/0xe0 [usbcore]
> > [ 4771.448000]  [<f8a48285>] usb_disconnect+0x95/0x130 [usbcore]
> > [ 4771.448000]  [<f8a48910>] hub_thread+0x270/0xc30 [usbcore]
> > [ 4771.448000]  [<c012a4e6>] do_exit+0x516/0x800
> > [ 4771.448000]  [<c0139b00>] autoremove_wake_function+0x0/0x40
> > [ 4771.448000]  [<f8a486a0>] hub_thread+0x0/0xc30 [usbcore]
> > [ 4771.448000]  [<c0139834>] kthread+0x34/0x60
> > [ 4771.448000]  [<c0139800>] kthread+0x0/0x60
> > [ 4771.448000]  [<c0105397>] kernel_thread_helper+0x7/0x10
> > [ 4771.448000]  =======================
> > [ 4771.448000] Code: 00 00 00 00 55 57 56 53 83 ec 04 31 ed 83 cb ff
> > 89 c6 89 c7 89 14 24 89 d9 89 e8 f2 ae f7 d1 49 8b 04 24 89 ca 89 d9
> > 8b 38 89 e8 <f2> ae f7 d1 49 8d 44 0a 02 ba d0 00 00 00 e8 06 36 f2 ff
> > 31 d2
> > [ 4771.448000] EIP: [<c0255cc7>] make_class_name+0x27/0x80 SS:ESP 0068:f7d05e5c

Although the bug occurred in the context of the khubd process, you can
see from the stack dump that the actual problem appears to lie in the
driver-model core.

Alan Stern

