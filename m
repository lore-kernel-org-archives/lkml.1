Return-Path: <linux-kernel-owner+w=401wt.eu-S1764649AbXGKNGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764649AbXGKNGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758594AbXGKNGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:06:43 -0400
Received: from herkules.vianova.fi ([194.100.28.129]:50786 "HELO
	mail.vianova.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757558AbXGKNGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:06:42 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2007 09:06:41 EDT
Date: Wed, 11 Jul 2007 15:59:57 +0300
From: Ville Herva <v@iki.fi>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22 Oops attaching  usb-storage device
Message-ID: <20070711125957.GT22103@vianova.fi>
Reply-To: v@iki.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux herkules.vianova.fi 2.4.32-rc1
User-Agent: Mutt/1.5.10i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First: thanks for the new partition print out when failing to mount rootfs.
That came in handy on the very first boot (I had switched harddisks around
and failed to guess the correct root device 2102). I've been longing for
that sort of printout for years. Very useful.

Anyway, 2.6.22, seems pretty solid, but I managed to oops it. I had Creative
Muvo Zen V attached (I believe it played no role in the oops) and tried to
attach Nokia E70 in usb storage mode. The first time Nokia said usb storage
mode couldn't be used since there was an application using the memory card
(in reality there wasn't, but Nokia as this bug it thinks there is.) 

So I had to unplug the Nokia and the replug it. This is when the linux usb-storage
oopsed (see below.)

I had to reboot, since all usb related processes hung (like lsusb). 


[98785.107106] usb-storage: device found at 27
[98785.107108] usb-storage: waiting for device to settle before scanning
[98790.104352] usb-storage: device scan complete
[98790.107341] scsi 17:0:0:0: Direct-Access                                    PQ: 0 ANSI: 0
[98790.117331] sd 17:0:0:0: [sdb] 3910526 512-byte hardware sectors (2002 MB)
[98790.121322] sd 17:0:0:0: [sdb] Write Protect is off
[98790.121328] sd 17:0:0:0: [sdb] Mode Sense: 03 00 00 00
[98790.121331] sd 17:0:0:0: [sdb] Assuming drive cache: write through
[98790.131321] sd 17:0:0:0: [sdb] 3910526 512-byte hardware sectors (2002 MB)
[98790.134311] sd 17:0:0:0: [sdb] Write Protect is off
[98790.134315] sd 17:0:0:0: [sdb] Mode Sense: 03 00 00 00
[98790.134319] sd 17:0:0:0: [sdb] Assuming drive cache: write through
[98790.134323]  sdb:<6>usb 6-1: USB disconnect, address 27
[98790.366609] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[98790.366612]  printing eip:
[98790.366614] c02481a9
[98790.366615] *pde = 00000000
[98790.366617] Oops: 0000 [#1]
[98790.366618] SMP 
[98790.366620] Modules linked in: ub nvidia(P) ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt ppp_generic slhc saa7134_alsa ipt_REJECT 8250_pci w83627ehf i2c_isa iptable_filter hidp rfcomm l2cap binfmt_misc nls_iso8859_1 nls_cp437 dm_mirror dm_mod button battery ac lp nvram loop saa7134_dvb tda826x tda10086 tda1004x tda827x snd_hda_intel cx88_dvb cx88_vp3054_i2c mt352 snd_seq_oss snd_seq_midi_event snd_seq dvb_pll or51132 video_buf_dvb nxt200x firmware_class isl6421 zl10353 cx24123 lgdt330x tuner snd_seq_device snd_pcm_oss dvb_core snd_mixer_oss cx22702 snd_pcm saa7134 cx8800 cx8802 cx88xx ir_kbd_i2c ir_common i2c_i801 i2c_algo_bit intel_agp 8250_pnp parport_pc ide_cd 8250 compat_ioctl32 tveeprom r8169 videodev video_buf v4l2_common v4l1_compat btcx_risc i2c_core parport serial_core agpgart hci_usb cdrom snd_timer bluetooth snd soundcore snd_page_alloc pata_jmicron
[98790.366670] CPU:    1
[98790.366670] EIP:    0060:[<c02481a9>]    Tainted: P       VLI
[98790.366671] EFLAGS: 00010202   (2.6.22 #1)
[98790.366677] EIP is at make_class_name+0x27/0x7a
[98790.366679] eax: 00000000   ebx: ffffffff   ecx: ffffffff   edx: 0000000b
[98790.366681] esi: c038d492   edi: 00000000   ebp: 00000000   esp: c22f5e68
[98790.366683] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[98790.366685] Process khubd (pid: 193, ti=c22f4000 task=c21b3030 task.ti=c22f4000)
[98790.366686] Stack: e0e24a08 e0e24a00 c03cb08c c03cb020 e0e24a08 c02482e0 00000000 e0e24a00 
[98790.366692]        e0e24894 00000282 d35c3800 c024836a e0e24800 c0266062 e0e24800 c842e000 
[98790.366697]        c0263f47 c842e030 c842e000 c025fe25 c842e304 f787c818 c03cd3e0 c02954ec 
[98790.366702] Call Trace:
[98790.366708]  [<c02482e0>] class_device_del+0x88/0x10a
[98790.366714]  [<c024836a>] class_device_unregister+0x8/0x10
[98790.366718]  [<c0266062>] __scsi_remove_device+0x23/0x60
[98790.366724]  [<c0263f47>] scsi_forget_host+0x2d/0x4a
[98790.366729]  [<c025fe25>] scsi_remove_host+0x65/0xd8
[98790.366733]  [<c02954ec>] storage_disconnect+0xe/0x16
[98790.366738]  [<c0283a79>] usb_unbind_interface+0x44/0x85
[98790.366743]  [<c0247a67>] __device_release_driver+0x6e/0x8b
[98790.366747]  [<c0247df5>] device_release_driver+0x23/0x39
[98790.366751]  [<c024744e>] bus_remove_device+0x6a/0x7a
[98790.366755]  [<c0245c29>] device_del+0x1d7/0x248
[98790.366760]  [<c02815df>] usb_disable_device+0x5c/0xbb
[98790.366765]  [<c027e214>] usb_disconnect+0x88/0x11e
[98790.366771]  [<c027e90c>] hub_thread+0x379/0xa83
[98790.366776]  [<c03128c7>] __sched_text_start+0x7ef/0x88d
[98790.366785]  [<c012af01>] autoremove_wake_function+0x0/0x35
[98790.366791]  [<c027e593>] hub_thread+0x0/0xa83
[98790.366795]  [<c012ae3b>] kthread+0x38/0x5d
[98790.366798]  [<c012ae03>] kthread+0x0/0x5d
[98790.366801]  [<c010493f>] kernel_thread_helper+0x7/0x10
[98790.366807]  =======================
[98790.366808] Code: 5b 04 5b c3 55 31 ed 57 89 c7 56 89 c6 53 89 e8 83 ec 04 83 cb ff 89 14 24 89 d9 f2 ae f7 d1 49 8b 04 24 89 ca 8b 38 89 d9 89 e8 <f2> ae f7 d1 49 8d 44 0a 02 ba d0 00 00 00 e8 32 1c f1 ff 31 d2 
[98790.366831] EIP: [<c02481a9>] make_class_name+0x27/0x7a SS:ESP 0068:c22f5e68
[98790.366897] sd 17:0:0:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
[98790.366900] end_request: I/O error, dev sdb, sector 0
[98790.366902] printk: 119 messages suppressed.
[98790.366904] Buffer I/O error on device sdb, logical block 0
[98790.366906] Buffer I/O error on device sdb, logical block 1
[98790.366908] Buffer I/O error on device sdb, logical block 2
[98790.366910] Buffer I/O error on device sdb, logical block 3
[98790.366922] Buffer I/O error on device sdb, logical block 0
[98790.366924] Buffer I/O error on device sdb, logical block 1
[98790.366926] Buffer I/O error on device sdb, logical block 2
[98790.366928] Buffer I/O error on device sdb, logical block 3
[98790.366931]  unable to read partition table
[98790.366963] sd 17:0:0:0: [sdb] Attached SCSI removable disk
[98790.366991] sd 17:0:0:0: Attached scsi generic sg1 type 0
[98790.528907] sd 17:0:0:0: [sdb] READ CAPACITY failed
[98790.528911] sd 17:0:0:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
[98790.528914] sd 17:0:0:0: [sdb] Sense not available.
[98790.528963] sd 17:0:0:0: [sdb] Write Protect is off
[98790.528965] sd 17:0:0:0: [sdb] Mode Sense: 00 00 00 00
[98790.528967] sd 17:0:0:0: [sdb] Assuming drive cache: write through
[98790.529011] sd 17:0:0:0: [sdb] READ CAPACITY failed
[98790.529013] sd 17:0:0:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
[98790.529015] sd 17:0:0:0: [sdb] Sense not available.
[98790.529044] sd 17:0:0:0: [sdb] Write Protect is off
[98790.529046] sd 17:0:0:0: [sdb] Mode Sense: 00 00 00 00
[98790.529047] sd 17:0:0:0: [sdb] Assuming drive cache: write through
[98790.630328] sd 17:0:0:0: [sdb] READ CAPACITY failed
[98790.630333] sd 17:0:0:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
[98790.630337] sd 17:0:0:0: [sdb] Sense not available.
[98790.630399] sd 17:0:0:0: [sdb] Write Protect is off
[98790.630402] sd 17:0:0:0: [sdb] Mode Sense: 00 00 00 00
[98790.630404] sd 17:0:0:0: [sdb] Assuming drive cache: write through
[98790.630470] sd 17:0:0:0: [sdb] READ CAPACITY failed
[98790.630473] sd 17:0:0:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
[98790.630477] sd 17:0:0:0: [sdb] Sense not available.
[98790.630519] sd 17:0:0:0: [sdb] Write Protect is off
[98790.630522] sd 17:0:0:0: [sdb] Mode Sense: 00 00 00 00
[98790.630525] sd 17:0:0:0: [sdb] Assuming drive cache: write through



-- v -- 

v@iki.fi

