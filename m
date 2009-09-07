Return-Path: <linux-kernel-owner+w=401wt.eu-S1751659AbZIGUJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbZIGUJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 16:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbZIGUJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 16:09:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47127 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbZIGUJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 16:09:19 -0400
To: stern@rowland.harvard.edu
CC: miklos@szeredi.hu, alan@linux.intel.com, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.44L0.0909071509250.9972-100000@netrider.rowland.org>
	(message from Alan Stern on Mon, 7 Sep 2009 15:25:07 -0400 (EDT))
Subject: Re: WARNINGs in usb-serial.c
References: <Pine.LNX.4.44L0.0909071509250.9972-100000@netrider.rowland.org>
Message-Id: <E1MkkWY-00014V-9E@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 07 Sep 2009 22:09:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Alan Stern wrote:
> I don't understand this.  How did we get to destroy_serial()?  It is
> called from only one place: usb_serial_put().  That in turn is called
> from only a few places, of which the most important are
> serial_release() and usb_serial_disconnect().  But neither of them
> shows up in the debugging log.
> 
> We need more debugging info.  You can try printing the value of 
> port->port.count just before the end of serial_open() and at the start 
> of serial_close().  You can also add a WARN() at the start of 
> destroy_serial() so that the stack dump will show how we got there.

OK, here's the debug output with the info.  Looks like the
destroy_serial() is called via serial_open().

drivers/usb/serial/usb-serial.c: serial_install
drivers/usb/serial/usb-serial.c: serial_open - port 0
serial_open = 1
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x541e
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5402
drivers/usb/serial/usb-serial.c: serial_set_termios - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5402
drivers/usb/serial/usb-serial.c: serial_set_termios - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_tiocmget - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5402
drivers/usb/serial/usb-serial.c: serial_set_termios - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 5 byte(s)
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 4 byte(s)
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 13 byte(s)
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 28 byte(s)
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
PPP generic driver version 2.4.2
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_open - port 0
serial_open = 2
drivers/usb/serial/usb-serial.c: serial_tiocmset - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5404
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_set_termios - port 0
drivers/usb/serial/usb-serial.c: serial_open - port 0
Pid: 5007, comm: pppd Not tainted 2.6.31-rc8-gkh-00038-g37d0892-dirty #42
Call Trace:
 [<ffffffff810687bb>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffffa01cc532>] ? destroy_serial+0x0/0x10e [usbserial]
 [<ffffffffa01cc54a>] destroy_serial+0x18/0x10e [usbserial]
 [<ffffffffa01cc532>] ? destroy_serial+0x0/0x10e [usbserial]
 [<ffffffff8116ddbd>] kref_put+0x43/0x4f
 [<ffffffffa01cb0e3>] serial_open+0x11b/0x188 [usbserial]
 [<ffffffff811c4d6d>] tty_open+0x30a/0x431
 [<ffffffff810d1785>] chrdev_open+0x19c/0x1bb
 [<ffffffff81324e61>] ? _spin_unlock+0x2b/0x55
 [<ffffffff810cf63f>] ? file_move+0x23/0x55
 [<ffffffff810d15e9>] ? chrdev_open+0x0/0x1bb
 [<ffffffff810cd1ab>] __dentry_open+0x184/0x2a3
 [<ffffffff810cd3a1>] nameidata_to_filp+0x46/0x57
 [<ffffffff810da70f>] do_filp_open+0x4f3/0x9bd
 [<ffffffff810e3c3f>] ? alloc_fd+0x122/0x133
 [<ffffffff810ccf2d>] do_sys_open+0x62/0x110
 [<ffffffff810cd00e>] sys_open+0x20/0x22
 [<ffffffff8100b19b>] system_call_fastpath+0x16/0x1b
drivers/usb/serial/usb-serial.c: destroy_serial - GSM modem (1-port)
drivers/usb/serial/usb-serial.c: return_serial
serial_open = 3
drivers/usb/serial/usb-serial.c: serial_close - port 0
serial_close = 3
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffffa01ca09c>] serial_chars_in_buffer+0x47/0x5f [usbserial]
PGD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/class/rfkill/rfkill1/state
CPU 0 
Modules linked in: ppp_generic slhc usb_storage option usbserial bnep sco rfcomm l2cap acpi_cpufreq nf_conntrack_netbios_ns microcode fuse thinkpad_acpi iwl3945 backlight battery iwlcore led_class ac nsc_ircc mac80211 processor thermal button btusb bluetooth irda cfg80211 crc_ccitt rfkill e1000e uinput
Pid: 5007, comm: pppd Not tainted 2.6.31-rc8-gkh-00038-g37d0892-dirty #42 2007FUG
RIP: 0010:[<ffffffffa01ca09c>]  [<ffffffffa01ca09c>] serial_chars_in_buffer+0x47/0x5f [usbserial]
RSP: 0018:ffff88009a01fd78  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800b2067000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88009a01fca7
RBP: ffff88009a01fd88 R08: 0000000000000082 R09: ffffffff8105d685
R10: 0000000000000082 R11: 0000000000018600 R12: ffff8800afa31000
R13: ffff8800afa31000 R14: ffff8800afa31000 R15: ffff8800afa31000
FS:  00007ff6efec46f0(0000) GS:ffff880001f45000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 000000009e9e7000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process pppd (pid: 5007, threadinfo ffff88009a01e000, task ffff88009e878040)
Stack:
 ffff8800a715d840 7fffffffffffffff ffff88009a01fd98 ffffffff811c7aa2
<0> ffff88009a01fe08 ffffffff811c7ff7 ffff88009a01fdf8 0000000000000046
<0> ffff88009e878040 ffffffff810c9f8a ffff8800a715d200 ffff8800bf840bc0
Call Trace:
 [<ffffffff811c7aa2>] tty_chars_in_buffer+0x1a/0x1c
 [<ffffffff811c7ff7>] tty_wait_until_sent+0x32/0xfc
 [<ffffffff810c9f8a>] ? kmem_cache_free+0x118/0x18b
 [<ffffffff811c3aa4>] tty_ioctl+0xa6/0x891
 [<ffffffff810dba8e>] vfs_ioctl+0x2f/0x7d
 [<ffffffff810dc00b>] do_vfs_ioctl+0x4af/0x4ec
 [<ffffffff810cf9ce>] ? fget+0x0/0x127
 [<ffffffff8100b1cc>] ? sysret_check+0x27/0x62
 [<ffffffff810dc08f>] sys_ioctl+0x47/0x6a
 [<ffffffff8100b19b>] system_call_fastpath+0x16/0x1b
Code: 00 74 23 0f b6 8b 50 02 00 00 48 c7 c2 60 dc 1c a0 48 c7 c6 a7 e0 1c a0 48 c7 c7 c7 e0 1c a0 31 c0 e8 93 76 15 e1 48 8b 13 31 c0 <f6> 42 18 01 75 0d 48 8b 42 08 4c 89 e7 ff 90 58 01 00 00 5b 41 
RIP  [<ffffffffa01ca09c>] serial_chars_in_buffer+0x47/0x5f [usbserial]
 RSP <ffff88009a01fd78>
CR2: 0000000000000018
---[ end trace 6b3c350da83d5762 ]---
