Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbXE0Sok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbXE0Sok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 14:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbXE0SoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 14:44:20 -0400
Received: from posti6.jyu.fi ([130.234.4.43]:53589 "EHLO posti6.jyu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbXE0SoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 14:44:18 -0400
X-Greylist: delayed 34644 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 May 2007 14:44:17 EDT
Date: Sun, 27 May 2007 12:06:40 +0300 (EEST)
From: Tero Roponen <teanropo@jyu.fi>
X-X-Sender: teanropo@jalava.cc.jyu.fi
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org
Subject: tty-related oops in latest kernel(s)?
Message-ID: <Pine.LNX.4.64.0705271200360.4955@jalava.cc.jyu.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.22-rc3 (with Reiser4 patch) oopses when watching videos with
mplayer using neofb console.

When mplayer starts I get these messages
(this is normal, repeating lines omitted):

  neofb: no support for 32bpp
  Mode (1024x768) larger than the LCD panel (800x600)
  Mode (1152x864) larger than the LCD panel (800x600)
  Mode (1024x1024) larger than the LCD panel (800x600)
  Mode (1280x1024) larger than the LCD panel (800x600)

Ok, everything seems to work and I can watch the video.
However, when the mplayer stops I get these warnings:

  release_dev: driver.table[3] not tty for (tty4)
  Warning: dev (tty4) tty->count(3) != #fd's(2) in release_dev
  release_dev: driver.table[3] not tty for (tty4)

When I try to repeat the previous step the kernel oopses:

  neofb: no support for 32bpp
  Mode (1024x768) larger than the LCD panel (800x600)
  Mode (1152x864) larger than the LCD panel (800x600)
  Mode (1024x1024) larger than the LCD panel (800x600)
  Mode (1280x1024) larger than the LCD panel (800x600)
  BUG: unable to handle kernel NULL pointer dereference at virtual address 00000731
   printing eip:
  c021e50e
  *pde = 00000000
  Oops: 0000 [#1]
  Modules linked in: binfmt_misc floppy loop xirc2ps_cs pcmcia usb_storage parport_pc parport yenta_socket rsrc_nonstatic pcmcia_core evdev uhci_hcd usbcore
  CPU:    0
  EIP:    0060:[<c021e50e>]    Not tainted VLI
  EFLAGS: 00010202   (2.6.22-rc3-atr #4)
  EIP is at vt_ioctl+0xda8/0x1482
  eax: 00000679   ebx: 00005600   ecx: c3d41200   edx: 00000000
  esi: 0893159c   edi: c0386a2f   ebp: 00000003   esp: c26a5e28
  ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
  Process mplayer (pid: 1502, ti=c26a5000 task=c3a22500 task.ti=c26a5000)
  Stack: fffffffe c26a5f30 c0149fd9 c29fe400 c3d68600 00000001 4642f7b0 c3d0bcc0 
         c3c32464 00000101 00000001 00000000 4644793c 4642f7b0 00000002 00000005 
         0000001b 00000005 c34ad240 c3d0bcc0 c1386000 00000002 00000000 c021d766 
  Call Trace:
   [<c0149fd9>] link_path_walk+0xa5/0xaf
   [<c021d766>] vt_ioctl+0x0/0x1482
   [<c021a395>] tty_ioctl+0xa01/0xa87
   [<c0143c5a>] get_empty_filp+0x4f/0xc9
   [<c01439bf>] put_filp+0x14/0x31
   [<c014ab93>] __path_lookup_intent_open+0x6c/0x75
   [<c014ac10>] path_lookup_open+0x20/0x25
   [<c014acd9>] open_namei+0x6e/0x51d
   [<c0141b0c>] do_filp_open+0x25/0x39
   [<c0219994>] tty_ioctl+0x0/0xa87
   [<c014ba8a>] do_ioctl+0x3e/0x4d
   [<c014bc84>] vfs_ioctl+0x1eb/0x202
   [<c014bcce>] sys_ioctl+0x33/0x4d
   [<c01022c2>] sysenter_past_esp+0x5f/0x85
   =======================
  Code: 0f b7 c8 7f 04 85 c9 75 cd 8d 4e 04 89 d8 e8 aa 11 fd ff e9 20 f8 ff ff 8d 04 95 00 00 00 00 03 81 b8 00 00 00 8b 00 85 c0 74 16 <83> b8 b8 00 00 00 00 74 0d 42 83 fa 3f 75 de b0 ff e9 88 f7 ff 
  EIP: [<c021e50e>] vt_ioctl+0xda8/0x1482 SS:ESP 0068:c26a5e28
  BUG: unable to handle kernel NULL pointer dereference at virtual address 0000072d
   printing eip:
  c021820c
  *pde = 00000000
  Oops: 0000 [#2]
  Modules linked in: binfmt_misc floppy loop xirc2ps_cs pcmcia usb_storage parport_pc parport yenta_socket rsrc_nonstatic pcmcia_core evdev uhci_hcd usbcore
  CPU:    0
  EIP:    0060:[<c021820c>]    Not tainted VLI
  EFLAGS: 00210202   (2.6.22-rc3-atr #4)
  EIP is at init_dev+0x38c/0x497
  eax: c10ba40c   ebx: c3d41200   ecx: c1f5fecc   edx: 00000003
  esi: 00000679   edi: 00400004   ebp: c3d41200   esp: c1f5fe7c
  ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
  Process syslogd (pid: 1503, ti=c1f5f000 task=c3a22500 task.ti=c1f5f000)
  Stack: 00000102 00000000 c1fe7aa0 c1f5fecc 00000003 ffffffe9 c1f5ff30 c014a217 
         c1386000 00000005 c3a5b95c 00002190 c01159ec c3d41200 c1fe7aa0 00400004 
         00000100 c021a519 00000101 00000003 c01ebea4 00000000 c3d41204 c3a5b95c 
  Call Trace:
   [<c014a217>] do_path_lookup+0x131/0x14c
   [<c01159ec>] __capable+0x8/0x1b
   [<c021a519>] tty_open+0xfe/0x271
   [<c01ebea4>] kobject_get+0xf/0x13
   [<c0144ba6>] chrdev_open+0xc1/0xf6
   [<c014aec5>] open_namei+0x25a/0x51d
   [<c0144ae5>] chrdev_open+0x0/0xf6
   [<c01419a8>] __dentry_open+0xb7/0x16d
   [<c0141ad8>] nameidata_to_filp+0x24/0x33
   [<c0141b19>] do_filp_open+0x32/0x39
   [<c0141b62>] do_sys_open+0x42/0xc3
   [<c0141c1c>] sys_open+0x1c/0x1e
   [<c01022c2>] sysenter_past_esp+0x5f/0x85
   =======================
  Code: c0 89 c3 74 14 8b 56 20 85 d2 0f 84 de 00 00 00 89 f0 ff d2 e9 d5 00 00 00 8b 44 24 14 e8 eb f8 ff ff 89 f0 e8 e4 f8 ff ff eb 48 <8b> 86 b4 00 00 00 84 c0 78 4b 81 7d 78 04 00 01 00 75 15 83 be 
  EIP: [<c021820c>] init_dev+0x38c/0x497 SS:ESP 0068:c1f5fe7c

I have been busy and just upgraded from 2.6.19.2, so this bug may have
been introduced anytime since that kernel. Unfortunately, I have a slow
connection and therefore can't bisect this.

--
Tero Roponen
