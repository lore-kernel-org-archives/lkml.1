Return-Path: <linux-kernel-owner+w=401wt.eu-S1751515AbXLYWF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbXLYWF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 17:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbXLYWFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 17:05:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355AbXLYWFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 17:05:45 -0500
Date: Tue, 25 Dec 2007 14:04:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Victor Hahn <victor@open-bash.org>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>,
       Takashi Iwai <tiwai@suse.de>, linux-usb@vger.kernel.org
Subject: Re: Can't disconnect a USB sound device and connect another
Message-Id: <20071225140450.b6d742bb.akpm@linux-foundation.org>
In-Reply-To: <200712232336.17238.victor@open-bash.org>
References: <200712232336.17238.victor@open-bash.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2007 23:36:11 +0100 Victor Hahn <victor@open-bash.org> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> ... because it causes lsusb to freeze and gives me this in /var/log/messages:

Has this always happened, or is it something we introduced in a recent
kernel?

> Dec 23 23:27:04 cabrio kernel: usb 2-2: USB disconnect, address 5
> Dec 23 23:27:04 cabrio kernel: PGD 110f2067 PUD 110f3067 PMD 0
> Dec 23 23:27:04 cabrio kernel: CPU 0
> Dec 23 23:27:04 cabrio kernel: Modules linked in: videodev v4l2_common 
> v4l1_compat snd_rtctimer binfmt_misc rfcomm l2cap bluetooth capability 
> commoncap ppdev powernow_k8 cpufreq_userspace cpufreq_stats cpufreq_powersave 
> cpufreq_ondemand freq_table cpufreq_conservative video output sbs container 
> dock ac battery ext3 jbd mbcache aes_x86_64 ipv6 it87 hwmon_vid parport_pc lp 
> parport loop snd_mpu401 snd_mpu401_uart snd_usb_audio snd_pcm_oss 
> snd_mixer_oss snd_pcm snd_seq_dummy snd_page_alloc snd_usb_lib snd_hwdep 
> snd_seq_oss analog gameport snd_seq_midi snd_rawmidi snd_seq_midi_event 
> snd_seq snd_timer snd_seq_device snd psmouse button soundcore serio_raw 
> i2c_nforce2 k8temp i2c_core pcspkr af_packet shpchp pci_hotplug evdev xfs 
> sha256 twofish_x86_64 twofish_common cbc blkcipher sg ide_cd cdrom sd_mod 
> usbhid hid sata_nv 8139too floppy ata_generic 8139cp mii libata scsi_mod 
> amd74xx ide_core forcedeth ehci_hcd ohci_hcd usbcore dm_crypt dm_mirror 
> dm_snapshot dm_mod thermal processor fan fuse
> Dec 23 23:27:04 cabrio kernel: Pid: 2052, comm: khubd Not tainted 2.6.23.11 #1
> Dec 23 23:27:04 cabrio kernel: RIP: 0010:[_end+130488219/2130651808]  
> [_end+130488219/2130651808] :snd:snd_ctl_dev_disconnect+0x6b/0xb0
> Dec 23 23:27:04 cabrio kernel: RSP: 0018:ffff810037bfdc40  EFLAGS: 00010282
> Dec 23 23:27:04 cabrio kernel: RAX: 0000000000000000 RBX: 0000000000100100 
> RCX: 0000000000000018
> Dec 23 23:27:04 cabrio kernel: RDX: 0000000000020004 RSI: 000000000000001d 
> RDI: ffff810013e98c08
> Dec 23 23:27:04 cabrio kernel: RBP: ffff8100394631a8 R08: ffff810037bfc000 
> R09: 0000000000000000
> Dec 23 23:27:04 cabrio kernel: R10: 0000000000000000 R11: ffffffff88281910 
> R12: ffff810039463000
> Dec 23 23:27:04 cabrio kernel: R13: ffff810039463168 R14: 0000000000000000 
> R15: ffff810039463000
> Dec 23 23:27:04 cabrio kernel: FS:  00002b24912551e0(0000) GS:ffffffff80533000
> (0000) knlGS:00000000f74b16c0
> Dec 23 23:27:04 cabrio kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 
> 000000008005003b
> Dec 23 23:27:04 cabrio kernel: CR2: 0000000000100100 CR3: 00000000110f1000 
> CR4: 00000000000006e0
> Dec 23 23:27:04 cabrio kernel: DR0: 0000000000000000 DR1: 0000000000000000 
> DR2: 0000000000000000
> Dec 23 23:27:04 cabrio kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 
> DR7: 0000000000000400
> Dec 23 23:27:04 cabrio kernel: Process khubd (pid: 2052, threadinfo 
> ffff810037bfc000, task ffff81003d67d0c0)
> Dec 23 23:27:04 cabrio kernel: Stack:  0000000000000000 ffff810038850d00 
> ffff810039463000 ffff810039463150
> Dec 23 23:27:04 cabrio kernel:  0000000000000000 ffffffff88281e69 
> ffff810038850d00 ffffffff882821ac
> Dec 23 23:27:04 cabrio kernel:  0000000000000000 0000000000000000 
> ffff810039463000 ffff8100394631e0
> Dec 23 23:27:04 cabrio kernel: Call Trace:
> Dec 23 23:27:04 cabrio kernel:  
> [_end+130500873/2130651808] :snd:snd_device_disconnect+0x59/0x90
> Dec 23 23:27:04 cabrio kernel:  
> [_end+130501708/2130651808] :snd:snd_device_disconnect_all+0x3c/0x70
> Dec 23 23:27:04 cabrio kernel:  
> [_end+130481675/2130651808] :snd:snd_card_disconnect+0x15b/0x1a0
> Dec 23 23:27:04 cabrio kernel:  
> [_end+131093678/2130651808] :snd_usb_audio:usb_audio_disconnect+0xae/0x1a0
> Dec 23 23:27:04 cabrio kernel:  
> [_end+128211869/2130651808] :usbcore:usb_unbind_interface+0x6d/0xe0
> Dec 23 23:27:04 cabrio kernel:  [__device_release_driver+130/192] 
> __device_release_driver+0x82/0xc0
> Dec 23 23:27:04 cabrio kernel:  [device_release_driver+51/96] 
> device_release_driver+0x33/0x60
> Dec 23 23:27:04 cabrio kernel:  [bus_remove_device+118/176] 
> bus_remove_device+0x76/0xb0
> Dec 23 23:27:04 cabrio kernel:  [device_del+417/736] device_del+0x1a1/0x2e0
> Dec 23 23:27:04 cabrio kernel:  
> [_end+128198657/2130651808] :usbcore:usb_disable_device+0x91/0x110
> Dec 23 23:27:04 cabrio kernel:  
> [_end+128179466/2130651808] :usbcore:usb_disconnect+0xaa/0x150
> Dec 23 23:27:04 cabrio kernel:  
> [_end+128181649/2130651808] :usbcore:hub_thread+0x401/0xe30
> Dec 23 23:27:04 cabrio kernel:  [thread_return+87/1463] 
> thread_return+0x57/0x5b7
> Dec 23 23:27:04 cabrio kernel:  [autoremove_wake_function+0/48] 
> autoremove_wake_function+0x0/0x30
> Dec 23 23:27:04 cabrio kernel:  
> [_end+128180624/2130651808] :usbcore:hub_thread+0x0/0xe30
> Dec 23 23:27:04 cabrio kernel:  [kthread+75/128] kthread+0x4b/0x80
> Dec 23 23:27:04 cabrio kernel:  [child_rip+10/18] child_rip+0xa/0x12
> Dec 23 23:27:04 cabrio kernel:  [kthread+0/128] kthread+0x0/0x80
> Dec 23 23:27:04 cabrio kernel:  [child_rip+0/18] child_rip+0x0/0x12
> Dec 23 23:27:04 cabrio kernel:
> Dec 23 23:27:04 cabrio kernel:
> Dec 23 23:27:04 cabrio kernel: Code: 48 8b 03 0f 18 08 48 39 eb 75 ca 4c 89 ef 
> e8 d2 35 fd f7 ba
> Dec 23 23:27:04 cabrio kernel:  RSP <ffff810037bfdc40>
> 
> Is there a way to exchange USB audio devices without rebooting?

First we have to work out if it's a USB bug or an ALSA bug.  I'd guess
ALSA, but not with a lot of confidence.

Anyone?
