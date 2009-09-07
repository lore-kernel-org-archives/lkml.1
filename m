Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbZIGLOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbZIGLOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 07:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZIGLOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 07:14:34 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38725 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbZIGLOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 07:14:33 -0400
To: stern@rowland.harvard.edu
CC: alan@linux.intel.com, miklos@szeredi.hu, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.44L0.0909041109480.3204-100000@iolanthe.rowland.org>
	(message from Alan Stern on Fri, 4 Sep 2009 11:12:36 -0400 (EDT))
Subject: Re: WARNINGs in usb-serial.c
References: <Pine.LNX.4.44L0.0909041109480.3204-100000@iolanthe.rowland.org>
Message-Id: <E1MkcAx-0000Mx-Be@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 07 Sep 2009 13:14:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009, Alan Stern wrote:
> On Fri, 4 Sep 2009, Alan Cox wrote:
> 
> > On Fri, 4 Sep 2009 10:17:30 -0400 (EDT)
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > On Fri, 4 Sep 2009, Miklos Szeredi wrote:
> > > 
> > > > On Thu, 3 Sep 2009, Greg KH wrote:
> > > > > On Thu, Sep 03, 2009 at 04:13:34PM +0200, Miklos Szeredi wrote:
> > > > > > I get the following warnings in 2.6.31-rc.  A lot of them:
> > > > > > 
> > > > > > WARNING: at drivers/usb/serial/usb-serial.c:414
> > > > > > serial_write_room+0x59/0x6e [usbserial]() WARNING: at
> > > > > > drivers/usb/serial/usb-serial.c:401 serial_write+0x77/0x9d
> > > > > > [usbserial]()
> > > > > > 
> > > > > > This is a huawei-3565 modem.
> > > > > > 
> > > > > > The messages don't seem to hurt, but there's lot of trouble
> > > > > > with this gadget.  Sometimes it just doesn't work after a while
> > > > > > and a reboot is needed.  Sometimes it hangs the kernel after
> > > > > > suspend, etc.  Not sure if this is related to the warnings...
> > > > > 
> > > > > {sigh}
> > > > > 
> > > > > The tty layer changes are being a pain here :(
> > > > > 
> > > > > Alan Stern posted a set of patches to the linux-usb list to
> > > > > hopefully address stuff like this, is there any way you could
> > > > > test them out to see if they help or not?
> > > > 
> > > > Nope, it doesn't seem to help.  Still got the same warnings with the
> > > > patched kernel (latest git + ghk tree + usbserial patches).

Here's a reproducible Oops on that kernel when trying to connect with
wvdial.  This is a regression compared to -linus, where wvdial works
(most of the time anyway).

I can bisect it if it's not immediately obvious what is happening...

Thanks,
Miklos
---


BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffffa020709c>] serial_chars_in_buffer+0x47/0x5f [usbserial]
PGD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/class/rfkill/rfkill2/state
CPU 0 
Modules linked in: ppp_generic slhc option usbserial nls_iso8859_1 nls_cp437 vfat fat usb_storage bnep rfcomm sco l2cap acpi_cpufreq nf_conntrack_netbios_ns microcode fuse iwl3945 iwlcore thinkpad_acpi mac80211 backlight btusb led_class bluetooth thermal ac battery processor button nsc_ircc irda crc_ccitt cfg80211 rfkill e1000e uinput [last unloaded: usbserial]
Pid: 5159, comm: pppd Tainted: G        W  2.6.31-rc8-gkh-00038-g37d0892-dirty #33 2007FUG
RIP: 0010:[<ffffffffa020709c>]  [<ffffffffa020709c>] serial_chars_in_buffer+0x47/0x5f [usbserial]
RSP: 0018:ffff8800ac753d78  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800bf3d8800 RCX: 000000000000001a
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88001912a000
RBP: ffff8800ac753d88 R08: 00007f8611e2d1f0 R09: ffff8800ac753f28
R10: 3d4449505f445050 R11: 0000000000000246 R12: ffff88001912a000
R13: ffff88001912a000 R14: ffff88001912a000 R15: ffff88001912a000
FS:  00007f86105b96f0(0000) GS:ffff880001f3d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 000000008d7db000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process pppd (pid: 5159, threadinfo ffff8800ac752000, task ffff88001914e040)
Stack:
 ffff8800ac675c00 7fffffffffffffff ffff8800ac753d98 ffffffff811c271e
<0> ffff8800ac753e08 ffffffff811c2c73 ffff8800ac753df8 0000000000000046
<0> ffff88001914e040 ffffffff810c676a ffff8800ac675ac0 ffff8800bf840bc0
Call Trace:
 [<ffffffff811c271e>] tty_chars_in_buffer+0x1a/0x1c
 [<ffffffff811c2c73>] tty_wait_until_sent+0x32/0xfc
 [<ffffffff810c676a>] ? kmem_cache_free+0x118/0x18b
 [<ffffffff811be720>] tty_ioctl+0xa6/0x891
 [<ffffffff810d826e>] vfs_ioctl+0x2f/0x7d
 [<ffffffff810d87eb>] do_vfs_ioctl+0x4af/0x4ec
 [<ffffffff810cc1ae>] ? fget+0x0/0x127
 [<ffffffff8100b1cc>] ? sysret_check+0x27/0x62
 [<ffffffff810d886f>] sys_ioctl+0x47/0x6a
 [<ffffffff8100b19b>] system_call_fastpath+0x16/0x1b
Code: 00 74 23 0f b6 8b 50 02 00 00 48 c7 c2 20 ac 20 a0 48 c7 c6 67 b0 20 a0 48 c7 c7 87 b0 20 a0 31 c0 e8 13 53 11 e1 48 8b 13 31 c0 <f6> 42 18 01 75 0d 48 8b 42 08 4c 89 e7 ff 90 58 01 00 00 5b 41 
RIP  [<ffffffffa020709c>] serial_chars_in_buffer+0x47/0x5f [usbserial]
 RSP <ffff8800ac753d78>
CR2: 0000000000000018
---[ end trace 644f4c2ff2fe598a ]---
