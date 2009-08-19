Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbZHSRcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbZHSRcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 13:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZHSRcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 13:32:02 -0400
Received: from ppp-145-186.adsl.restena.lu ([158.64.145.186]:33905 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZHSRb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 13:31:59 -0400
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Aug 2009 13:31:59 EDT
Date: Wed, 19 Aug 2009 19:22:56 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Greg KH <gregkh@suse.de>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090819192256.0e907b54@neptune.home>
In-Reply-To: <20090818223648.GA25659@suse.de>
References: <20090808194733.38406075@neptune.home>
	<Pine.LNX.4.44L0.0908101114320.3208-100000@iolanthe.rowland.org>
	<20090810154402.GA7701@kroah.com>
	<20090810191822.26370810@neptune.home>
	<20090810181306.GA24989@kroah.com>
	<20090810203501.4d57aa5b@neptune.home>
	<20090810205115.6871239d@neptune.home>
	<20090810192954.GA11651@suse.de>
	<20090818190016.73ce53de@neptune.home>
	<20090818223648.GA25659@suse.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 August 2009 Greg KH <gregkh@suse.de> wrote:
> Yeah, it sounds like it.  More info would be great to have if you can
> get it.

I did try to understand what happens exactly, using backtrace from
kernel compiled with debug info and running objdump on usbserial.ko.


Trace used:
[  593.681350] BUG: unable to handle kernel paging request at 00700128
[  593.681604] IP: [<dea40d28>] serial_do_free+0x38/0x80 [usbserial]
[  593.681842] *pde = 00000000 
[  593.681964] Oops: 0000 [#1] 
[  593.682085] last sysfs file: /sys/devices/virtual/hwmon/hwmon0/temp1_input
[  593.682330] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus nsc_ircc uhci_hcd ehci_hcd irda snd_pcm snd_timer usbcore snd snd_page_alloc pcspkr i2c_i801 crc_ccitt
[  593.683672] 
[  593.683747] Pid: 2209, comm: minicom Tainted: G   M       (2.6.31-rc6 #1) TravelMate 660
[  593.684001] EIP: 0060:[<dea40d28>] EFLAGS: 00010246 CPU: 0
[  593.684200] EIP is at serial_do_free+0x38/0x80 [usbserial]
[  593.684375] EAX: 0070010c EBX: dd1b2e00 ECX: dea40d70 EDX: dd1b2200
[  593.684590] ESI: dd1b2e38 EDI: 00000000 EBP: da050e24 ESP: da050e18
[  593.684787]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  593.684976] Process minicom (pid: 2209, ti=da050000 task=dd9addd0 task.ti=da050000)
[  593.685214] Stack:
[  593.685298]  dd1b2200 dd12fc00 00000000 da050e4c dea40dd6 00000000 da050e4c c115d1a5
[  593.685673] <0> dd12fca0 dd804b00 dd12fc00 00000000 00000000 da050edc c115f2e0 00000001
[  593.686091] <0> 00000002 c17b1200 dd804b00 00000000 00000000 c1850740 40000000 00000000
[  593.686520] Call Trace:
[  593.686631]  [<dea40dd6>] ? serial_close+0x66/0xa0 [usbserial]
[  593.686824]  [<c115d1a5>] ? tty_fasync+0x55/0xe0
[  593.686994]  [<c115f2e0>] ? tty_release_dev+0x130/0x490
[  593.687170]  [<c1056d72>] ? put_page+0x42/0x120
[  593.687339]  [<c10897b6>] ? mntput_no_expire+0x16/0x60
[  593.687505]  [<c115f64a>] ? tty_release+0xa/0x10
[  593.687673]  [<c1075f1c>] ? __fput+0xdc/0x1d0
[  593.687817]  [<c107602f>] ? fput+0x1f/0x30
[  593.687970]  [<c1072f8e>] ? filp_close+0x3e/0x70
[  593.688126]  [<c1024fa2>] ? put_files_struct+0xa2/0xc0
[  593.688310]  [<c1024fdc>] ? exit_files+0x1c/0x20
[  593.688462]  [<c1026339>] ? do_exit+0xb9/0x630
[  593.688628]  [<c103acd8>] ? __put_cred+0x18/0x20
[  593.688780]  [<c10268dd>] ? do_group_exit+0x2d/0x80
[  593.688957]  [<c1026943>] ? sys_exit_group+0x13/0x20
[  593.689119]  [<c1002e08>] ? sysenter_do_call+0x12/0x26
[  593.689298] Code: 24 04 89 7c 24 08 80 b8 b6 00 00 00 00 74 14 8b 1c 24 8b 74 24 04 8b 7c 24 08 89 ec 5d c3 90 8d 74 26 00 8b 18 8b 43 04 8d 73 38 <8b> 78 1c 8d 82 bc 00 00 00 e8 fa 13 77 e2 89 f0 e8 33 70 87 e2 
[  593.691175] EIP: [<dea40d28>] serial_do_free+0x38/0x80 [usbserial] SS:ESP 0068:da050e18
[  593.691473] CR2: 0000000000700128
[  593.691600] ---[ end trace bf5aabaeba706ceb ]---


Objdump (objdump -l -D usbserial.ko) result for serial_do_free:

00000cf0 <serial_do_free>:
serial_do_free():
/usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:322
     cf0:       55                      push   %ebp
     cf1:       89 c2                   mov    %eax,%edx
     cf3:       89 e5                   mov    %esp,%ebp
     cf5:       83 ec 0c                sub    $0xc,%esp
     cf8:       89 1c 24                mov    %ebx,(%esp)
     cfb:       89 74 24 04             mov    %esi,0x4(%esp)
     cff:       89 7c 24 08             mov    %edi,0x8(%esp)
/usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:328
     d03:       80 b8 b6 00 00 00 00    cmpb   $0x0,0xb6(%eax)
     d0a:       74 14                   je     d20 <serial_do_free+0x30>
/usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:342
     d0c:       8b 1c 24                mov    (%esp),%ebx
     d0f:       8b 74 24 04             mov    0x4(%esp),%esi
     d13:       8b 7c 24 08             mov    0x8(%esp),%edi
     d17:       89 ec                   mov    %ebp,%esp
     d19:       5d                      pop    %ebp
     d1a:       c3                      ret    
     d1b:       90                      nop    
     d1c:       8d 74 26 00             lea    0x0(%esi),%esi
/usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:331
     d20:       8b 18                   mov    (%eax),%ebx
/usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:332
     d22:       8b 43 04                mov    0x4(%ebx),%eax
/usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:335
     d25:       8d 73 38                lea    0x38(%ebx),%esi
/usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:332
     d28:       8b 78 1c                mov    0x1c(%eax),%edi
/usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:333
     d2b:       8d 82 bc 00 00 00       lea    0xbc(%edx),%eax
     d31:       e8 fc ff ff ff          call   d32 <serial_do_free+0x42>
/usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:335
     d36:       89 f0                   mov    %esi,%eax
     d38:       e8 fc ff ff ff          call   d39 <serial_do_free+0x49>
/usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:336
     d3d:       f6 43 0c 01             testb  $0x1,0xc(%ebx)
     d41:       74 1d                   je     d60 <serial_do_free+0x70>
/usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:338
     d43:       89 f0                   mov    %esi,%eax
     d45:       e8 fc ff ff ff          call   d46 <serial_do_free+0x56>
/usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:339
     d4a:       89 d8                   mov    %ebx,%eax
     d4c:       e8 fc ff ff ff          call   d4d <serial_do_free+0x5d>
/usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:341
     d51:       89 f8                   mov    %edi,%eax
     d53:       e8 fc ff ff ff          call   d54 <serial_do_free+0x64>
     d58:       eb b2                   jmp    d0c <serial_do_free+0x1c>
     d5a:       8d b6 00 00 00 00       lea    0x0(%esi),%esi
/usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:337
     d60:       8b 43 08                mov    0x8(%ebx),%eax
     d63:       e8 fc ff ff ff          call   d64 <serial_do_free+0x74>
     d68:       eb d9                   jmp    d43 <serial_do_free+0x53>
     d6a:       8d b6 00 00 00 00       lea    0x0(%esi),%esi


>From what I understand it's serial->type which points to 0x00700128,
which is inside of some freed memory.

     d22:       8b 43 04                mov    0x4(%ebx),%eax
        copy & serial (EBX)->type to EAX

     d28:       8b 78 1c                mov    0x1c(%eax),%edi
        copy type (EAX)->driver.owner to EDI

Am I reading this disassembled code correctly?

Verifying by adding a few printk()'s inside serial_do_free() confirms my
understanding of the objdump and also tells me that after unplug
serial_do_free() is called twice (with different addresses for port->serial->type)!
The first one (right after unplug) survives, the second one (when exiting
minicom) crashes.

Extract from the logs with my printk()'s
[  266.290632] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
[  266.290938] ftdi_sio 2-2:1.1: device disconnected
[  266.292378] tty_port_close_start: count = -1
[  266.292535] serial_do_free(port @da0d9000)
[  266.292692]   serial @da3e9840
[  266.292791]   type   @deb45660
/* exit minicom */
[  290.728196] serial_do_free(port @da0d9000)
[  290.728341]   serial @da0d9200
[  290.728461]   type   @3a6e6967
[  290.728591] BUG: unable to handle kernel paging request at 3a6e6983
[  290.728823] IP: [<deb02d5d>] serial_do_free+0x6d/0xd0 [usbserial]
[  290.729059] *pde = 00000000 
[  290.729182] Oops: 0000 [#1] 
[  290.729303] last sysfs file: /sys/devices/virtual/hwmon/hwmon0/temp1_input
[  290.729548] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd snd_timer nsc_ircc usbcore pcspkr irda snd snd_page_alloc i2c_i801 crc_ccitt
[  290.730912] 
[  290.730987] Pid: 2206, comm: minicom Tainted: G   M       (2.6.31-rc6 #1) TravelMate 660
[  290.731242] EIP: 0060:[<deb02d5d>] EFLAGS: 00010282 CPU: 0
[  290.731441] EIP is at serial_do_free+0x6d/0xd0 [usbserial]
[  290.731615] EAX: 3a6e6967 EBX: da0d9000 ECX: ffffffff EDX: c13c6584
[  290.731829] ESI: da0d9200 EDI: 00000000 EBP: d8dc9e24 ESP: d8dc9e10
[  290.732027]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  290.732218] Process minicom (pid: 2206, ti=d8dc9000 task=dd8e5090 task.ti=d8dc9000)


Printk's were added:

	if (port->console)
		return;
	/* here */
	serial = serial->port;
	owner = serial->type->driver.owner /* crash here */

Is it useful to check calls to serial_do_free() for my pl2303
usb2serial converter? (e.g. to compare behavior from both of them)

Thanks,
Bruno
