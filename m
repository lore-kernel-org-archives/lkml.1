Return-Path: <linux-kernel-owner+w=401wt.eu-S939087AbXG3HQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939087AbXG3HQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 03:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938675AbXG3HQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 03:16:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41535 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S938529AbXG3HQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 03:16:27 -0400
Date: Mon, 30 Jul 2007 00:16:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: bug in slab.c
Message-Id: <20070730001604.d58dca0a.akpm@linux-foundation.org>
In-Reply-To: <20070729073739.GD1678@pengutronix.de>
References: <20070729073739.GD1678@pengutronix.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007 09:37:39 +0200 Robert Schwebel <r.schwebel@pengutronix.de> wrote:

> Hi,
> 
> My Dell Latitude D520 just dies with this BUG:

Reproducible, I assume.

> ----------8<----------8<----------8<----------8<----------
> Jul 29 09:30:00 localhost kernel: ------------[ cut here ]------------
> Jul 29 09:30:00 localhost kernel: kernel BUG at mm/slab.c:2980!
> Jul 29 09:30:00 localhost kernel: invalid opcode: 0000 [#1]
> Jul 29 09:30:00 localhost kernel: PREEMPT SMP 
> Jul 29 09:30:00 localhost kernel: Modules linked in: button psmouse hidp rfcomm l2cap hci_vhci dtl1_cs btuart_cs bt3c_cs bluecard_cs bf
> usb bcm203x hci_uart michael_mic arc4 ecb ieee80211_crypt_tkip ieee80211_crypt_ccmp ipw3945 ieee80211 ieee80211_crypt i915 drm cpufreq_
> ondemand cpufreq_userspace cpufreq_powersave speedstep_centrino freq_table nfs nfsd exportfs lockd nfs_acl sunrpc ac battery sbp2 loop 
> pcmcia firmware_class snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer yenta_socket hci_usb rsrc_nonstatic snd serio_raw sound
> core bluetooth i2c_i801 intel_agp pcmcia_core snd_page_alloc i2c_core rtc pcspkr evdev ext3 jbd mbcache sha256 aes cbc blkcipher usbhid
>  dm_crypt dm_mirror dm_snapshot dm_mod sd_mod ohci1394 ieee1394 ata_piix b44 mii libata scsi_mod ehci_hcd uhci_hcd usbcore thermal proc
> essor fan
> Jul 29 09:30:00 localhost kernel: CPU:    1
> Jul 29 09:30:00 localhost kernel: EIP:    0060:[<c0163ac4>]    Not tainted VLI
> Jul 29 09:30:00 localhost kernel: EFLAGS: 00210046   (2.6.22.1 #1)
> Jul 29 09:30:00 localhost kernel: EIP is at cache_alloc_refill+0xeb/0x447
> Jul 29 09:30:00 localhost kernel: eax: 0000000f   ebx: 00000005   ecx: dffff4c0   edx: dffff4c0
> Jul 29 09:30:00 localhost kernel: esi: e451e000   edi: 00000026   ebp: c18ea800   esp: edbedd90
> Jul 29 09:30:00 localhost kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Jul 29 09:30:00 localhost kernel: Process firefox-bin (pid: 3865, ti=edbec000 task=dfc02a50 task.ti=edbec000)
> Jul 29 09:30:00 localhost kernel: Stack: 0000000f 000004d0 dffff4c0 dfffd2c0 00000000 00000000 00000001 00200202 
> Jul 29 09:30:00 localhost kernel:        d63a0218 e60df3c0 dffff4c0 00200286 ef84c6c0 000004d0 c0163e6f ef84c6c0 
> Jul 29 09:30:00 localhost kernel:        00000040 c0246212 00000000 dfcc2c40 e2c91740 000004d0 efd29740 00000000 
> Jul 29 09:30:00 localhost kernel: Call Trace:
> Jul 29 09:30:00 localhost kernel:  [<c0163e6f>] __kmalloc+0x4f/0x58
> Jul 29 09:30:00 localhost kernel:  [<c0246212>] __alloc_skb+0x49/0xf5
> Jul 29 09:30:00 localhost kernel:  [<c0242bef>] sock_alloc_send_skb+0x6e/0x196
> Jul 29 09:30:00 localhost kernel:  [<c029a7d2>] unix_stream_sendmsg+0x14d/0x309
> Jul 29 09:30:00 localhost kernel:  [<c02401d3>] sock_aio_write+0xf9/0x105
> Jul 29 09:30:00 localhost kernel:  [<c016677b>] do_sync_write+0xc7/0x10a
> Jul 29 09:30:00 localhost kernel:  [<c0131fac>] autoremove_wake_function+0x0/0x35
> Jul 29 09:30:00 localhost kernel:  [<c02405a2>] sock_ioctl+0x1a2/0x1c1
> Jul 29 09:30:00 localhost kernel:  [<c0240400>] sock_ioctl+0x0/0x1c1
> Jul 29 09:30:00 localhost kernel:  [<c0166f73>] vfs_write+0xbc/0x12a
> Jul 29 09:30:00 localhost kernel:  [<c01674ea>] sys_write+0x41/0x67
> Jul 29 09:30:00 localhost kernel:  [<c0103d42>] sysenter_past_esp+0x5f/0x85
> Jul 29 09:30:00 localhost kernel:  =======================
> Jul 29 09:30:00 localhost kernel: Code: 8b 30 39 c6 75 19 c7 40 38 01 00 00 00 8b 70 10 8b 44 24 0c 83 c0 10 39 c6 0f 84 9e 00 00 00 8b
>  54 24 08 8b 42 20 39 46 10 72 2d <0f> 0b eb fe 8b 44 24 08 8b 5e 14 8b 4d 00 8b 50 14 8b 04 24 0f 
> Jul 29 09:30:00 localhost kernel: EIP: [<c0163ac4>] cache_alloc_refill+0xeb/0x447 SS:ESP 0068:edbedd90
> Jul 29 09:30:00 localhost kernel: note: firefox-bin[3865] exited with preempt_count 1
> Jul 29 09:30:03 localhost kernel: ipw3945: Detected geography ABG (13 802.11bg channels, 23 802.11a channels)
> ----------8<----------8<----------8<----------8<----------
> 
> root@thebe:~# uname -a
> Linux thebe 2.6.22.1 #1 SMP PREEMPT Fri Jul 13 08:23:52 CEST 2007 i686 GNU/Linux
> 
> The only non-standard thing is the ipw drivers (ipw3945-1.2.1).
> 

Have you tried testing a kernel which doesn't have those drivers?

(It'd be a clever little driver to cause that BUG though)
