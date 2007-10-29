Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbXJ2W0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbXJ2W0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbXJ2W0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:26:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:8023 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbXJ2W0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=IV5nSjl1sGjrR2Py/F7ML7Q+pFCUAtTYbLAeRWxyVExHwQHuTdr7ZOSYXXKfc/yX1+Qlu8snaiWBbGbv2pgdisWJ0kO+y+P70OP8uvwNwcr0PEaN/ubu3PC4M1uxBcWKM8QS9ad/8q8S8FarFFQ7a/dlcjm4JVbpLWj0H2mv7mc=
Message-ID: <4bacf17f0710291526l6be89bd9o33f02c33186d57b7@mail.gmail.com>
Date: Mon, 29 Oct 2007 23:26:31 +0100
From: "=?ISO-8859-2?Q?Marcin_=A6lusarz?=" <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: usbserial.ko/option.ko on 2.6.23: Unable to handle kernel paging request && inconsistent lock state
Cc: greg@kroah.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
While fighting with Option Globesurfer ICON USB modem I got oops and
lockdep warning:

(on rmmod option usbserial, not reproducible)

usbcore: deregistering interface driver option
drivers/usb/serial/usb-serial.c: USB Serial deregistering driver GSM
modem (1-port)
option1 ttyUSB3: GSM modem (1-port) converter now disconnected from ttyUSB3
option1 ttyUSB2: GSM modem (1-port) converter now disconnected from ttyUSB2
option1 ttyUSB1: GSM modem (1-port) converter now disconnected from ttyUSB1
option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
usbcore: deregistering interface driver usbserial_generic
Unable to handle kernel paging request at ffffffff887a23a0 RIP:
 [<ffffffff88796c39>] :usbserial:destroy_serial+0x29/0x1b0
PGD 203067 PUD 207063 PMD 3bfc3067 PTE 0
Oops: 0000 [1] PREEMPT
CPU 0
Modules linked in: usbserial ppp_async crc_ccitt ppp_generic slhc
usbhid tuner tda9875 nvidia(P) bttv video_buf firmware_class ir_common
compat_ioctl32 i2c_algo_bit btcx_risc tveeprom videodev v4l2_common
v4l1_compat uhci_hcd ehci_hcd usbcore i2c_viapro skge i2c_core
ne2k_pci 8390
Pid: 6912, comm: rmmod Tainted: P        2.6.23 #8
RIP: 0010:[<ffffffff88796c39>]  [<ffffffff88796c39>]
:usbserial:destroy_serial+0x29/0x1b0
RSP: 0018:ffff81001b649d38  EFLAGS: 00010246
RAX: ffffffff887a2180 RBX: ffff81003dd133a0 RCX: ffffffff805d4633
RDX: 0000000000000000 RSI: ffffffff88796c10 RDI: ffff81003dd13340
RBP: ffff81001b649d58 R08: 0000000000000002 R09: 0000000000000001
R10: 2222222222222222 R11: 2222222222222222 R12: ffff81003dd13340
R13: ffff81003dd13340 R14: ffff81003d707c30 R15: ffffffff8879dda0
FS:  00002baa3be46b00(0000) GS:ffffffff80762000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff887a23a0 CR3: 000000001b6f2000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rmmod (pid: 6912, threadinfo ffff81001b648000, task ffff81001b74e0c0)
Stack:  ffff81003e6f5c00 ffff81003dd133a0 ffffffff88796c10 ffff81003dd13340
 ffff81001b649d78 ffffffff803d56c2 ffff81003dd133a0 0000000000000001
 ffff81001b649d98 ffffffff88796afb ffff81001b649d98 ffff81003cf68800
Call Trace:
 [<ffffffff88796c10>] :usbserial:destroy_serial+0x0/0x1b0
 [<ffffffff803d56c2>] kref_put+0x42/0x80
 [<ffffffff88796afb>] :usbserial:usb_serial_put+0x2b/0x40
 [<ffffffff88797439>] :usbserial:usb_serial_disconnect+0x79/0xd0
 [<ffffffff8802783e>] :usbcore:usb_unbind_interface+0x4e/0xb0
 [<ffffffff804520a2>] __device_release_driver+0x82/0xc0
 [<ffffffff804526c9>] driver_detach+0xf9/0x100
 [<ffffffff80451af3>] bus_remove_driver+0x83/0xb0
 [<ffffffff80452709>] driver_unregister+0x9/0x10
 [<ffffffff88027007>] :usbcore:usb_deregister+0xc7/0xe0
 [<ffffffff88799290>] :usbserial:usb_serial_generic_deregister+0x10/0x20
 [<ffffffff88799c29>] :usbserial:usb_serial_exit+0x9/0x3b
 [<ffffffff8025977c>] sys_delete_module+0x16c/0x1f0
 [<ffffffff8058e4fd>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff8020bb1e>] system_call+0x7e/0x83


