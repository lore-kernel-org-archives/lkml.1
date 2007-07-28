Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbXG1T2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbXG1T2b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 15:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXG1T2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 15:28:25 -0400
Received: from wildsau.enemy.org ([193.170.194.34]:32835 "EHLO
	wildsau.enemy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbXG1T2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 15:28:24 -0400
X-Greylist: delayed 2463 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jul 2007 15:28:23 EDT
From: Herbert Rosmanith <kernel@wildsau.enemy.org>
Message-Id: <200707281847.l6SIl7Sl000239@wildsau.enemy.org>
Subject: kernel panic w/ 2.6.22.1, VIA EPIA Mini ITX
To: linux-kernel@vger.kernel.org
Date: Sat, 28 Jul 2007 20:47:07 +0200 (MET DST)
X-Mailer: ELM [version 2.4ME+ PL100 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


good day,

when setting up a more or less old board, 2.6.22.1 crashes during an
"emerge --sync" (gentoo installation).

first, the screen will start funny - like a crashed C64 (from the "good"
old days). I made a photo, you can look at it here:

	http://wildsau.enemy.org/~kernel/epia-crash.jpg

actually, that's not a static picture, but there's also a lotta
blinking going on. the image you see is from a non-framebuffer
mode kernel, since I first suspected the framebuffer being the
culprit, because when I framebuffer mode, the crash will result
in many coloured pixels on the screen, like when doing
"cat /dev/random /dev/fb0". But since this happens in textmode too,
something else is triggering this.

anyway .... hardware: the board is a VIA EPIA 500Mhz fanless (Mini ITX)
with a C3 processor and 1GB (2x512) SD-RAM.

the kernel complains about this:
Jul 28 22:30:17 localhost BUG: unable to handle kernel paging request at virtual
 address 00ffffff


or, to me more specific:


Jul 28 22:30:17 localhost BUG: unable to handle kernel paging request at virtual
 address 00ffffff
Jul 28 22:30:17 localhost printing eip:
Jul 28 22:30:17 localhost c016c506
Jul 28 22:30:17 localhost *pde = 00000000
Jul 28 22:30:17 localhost Oops: 0000 [#1]
Jul 28 22:30:17 localhost Modules linked in: parport_pc parport uhci_hcd usbcore
Jul 28 22:30:17 localhost CPU:    0
Jul 28 22:30:17 localhost EIP:    0060:[<c016c506>]    Not tainted VLI
Jul 28 22:30:17 localhost EFLAGS: 00010206   (2.6.22.1 #2)
Jul 28 22:30:17 localhost EIP is at __d_lookup+0x66/0xe0
Jul 28 22:30:17 localhost eax: 4c482617   ebx: 00ffffff   ecx: 00000011   edx: c
1819180
Jul 28 22:30:17 localhost esi: 00ffffff   edi: f7634005   ebp: ef848780   esp: f
7a87dc0
Jul 28 22:30:17 localhost ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Jul 28 22:30:17 localhost Process bash (pid: 4209, ti=f7a86000 task=c1bb8070 tas
k.ti=f7a86000)
Jul 28 22:30:17 localhost Stack: 4c482617 f7a87e1c f7a87e3c f7fe7114 f7a87f30 00
000011 f7634005 f7634016 
Jul 28 22:30:17 localhost f7a87e3c f7a87f04 f7a87e3c c0162f48 f7a87e48 c18e6220 
c01a82b0 f7ef12a0 
Jul 28 22:30:17 localhost f7634016 f7a87e3c f7ef12a0 f7a87f04 c0164a69 f7634005 
00000001 4c482617 
Jul 28 22:30:17 localhost Call Trace:
Jul 28 22:30:17 localhost [<c0162f48>] do_lookup+0x28/0x190
Jul 28 22:30:17 localhost [<c01a82b0>] ext3_permission+0x0/0x10
Jul 28 22:30:17 localhost [<c0164a69>] __link_path_walk+0x669/0xb20
Jul 28 22:30:17 localhost [<c017055b>] mntput_no_expire+0x1b/0x70
Jul 28 22:30:17 localhost [<c0164f83>] link_path_walk+0x63/0xc0
Jul 28 22:30:17 localhost [<c0164f63>] link_path_walk+0x43/0xc0
Jul 28 22:30:17 localhost [<c0165184>] do_path_lookup+0x64/0x180
Jul 28 22:30:17 localhost [<c0164113>] getname+0xb3/0xe0
Jul 28 22:30:17 localhost [<c0165b6b>] __user_walk_fd+0x3b/0x60
Jul 28 22:30:17 localhost [<c015f682>] vfs_stat_fd+0x22/0x60
Jul 28 22:30:17 localhost [<c015f76f>] sys_stat64+0xf/0x30
Jul 28 22:30:17 localhost [<c0104f02>] syscall_call+0x7/0xb
Jul 28 22:30:17 localhost =======================
Jul 28 22:30:17 localhost Code: ea 31 d0 8b 15 b4 9e 3b c0 89 7c 24 18 21 d0 8b 
15 bc 9e 3b c0 8b 34 82 85 f6 75 0f eb 54 8d b4 26 00 00 00 00 85 db 89 de 74 47
 <8b> 1e 8d 74 26 00 8d 6e f4 8b 04 24 3b 45 18 75 e9 8b 44 24 0c 
Jul 28 22:30:17 localhost EIP: [<c016c506>] __d_lookup+0x66/0xe0 SS:ESP 0068:f7a
87dc0
Jul 28 22:30:17 localhost BUG: unable to handle kernel paging request at virtual
 address 00ffffff
Jul 28 22:30:17 localhost printing eip:
Jul 28 22:30:17 localhost c016c506
Jul 28 22:30:17 localhost *pde = 00000000
Jul 28 22:30:17 localhost Oops: 0000 [#2]
Jul 28 22:30:17 localhost Modules linked in: parport_pc parport uhci_hcd usbcore
Jul 28 22:30:17 localhost CPU:    0
Jul 28 22:30:17 localhost EIP:    0060:[<c016c506>]    Not tainted VLI
Jul 28 22:30:17 localhost EFLAGS: 00010206   (2.6.22.1 #2)
Jul 28 22:30:17 localhost EIP is at __d_lookup+0x66/0xe0
Jul 28 22:30:17 localhost eax: 00284951   ebx: 00ffffff   ecx: 00000011   edx: c
1819180
Jul 28 22:30:17 localhost esi: 00ffffff   edi: f7bb1005   ebp: efa49688   esp: e
4837dc0
Jul 28 22:30:17 localhost ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Jul 28 22:30:17 localhost Process utempter (pid: 4308, ti=e4836000 task=f7c34090
 task.ti=e4836000)
Jul 28 22:30:17 localhost Stack: 00284951 e4837e1c e4837e3c f7d3a5ec e4837e48 00
000003 f7bb1005 f7bb1009 
Jul 28 22:30:17 localhost e4837e3c e4837f04 e4837e3c c0162f48 e4837e48 c18e6e20 
c0158690 c1b54cc0 


I have absolutely no idea what triggers this crash.

cheers,
herp
