Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZHXU0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZHXU0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 16:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZHXU0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 16:26:13 -0400
Received: from ppp-145-226.adsl.restena.lu ([158.64.145.226]:49450 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZHXU0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 16:26:12 -0400
X-Greylist: delayed 635 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Aug 2009 16:26:11 EDT
Date: Mon, 24 Aug 2009 22:15:08 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090824221508.055cfbc6@neptune.home>
In-Reply-To: <Pine.LNX.4.44L0.0908232109400.30663-100000@netrider.rowland.org>
References: <20090823183058.01fa4700@neptune.home>
	<Pine.LNX.4.44L0.0908232109400.30663-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 August 2009 Alan Stern <stern@rowland.harvard.edu> wrote:

> On Sun, 23 Aug 2009, Bruno [UTF-8] PrÃ©mont wrote:
> 
> > On Sun, 23 August 2009 Alan Stern <stern@rowland.harvard.edu> wrote:
> > > I have a big patch almost ready for testing.  Unfortunately I
> > > don't have access to my usual hardware right now, so I can't test
> > > it until the middle of the week.  Bruno, if you like I will send
> > > you the patch when it looks okay and you can try it out.
> > 
> > Fine for me, I can test every week-day during evening as well as
> > during week-end (European time, UTC+2).
> > If there are any specific tests (other than the surviving of
> > disconnect) that I shall run, just ask!
> 
> Here it is.  This is meant to apply on top of gregkh-all-2.6.31-rc6;  
> it replaces the small patch you tried earlier.  In fact this ought to
> be split up into at least four individual patches, but you can test it
> all in one piece.
> 
> Surviving disconnect, ability to reconnect, deallocating memory 
> (destroy_serial and port_free) at the right time...  Anything else
> you can think of.
> 
> Alan Stern
> 
> P.S.: You may already have the first part, with the changes to
> tty_port.c.
Yep, that one was already included


The patch does not work properly:

When I plug in the USB2serial converter (be it ftdi or pl2302) device
node is created properly and minicom can use it.

When I exit minicom I can no longer start it again, eventually I get
a killed minicom with NULL-dereference

A rmmod/modprobe cycle works but the end result is no device node
created by udev and udev's path_id helper is stuck. (unable to
determine where for now as netconsole causes trouble with netdev
polling)
I will have a deeper look tomorrow as this evening is already over.

Bruno