Code: ff 90 20 02 00 00 44 8b 2d a6 7a 00 00 45 85 ed 0f 85 23 01
RIP  [<ffffffff88796c39>] :usbserial:destroy_serial+0x29/0x1b0
 RSP <ffff81001b649d38>
CR2: ffffffff887a23a0

second log:

=================================
[ INFO: inconsistent lock state ]
2.6.23 #8
---------------------------------
inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (&port->lock){+...}, at: [<ffffffff880e212c>]
usb_serial_generic_read_bulk_callback+0x6c/0x1c0 [usbserial]
{hardirq-on-W} state was registered at:
  [<ffffffff8027343b>] vma_adjust+0xcb/0x4e0
  [<ffffffff80251273>] __lock_acquire+0x703/0x1110
  [<ffffffff880e23a6>] usb_serial_generic_write+0x76/0x2e0 [usbserial]
  [<ffffffff80251d16>] lock_acquire+0x96/0xd0
  [<ffffffff880e23a6>] usb_serial_generic_write+0x76/0x2e0 [usbserial]
  [<ffffffff8058e8d9>] _spin_lock_bh+0x39/0x50
  [<ffffffff880e23a6>] usb_serial_generic_write+0x76/0x2e0 [usbserial]
  [<ffffffff880df737>] serial_write+0x77/0xe0 [usbserial]
  [<ffffffff80438405>] write_chan+0x255/0x380
  [<ffffffff8022de20>] default_wake_function+0x0/0x10
  [<ffffffff804357c9>] tty_write+0x199/0x250
  [<ffffffff804381b0>] write_chan+0x0/0x380
  [<ffffffff80287227>] vfs_write+0xc7/0x170
  [<ffffffff802878c0>] sys_write+0x50/0x90
  [<ffffffff8020bb1e>] system_call+0x7e/0x83
  [<ffffffffffffffff>] 0xffffffffffffffff
irq event stamp: 5350958
hardirqs last  enabled at (5350957): [<ffffffff8020a822>] default_idle+0x32/0x50
hardirqs last disabled at (5350958): [<ffffffff8058e534>]
trace_hardirqs_off_thunk+0x35/0x67
softirqs last  enabled at (5350950): [<ffffffff80237e53>] __do_softirq+0xb3/0xd0
softirqs last disabled at (5350943): [<ffffffff8020c87c>] call_softirq+0x1c/0x30

other info that might help us debug this:
no locks held by swapper/0.

stack backtrace:

Call Trace:
 <IRQ>  [<ffffffff8024f459>] print_usage_bug+0x189/0x190
 [<ffffffff8025013d>] mark_lock+0x43d/0x660
 [<ffffffff802513d6>] __lock_acquire+0x866/0x1110
 [<ffffffff80250f5b>] __lock_acquire+0x3eb/0x1110
 [<ffffffff880e212c>]
:usbserial:usb_serial_generic_read_bulk_callback+0x6c/0x1c0
 [<ffffffff80251d16>] lock_acquire+0x96/0xd0
 [<ffffffff880e212c>]
:usbserial:usb_serial_generic_read_bulk_callback+0x6c/0x1c0
 [<ffffffff8058ea14>] _spin_lock+0x34/0x50
 [<ffffffff880e212c>]
:usbserial:usb_serial_generic_read_bulk_callback+0x6c/0x1c0
 [<ffffffff8800f622>] :usbcore:usb_hcd_giveback_urb+0x22/0x60
 [<ffffffff88041cb5>] :uhci_hcd:uhci_giveback_urb+0xb5/0x230
 [<ffffffff880425bf>] :uhci_hcd:uhci_scan_schedule+0x63f/0xa30
 [<ffffffff88044831>] :uhci_hcd:uhci_irq+0x81/0x190
 [<ffffffff8800f98d>] :usbcore:usb_hcd_irq+0x2d/0x60
 [<ffffffff8025e445>] handle_IRQ_event+0x35/0x70
 [<ffffffff8025fa96>] handle_fasteoi_irq+0x76/0xf0
 [<ffffffff8020e6bd>] do_IRQ+0x5d/0xc0
 [<ffffffff8020a7f0>] default_idle+0x0/0x50
 [<ffffffff8020c066>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8020a824>] default_idle+0x34/0x50
 [<ffffffff8020a822>] default_idle+0x32/0x50
 [<ffffffff8020a88f>] cpu_idle+0x4f/0x90
 [<ffffffff8058b295>] rest_init+0x75/0x80
 [<ffffffff8076dada>] start_kernel+0x26a/0x2c0
 [<ffffffff8076d12f>] _sinittext+0x12f/0x140

You can find full kernel logs here: http://www.kadu.net/~joi/kernel/2007.10.28/

regards,
Marcin
