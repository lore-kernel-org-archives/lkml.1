Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbXF2CDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbXF2CDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 22:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764132AbXF2CDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 22:03:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:34829 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765049AbXF2CC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 22:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VVzmZ3kCFIg2f22aQvYNU8DROGPMXaunzThm2t/XmD5Ym3389i7L8WRXL7Dxz3vbbWKe1niXVb/wbyF8f9RnJTpJQLsFwE4eeDEIa7fmnYsDQa8D0f2DCRQT85Qv1MRDooladWX4BNpefTVh5VldwVU0meevUZHhqMV2wL5JFWE=
Message-ID: <b08af10f0706281902u519434edu5cff3de50cc1f1ad@mail.gmail.com>
Date: Thu, 28 Jun 2007 23:02:57 -0300
From: "Sean Watkins" <sean.watkins@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG: sleeping function called from invalid context at mm/mempool.c:210
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.20-1.2962.fc6 #1 SMP

When capturing video, and doing a recompile of a sofware application
(heavy disk load) things go pear shaped:

...
Jun 28 13:17:16 emachine kernel: ivtv0: Cause: the application is not
reading fast enough.
Jun 28 13:17:39 emachine kernel: ivtv0: All encoder MPEG stream
buffers are full. Dropping data.
Jun 28 13:17:39 emachine kernel: ivtv0: Cause: the application is not
reading fast enough
...
Jun 28 13:17:45 emachine kernel: BUG: sleeping function called from
invalid context at mm/mempool.c:210
Jun 28 13:17:45 emachine kernel: in_atomic():1, irqs_disabled():0
Jun 28 13:17:45 emachine kernel:  [<c0458f34>] mempool_alloc+0x1f/0xd5
Jun 28 13:17:45 emachine kernel:  [<c04e5807>] cfq_find_cfq_hash+0x18/0x1b
Jun 28 13:17:45 emachine kernel: BUG: unable to handle kernel paging
request at virtual address 31312031
Jun 28 13:17:45 emachine kernel:  printing eip:
Jun 28 13:17:45 emachine kernel: c0404fb2
Jun 28 13:17:45 emachine kernel: *pde = 00000000
Jun 28 13:17:45 emachine kernel: Oops: 0000 [#1]
Jun 28 13:17:45 emachine kernel: SMP
Jun 28 13:17:45 emachine kernel: SMP
Jun 28 13:17:45 emachine kernel: last sysfs file:
/devices/pci0000:00/0000:00:00.0/irq
Jun 28 13:17:45 emachine kernel: Modules linked in: nfsd exportfs
lockd nfs_acl ppdev vmnet(P)(U) vmmon(P)(U) sunrpc xfs video sbs
i2c_ec
 dock button battery asus_acpi backlight ac ipv6 lp cx8800 cx88xx bttv
video_buf ir_common compat_ioctl32 btcx_risc lirc_i2c(F)(U) lirc_d
ev(F)(U) msp3400 saa7115 tuner snd_hda_intel snd_hda_codec
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq ohci1394
snd_seq_device f
tdi_sio ieee1394 snd_pcm_oss snd_mixer_oss usbserial sg nvidia(PF)(U)
snd_pcm i2c_i801 ivtv(F)(U) i2c_algo_bit ide_cd e100 snd_timer cx23
41x mii serio_raw snd pcspkr soundcore parport_pc tveeprom i2c_core
cdrom parport snd_page_alloc videodev v4l2_common v4l1_compat dm_snap
shot dm_zero dm_mirror dm_mod usb_storage ata_piix libata sd_mod
scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
Jun 28 13:17:45 emachine kernel: CPU:    1
Jun 28 13:49:01 emachine kernel: EIP:    0060:[<c0404fb2>]    Tainted:
PF     VLI
Jun 28 13:49:01 emachine kernel: EFLAGS: 00210293   (2.6.20-1.2962.fc6 #1)
Jun 28 13:49:01 emachine kernel: EIP is at dump_trace+0x5c/0x93
Jun 28 13:49:01 emachine kernel: eax: 31312ffd   ebx: 31312031   ecx:
003534a7   edx: 0128e400
Jun 28 13:49:01 emachine kernel: esi: f7f80be4   edi: 31312000   ebp:
c06b2429   esp: ef964fb0
Jun 28 13:49:01 emachine kernel: ds: 007b   es: 007b   ss: 0068
Jun 28 13:49:01 emachine kernel: Process mythbackend (pid: 3105,
ti=ef964000 task=f6717230 task.ti=ef965000)
Jun 28 13:49:01 emachine kernel: Stack: c06af6b8 c06b2429 f7f92d40
f7f80bf4 00000000 c0405001 c06fdc40 c06b2429
Jun 28 13:49:01 emachine kernel:        00000010 c040558f c06b2429
c0405601 00000000 c0458f34 00000000 f7f80bf4
Jun 28 13:49:01 emachine kernel:        c04e5807 e4d66a7c 00000000 f7f80be4
Jun 28 13:49:01 emachine kernel: Call Trace:
Jun 28 13:49:01 emachine kernel:  [<c0405001>] show_trace_log_lvl+0x18/0x2c
Jun 28 13:49:01 emachine kernel:  [<c040558f>] show_trace+0xf/0x11
Jun 28 13:49:01 emachine kernel:  [<c0405601>] dump_stack+0x12/0x14
Jun 28 13:49:01 emachine kernel:  [<c0458f34>] mempool_alloc+0x1f/0xd5
Jun 28 13:49:01 emachine kernel:  [<c04e5807>] cfq_find_cfq_hash+0x18/0x1b
Jun 28 13:49:02 emachine kernel: BUG: unable to handle kernel paging
request at virtual address 31312031
Jun 28 13:49:02 emachine kernel:  printing eip:
Jun 28 13:49:02 emachine kernel: c0404fb2
Jun 28 13:49:02 emachine kernel: *pde = 00000000
Jun 28 13:49:02 emachine kernel: Oops: 0000 [#2]
Jun 28 13:49:02 emachine kernel: SMP

which then cascades into more and more crashes
Jun 28 13:49:02 emachine kernel: SMP
Jun 28 13:49:02 emachine kernel: last sysfs file:
/devices/pci0000:00/0000:00:00.0/irq
Jun 28 13:49:02 emachine kernel: Modules linked in: nfsd exportfs
lockd nfs_acl ppdev vmnet(P)(U) vmmon(P)(U) sunrpc xfs video sbs
i2c_ec
 dock button battery asus_acpi backlight ac ipv6 lp cx8800 cx88xx bttv
video_buf ir_common compat_ioctl32 btcx_risc lirc_i2c(F)(U) lirc_d
ev(F)(U) msp3400 saa7115 tuner snd_hda_intel snd_hda_codec
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq ohci1394
snd_seq_device f
tdi_sio ieee1394 snd_pcm_oss snd_mixer_oss usbserial sg nvidia(PF)(U)
snd_pcm i2c_i801 ivtv(F)(U) i2c_algo_bit ide_cd e100 snd_timer cx23
41x mii serio_raw snd pcspkr soundcore parport_pc tveeprom i2c_core
cdrom parport snd_page_alloc videodev v4l2_common v4l1_compat dm_snap
shot dm_zero dm_mirror dm_mod usb_storage ata_piix libata sd_mod
scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
Jun 28 13:49:02 emachine kernel: CPU:    1
Jun 28 13:49:02 emachine kernel: EIP:    0060:[<c0404fb2>]    Tainted:
PF     VLI
Jun 28 13:49:02 emachine kernel: EFLAGS: 00210093   (2.6.20-1.2962.fc6 #1)
Jun 28 13:49:02 emachine kernel: EIP is at dump_trace+0x5c/0x93
Jun 28 13:49:02 emachine kernel: eax: 31312ffd   ebx: 31312031   ecx:
003534a8   edx: 0128e400
Jun 28 13:49:02 emachine kernel: esi: f7f80be4   edi: 31312000   ebp:
c06a64f2   esp: ef964e70
Jun 28 13:49:02 emachine kernel: ds: 007b   es: 007b   ss: 0068
Jun 28 13:49:02 emachine kernel: Process mythbackend (pid: 3105,
ti=ef964000 task=f6717230 task.ti=ef965000)
Jun 28 13:49:02 emachine kernel: Stack: c06a64f2 c06a64f2 00000014
00000000 c06a64f2 c0405001 c06fdc40 c06a64f2
Jun 28 13:49:02 emachine kernel:        ef965003 c04050b0 c06a64f2
c06a64f2 ef964f78 ef964fb0 00000002 00210293
Jun 28 13:49:02 emachine kernel:        ef964f78 ef964fb0 c0405246
c06a64f2 00000010 f67173c4 00000c21 ef964000
Jun 28 13:49:02 emachine kernel: Call Trace:
Jun 28 13:49:02 emachine kernel:  [<c0405001>] show_trace_log_lvl+0x18/0x2c
Jun 28 13:49:02 emachine kernel:  [<c04050b0>] show_stack_log_lvl+0x9b/0xa3
Jun 28 13:49:02 emachine kernel:  [<c0405246>] show_registers+0x18e/0x25d
Jun 28 13:49:02 emachine kernel:  [<c062241f>] notifier_call_chain+0x19/0x29
Jun 28 13:49:02 emachine kernel:  [<c0405443>] die+0x12e/0x240
Jun 28 13:49:03 emachine kernel:  [<c0622333>] do_page_fault+0x407/0x4da
Jun 28 13:49:04 emachine kernel:  [<c0621f2c>] do_page_fault+0x0/0x4da
Jun 28 13:49:05 emachine kernel:  [<c0620b94>] error_code+0x7c/0x84
Jun 28 13:49:06 emachine kernel:  [<c0404fb2>] dump_trace+0x5c/0x93
Jun 28 13:49:06 emachine kernel:  [<c0405001>] show_trace_log_lvl+0x18/0x2c
Jun 28 13:49:06 emachine kernel:  [<c040558f>] show_trace+0xf/0x11
Jun 28 13:49:06 emachine kernel:  [<c0405601>] dump_fault+0x407/0x4da
Jun 28 13:49:06 emachine kernel:  [<c0621f2c>] do_page_fault+0x0/0x4da
Jun 28 13:49:06 emachine kernel:  [<c0620b94>] error_code+0x7c/0x84
Jun 28 13:49:06 emachine kernel:  [<c0404fb2>] dump_trace+0x5c/0x93
Jun 28 13:49:06 emachine kernel:  [<c0405001>] show_trace_log_lvl+0x18/0x2c
:

and so on...

ideas?



[root@emachine log]# lspci
00:00.0 Host bridge: Intel Corporation 82945G/GZ/P/PL Memory
Controller Hub (rev 02)
00:01.0 PCI bridge: Intel Corporation 82945G/GZ/P/PL PCI Express Root
Port (rev 02)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 01)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 01)
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 3 (rev 01)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 4 (rev 01)
00:1c.4 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI
Express Port 5 (rev 01)
00:1c.5 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI
Express Port 6 (rev 01)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GH (ICH7DH) LPC Interface
Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 01)
00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family)
Serial ATA Storage Controller IDE (rev 01)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
01:00.0 VGA compatible controller: nVidia Corporation GeForce 7300 LE (rev a1)
07:00.0 FireWire (IEEE 1394): Texas Instruments TSB12LV26 IEEE-1394
Controller (Link)
07:01.0 Multimedia video controller: Internext Compression Inc iTVC15
MPEG-2 Encoder (rev 01)
07:08.0 Ethernet controller: Intel Corporation Unknown device 1094 (rev 01)
[root@emachine log]#