Trace result for ftdi device:
[   75.620038] usb 1-2: new full speed USB device using uhci_hcd and address 2
[   75.838941] usb 1-2: New USB device found, idVendor=9e88, idProduct=9e8f
[   75.844208] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   75.849432] usb 1-2: Product: SheevaPlug JTAGKey FT2232D B
[   75.854628] usb 1-2: Manufacturer: FTDI
[   75.859783] usb 1-2: SerialNumber: FTS55QK6
[   75.866989] usb 1-2: configuration #1 chosen from 1 choice
[   76.001724] usbcore: registered new interface driver usbserial
[   76.006901] usbserial: USB Serial Driver core
[   76.085962] USB Serial support registered for FTDI USB Serial Device
[   76.091471] usb 1-2: Ignoring serial port reserved for JTAG
[   76.093889] ftdi_sio 1-2:1.1: FTDI USB Serial Device converter detected
[   76.096350] usb 1-2: Detected FT2232C
[   76.098739] usb 1-2: Number of endpoints 2
[   76.101418] usb 1-2: Endpoint 1 MaxPacketSize 64
[   76.103792] usb 1-2: Endpoint 2 MaxPacketSize 64
[   76.106153] usb 1-2: Setting MaxPacketSize 64
[   76.111012] usb 1-2: FTDI USB Serial Device converter now attached to ttyUSB0
[   76.113433] usbcore: registered new interface driver ftdi_sio
[   76.115797] ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
[  163.471333] BUG: unable to handle kernel NULL pointer dereference at 00000064
[  163.471531] IP: [<c115f7ae>] tty_open+0x11e/0x4b0
[  163.471650] *pde = 00000000 
[  163.471730] Oops: 0000 [#1] 
[  163.471809] last sysfs file: /sys/devices/virtual/hwmon/hwmon0/temp1_input
[  163.471944] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop usb_storage snd_intel8x0 nsc_ircc snd_ac97_codec ac97_bus irda snd_pcm snd_timer snd snd_page_alloc ehci_hcd pcspkr i2c_i801 uhci_hcd usbcore crc_ccitt
[  163.472927] 
[  163.472967] Pid: 2157, comm: minicom Tainted: G   M       (2.6.31-rc6-gregkh #2) TravelMate 660
[  163.473148] EIP: 0060:[<c115f7ae>] EFLAGS: 00010246 CPU: 0
[  163.473247] EIP is at tty_open+0x11e/0x4b0
[  163.473338] EAX: dba89000 EBX: dbdb2480 ECX: 00000000 EDX: 00000000
[  163.473449] ESI: dd24d400 EDI: 0bc00000 EBP: db646e70 ESP: db646e4c
[  163.473575]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  163.473673] Process minicom (pid: 2157, ti=db646000 task=dd9ae7c0 task.ti=db646000)
[  163.473833] Stack:
[  163.473873]  dbdb2484 dbe24e00 dba8e67c 00000902 00000100 00000000 00000000 dbdb2488
[  163.474133] <0> dba8e67c db646e8c c1077246 dbe24e00 db646e98 dbe24e00 dba8e67c 00000000
[  163.474431] <0> db646ea8 c1072fdf dd8afb00 dd524f00 dbe24e00 db646ef4 dbe24e00 db646ec4
[  163.474751] Call Trace:
[  163.474808]  [<c1077246>] ? chrdev_open+0x96/0x140
[  163.474918]  [<c1072fdf>] ? __dentry_open+0x9f/0x250
[  163.475012]  [<c1073279>] ? nameidata_to_filp+0x59/0x70
[  163.475124]  [<c10771b0>] ? chrdev_open+0x0/0x140
[  163.475214]  [<c107f569>] ? do_filp_open+0x269/0x890
[  163.475324]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  163.475417]  [<c1072da7>] ? do_sys_open+0x57/0x140
[  163.475525]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  163.475619]  [<c1072ef9>] ? sys_open+0x29/0x40
[  163.475719]  [<c1002e08>] ? sysenter_do_call+0x12/0x26
[  163.475811] Code: d0 89 45 f0 8d 43 04 89 45 dc e8 9e f7 f9 ff 85 db 74 ca 85 f6 0f 84 22 02 00 00 80 be 84 00 00 00 00 8b 56 08 0f 88 32 01 00 00 <66> 83 7a 64 04 75 0b 66 83 7a 66 01 0f 84 05 01 00 00 ff 86 88 
[  163.477244] EIP: [<c115f7ae>] tty_open+0x11e/0x4b0 SS:ESP 0068:db646e4c
[  163.477410] CR2: 0000000000000064
[  163.477472] ---[ end trace e2a30538356d938d ]---

# Plug-in
# minicom
# exit minicom
# minicom
#   (it can't open serial port & exits)
# minicom
#   -> havok
# rmmod + modprobe
# minicom
#   (ad infinitum as no dev node,
#    udev fails to recreate device node: hangs on path_id)



