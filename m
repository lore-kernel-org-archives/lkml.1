Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbZHHR62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbZHHR62 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 13:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZHHR61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 13:58:27 -0400
Received: from ppp-145-222.adsl.restena.lu ([158.64.145.222]:55721 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbZHHR60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 13:58:26 -0400
X-Greylist: delayed 628 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Aug 2009 13:58:25 EDT
Date: Sat, 8 Aug 2009 19:47:33 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.31-rc5 regression: Oops when USB Serial disconnected while in
 use
Message-ID: <20090808194733.38406075@neptune.home>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried bisecting this but bisect did end up on a fully unrelated commit
(which is not even being compiled into my kernel).
Possibly the failed bisect could be related to mis-classified kernel
panic/hang while pulling the USB cable (there were two such panics for the
whole iteration)?

There are quite a few patches touching tty, ttyUSB and friends between
rc4 and now so pretty hard to guess on the correct one.

The oops always happens when I disconnect the USB serial console (here
the one built into Marvell SheevaPlug) while having minicom connected
to it.
During the bisection for the last few bad iterations minicom got killed
(segfault), the bad ones on the iteration left a minicom zombie in 'D'
state.

Regards,
Bruno


In case if can be of some use, here is the bisect log:
git bisect start
# bad: [cf265c2c5df57b0025713791cab06cc685eb3bfe] Revert "Subject: [PATCH V2] drm/i915: Detect lvds channel according to fixed mode line"
git bisect bad cf265c2c5df57b0025713791cab06cc685eb3bfe
# good: [4be3bd7849165e7efa6b0b35a23d6a3598d97465] Linux 2.6.31-rc4
git bisect good 4be3bd7849165e7efa6b0b35a23d6a3598d97465
# good: [4be3bd7849165e7efa6b0b35a23d6a3598d97465] Linux 2.6.31-rc4
git bisect good 4be3bd7849165e7efa6b0b35a23d6a3598d97465
# bad: [3822a0e38c329a598cb6f5baa16be7504e0db8d9] mmc: orphan subsystem
git bisect bad 3822a0e38c329a598cb6f5baa16be7504e0db8d9
# bad: [7d084d96fdf1d791cb171da57efc1ca89d68dd6c] libata: Updates and fixes for pata_at91 driver
git bisect bad 7d084d96fdf1d791cb171da57efc1ca89d68dd6c
# good: [6a31d4aeab85a02f9a57ca37b935054393daa794] Merge branch 'fixes-for-linus' of git://git.monstr.eu/linux-2.6-microblaze
git bisect good 6a31d4aeab85a02f9a57ca37b935054393daa794
# bad: [f1462147f15a954a1a0553390846c6fa3ca742b1] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
git bisect bad f1462147f15a954a1a0553390846c6fa3ca742b1
# bad: [d14a7679ae9b7d4eb4b92e81f5039b719fd98c4d] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6
git bisect bad d14a7679ae9b7d4eb4b92e81f5039b719fd98c4d
# bad: [7adfd5c71693b81e995283805b17aa4a2ee0ecd9] rt2x00: Fix chipset detection for rt2500usb
git bisect bad 7adfd5c71693b81e995283805b17aa4a2ee0ecd9
# bad: [48ab3578a65c5168ecaaa3b21292b643b7bcc2d5] rfkill: fix rfkill_set_states() to set the hw state
git bisect bad 48ab3578a65c5168ecaaa3b21292b643b7bcc2d5
# bad: [7b80ece41aea0b73283c6df5a8f25d40aa13135d] iwlwifi: only update byte count table during aggregation
git bisect bad 7b80ece41aea0b73283c6df5a8f25d40aa13135d
# bad: [872ed1902f511a8947021c562f5728a5bf0640b5] iwlwifi: only show active power level via sysfs
git bisect bad 872ed1902f511a8947021c562f5728a5bf0640b5
# bad: [513a2396d8e8327aff1ce50bea3fb4f16ff3455b] iwmc3200wifi: fix NULL pointer dereference in iwm_if_free
git bisect bad 513a2396d8e8327aff1ce50bea3fb4f16ff3455b


[ 1638.060039] usb 1-2: new full speed USB device using uhci_hcd and address 2
[ 1638.278185] usb 1-2: New USB device found, idVendor=9e88, idProduct=9e8f
[ 1638.278195] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 1638.278204] usb 1-2: Product: SheevaPlug JTAGKey FT2232D B
[ 1638.278210] usb 1-2: Manufacturer: FTDI
[ 1638.278216] usb 1-2: SerialNumber: FTS55QK6
[ 1638.278444] usb 1-2: configuration #1 chosen from 1 choice
[ 1638.760727] usbcore: registered new interface driver usbserial
[ 1638.760732] usbserial: USB Serial Driver core
[ 1638.772202] USB Serial support registered for FTDI USB Serial Device
[ 1638.772318] usb 1-2: Ignoring serial port reserved for JTAG
[ 1638.772374] ftdi_sio 1-2:1.1: FTDI USB Serial Device converter detected
[ 1638.772414] usb 1-2: Detected FT2232C
[ 1638.772417] usb 1-2: Number of endpoints 2
[ 1638.772420] usb 1-2: Endpoint 1 MaxPacketSize 64
[ 1638.772423] usb 1-2: Endpoint 2 MaxPacketSize 64
[ 1638.772426] usb 1-2: Setting MaxPacketSize 64
[ 1638.774239] usb 1-2: FTDI USB Serial Device converter now attached to ttyUSB0
[ 1638.774268] usbcore: registered new interface driver ftdi_sio
[ 1638.774271] ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
[ 1761.750059] usb 1-2: USB disconnect, address 2
[ 1761.750475] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
[ 1761.750505] ftdi_sio 1-2:1.1: device disconnected
[ 1761.751734] tty_port_close_start: count = -1
[ 1769.392487] BUG: unable to handle kernel paging request at 61762056
[ 1769.392742] IP: [<de765d28>] serial_do_free+0x38/0x80 [usbserial]
[ 1769.392979] *pde = 00000000 
[ 1769.393101] Oops: 0000 [#1] 
[ 1769.393223] last sysfs file: /sys/devices/virtual/hwmon/hwmon0/temp1_input
[ 1769.393468] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec nsc_ircc ac97_bus snd_pcm snd_timer i2c_i801 pcspkr irda snd snd_page_alloc ehci_hcd uhci_hcd crc_ccitt usbcore
[ 1769.394814] 
[ 1769.394890] Pid: 2588, comm: minicom Tainted: G   M       (2.6.31-rc5 #2) TravelMate 660
[ 1769.395144] EIP: 0060:[<de765d28>] EFLAGS: 00010246 CPU: 0
[ 1769.395344] EIP is at serial_do_free+0x38/0x80 [usbserial]
[ 1769.395519] EAX: 6176203a EBX: daad3000 ECX: de765d70 EDX: daad3a00
[ 1769.395747] ESI: daad3038 EDI: 00000000 EBP: dc397e24 ESP: dc397e18
[ 1769.395945]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[ 1769.396135] Process minicom (pid: 2588, ti=dc397000 task=dd8e46a0 task.ti=dc397000)
[ 1769.396374] Stack:
[ 1769.396458]  daad3a00 dc37e400 00000000 dc397e4c de765dd6 00000000 dc397e4c c115cf85
[ 1769.396835] <0> dc37e4a0 dc383d80 dc37e400 00000000 00000000 dc397edc c115f0c0 00000001
[ 1769.397256] <0> 00000002 c15a8380 dc383d80 00000000 00000000 c18541c0 40000000 00000000
[ 1769.397689] Call Trace:
[ 1769.397799]  [<de765dd6>] ? serial_close+0x66/0xa0 [usbserial]
[ 1769.397992]  [<c115cf85>] ? tty_fasync+0x55/0xe0
[ 1769.398163]  [<c115f0c0>] ? tty_release_dev+0x130/0x490
[ 1769.398339]  [<c1056b82>] ? put_page+0x42/0x120
[ 1769.398507]  [<c10895b6>] ? mntput_no_expire+0x16/0x60
[ 1769.398675]  [<c115f42a>] ? tty_release+0xa/0x10
[ 1769.398844]  [<c1075d2c>] ? __fput+0xdc/0x1d0
[ 1769.398987]  [<c1075e3f>] ? fput+0x1f/0x30
[ 1769.399142]  [<c1072d9e>] ? filp_close+0x3e/0x70
[ 1769.399297]  [<c1024dd2>] ? put_files_struct+0xa2/0xc0
[ 1769.399481]  [<c1024e0c>] ? exit_files+0x1c/0x20
[ 1769.399633]  [<c1026169>] ? do_exit+0xb9/0x630
[ 1769.399798]  [<c103aab8>] ? __put_cred+0x18/0x20
[ 1769.399950]  [<c102670d>] ? do_group_exit+0x2d/0x80
[ 1769.400145]  [<c1026773>] ? sys_exit_group+0x13/0x20
[ 1769.400309]  [<c1002e08>] ? sysenter_do_call+0x12/0x26
[ 1769.400488] Code: 24 04 89 7c 24 08 80 b8 b6 00 00 00 00 74 14 8b 1c 24 8b 74 24 04 8b 7c 24 08 89 ec 5d c3 90 8d 74 26 00 8b 18 8b 43 04 8d 73 38 <8b> 78 1c 8d 82 bc 00 00 00 e8 1a c1 a4 e2 89 f0 e8 33 1d b5 e2 
[ 1769.402352] EIP: [<de765d28>] serial_do_free+0x38/0x80 [usbserial] SS:ESP 0068:dc397e18
[ 1769.402649] CR2: 0000000061762056
[ 1769.402775] ---[ end trace e6175462c2b3a1ba ]---
[ 1769.402923] Fixing recursive fault but reboot is needed!