Similar results for pl2302:
[   69.260039] usb 1-1: new full speed USB device using uhci_hcd and address 2
[   69.426990] usb 1-1: New USB device found, idVendor=067b, idProduct=2303
[   69.427000] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   69.427008] usb 1-1: Product: USB-Serial Controller
[   69.427015] usb 1-1: Manufacturer: Prolific Technology Inc.
[   69.427242] usb 1-1: configuration #1 chosen from 1 choice
[   69.558897] usbcore: registered new interface driver usbserial
[   69.558906] usbserial: USB Serial Driver core
[   69.612215] USB Serial support registered for pl2303
[   69.612267] pl2303 1-1:1.0: pl2303 converter detected
[   69.624165] usb 1-1: pl2303 converter now attached to ttyUSB0
[   69.624205] usbcore: registered new interface driver pl2303
[   69.624211] pl2303: Prolific PL2303 USB to serial adaptor driver
[  140.790070] usb 1-1: USB disconnect, address 2
[  140.793165] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[  140.796051] pl2303 1-1:1.0: device disconnected
[  147.280036] usb 1-1: new full speed USB device using uhci_hcd and address 3
[  147.446990] usb 1-1: New USB device found, idVendor=067b, idProduct=2303
[  147.449674] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  147.452428] usb 1-1: Product: USB-Serial Controller
[  147.455149] usb 1-1: Manufacturer: Prolific Technology Inc.
[  147.459847] usb 1-1: configuration #1 chosen from 1 choice
[  147.466047] pl2303 1-1:1.0: pl2303 converter detected
[  147.479158] usb 1-1: pl2303 converter now attached to ttyUSB0
[  168.770687] BUG: unable to handle kernel paging request at 697665c8
[  168.770876] IP: [<c115f7ae>] tty_open+0x11e/0x4b0
[  168.770995] *pde = 00000000 
[  168.771075] Oops: 0000 [#1] 
[  168.771154] last sysfs file: /sys/devices/virtual/hwmon/hwmon0/temp1_input
[  168.771304] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop usb_storage snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer ehci_hcd snd uhci_hcd usbcore pcspkr snd_page_alloc nsc_ircc i2c_i801 irda crc_ccitt
[  168.772283] 
[  168.772322] Pid: 2166, comm: minicom Tainted: G   M       (2.6.31-rc6-gregkh #2) TravelMate 660
[  168.772503] EIP: 0060:[<c115f7ae>] EFLAGS: 00010202 CPU: 0
[  168.772602] EIP is at tty_open+0x11e/0x4b0
[  168.772694] EAX: db661800 EBX: db07c6c0 ECX: 00000000 EDX: 69766564
[  168.772804] ESI: db17e000 EDI: 0bc00000 EBP: db17ae70 ESP: db17ae4c
[  168.772944]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  168.773041] Process minicom (pid: 2166, ti=db17a000 task=dd9ae7c0 task.ti=db17a000)
[  168.773202] Stack:
[  168.773242]  db07c6c4 dd07d200 dd33c4f4 00000902 00000100 00000000 00000000 db07c6c8
[  168.773502] <0> dd33c4f4 db17ae8c c1077246 dd07d200 00000000 dd07d200 dd33c4f4 00000000
[  168.773799] <0> db17aea8 c1072fdf dd8d2680 dd502e80 dd07d200 db17aef4 dd07d200 db17aec4
[  168.774120] Call Trace:
[  168.774177]  [<c1077246>] ? chrdev_open+0x96/0x140
[  168.774287]  [<c1072fdf>] ? __dentry_open+0x9f/0x250
[  168.774380]  [<c1073279>] ? nameidata_to_filp+0x59/0x70
[  168.774492]  [<c10771b0>] ? chrdev_open+0x0/0x140
[  168.774582]  [<c107f569>] ? do_filp_open+0x269/0x890
[  168.774691]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  168.774784]  [<c1072da7>] ? do_sys_open+0x57/0x140
[  168.774893]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  168.774987]  [<c1072ef9>] ? sys_open+0x29/0x40
[  168.775088]  [<c1002e08>] ? sysenter_do_call+0x12/0x26
[  168.775180] Code: d0 89 45 f0 8d 43 04 89 45 dc e8 9e f7 f9 ff 85 db 74 ca 85 f6 0f 84 22 02 00 00 80 be 84 00 00 00 00 8b 56 08 0f 88 32 01 00 00 <66> 83 7a 64 04 75 0b 66 83 7a 66 01 0f 84 05 01 00 00 ff 86 88 
[  168.776606] EIP: [<c115f7ae>] tty_open+0x11e/0x4b0 SS:ESP 0068:db17ae4c
[  168.776772] CR2: 00000000697665c8
[  168.776836] ---[ end trace f7ba75fd75a3f993 ]---


For both cases EIP is at:
  drivers/char/tty_io.c:1253:
1246:static int tty_reopen(struct tty_struct *tty)
1247:{
1248:	struct tty_driver *driver = tty->driver;
...
1253:	if (driver->type == TTY_DRIVER_TYPE_PTY &&
1254:	    driver->subtype == PTY_TYPE_MASTER) {
