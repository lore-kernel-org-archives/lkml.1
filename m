Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbZLAPNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbZLAPNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZLAPNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:13:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49164 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbZLAPNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:13:31 -0500
Date: Tue, 1 Dec 2009 16:13:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: divide by zero in termios when setting bluetooth
Message-ID: <20091201151315.GC2262@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I triggered this by mistake... "W" taint is from the  WARN_ON()
before.
							Pavel

root@amd:~# setserial /dev/ttyBT baud_base $[115200*1]
root@amd:~# echo $[115200/8]
14400
root@amd:~# hciattach -s 14400 /dev/ttyS0 bcsp 1440
divide error: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/firmware/0000:03:00.0/loading
Modules linked in:

Pid: 2058, comm: hciattach Tainted: G        W
(2.6.32-rc8-00165-g2471433-dirty #92) 17097HU
EIP: 0060:[<c043de2f>] EFLAGS: 00010246 CPU: 1
EIP is at uart_get_divisor+0x1f/0x40
EAX: 001c2000 EBX: 00000000 ECX: c0f9bf40 EDX: 00000000
ESI: c0f9bf40 EDI: f6316550 EBP: c5fe7d0c ESP: c5fe7d08
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process hciattach (pid: 2058, ti=c5fe6000 task=f6096680
task.ti=c5fe6000)
Stack:
 00000013 c5fe7d3c c0442780 00000007 00007080 00000000 00000001
00000000
<0> 00000001 c03e1d6b c09e6d80 c0f9bf40 c5fe7d98 c5fe7d50 c043deaf
f631f7f0
<0> c5fe7d98 f631f7f0 c5fe7d7c c043e57d f58fc7f0 f631f868 00001cb7
22222222
Call Trace:
 [<c0442780>] ? serial8250_set_termios+0x360/0x420
 [<c03e1d6b>] ? set_termios+0xcb/0x430
 [<c043deaf>] ? uart_change_speed+0x5f/0x90
 [<c043e57d>] ? uart_set_termios+0x3d/0x250
 [<c03e1efd>] ? set_termios+0x25d/0x430
 [<c03e2560>] ? tty_mode_ioctl+0x3c0/0x5b0
 [<c03dcf33>] ? tty_wakeup+0x33/0x70
 [<c03e299b>] ? tty_ldisc_try+0x1b/0x50
 [<c03e278a>] ? n_tty_ioctl_helper+0x3a/0x190
Dec  1 12:30:25 amd kernel:  [<c0594c5e>] ?
hci_uart_tty_ioctl+0x5e/0x240
Dec  1 12:30:25 amd kernel:  [<c0594c00>] ?
hci_uart_tty_ioctl+0x0/0x240
Dec  1 12:30:25 amd kernel:  [<c0594c00>] ?
hci_uart_tty_ioctl+0x0/0x240
Dec  1 12:30:25 amd kernel:  [<c03dd1be>] ? tty_ioctl+0xae/0x880
Dec  1 12:30:25 amd kernel:  [<c03dd110>] ? tty_ioctl+0x0/0x880
Dec  1 12:30:25 amd kernel:  [<c02a4ae8>] ? vfs_ioctl+0x28/0x80
Dec  1 12:30:25 amd kernel:  [<c02a4faa>] ? do_vfs_ioctl+0x39a/0x590
Dec  1 12:30:25 amd kernel:  [<c0282037>] ? handle_mm_fault+0xe7/0x5e0
Dec  1 12:30:25 amd kernel:  [<c0249646>] ? up_read+0x16/0x30
Dec  1 12:30:25 amd kernel:  [<c02a51d9>] ? sys_ioctl+0x39/0x70
Dec  1 12:30:25 amd kernel:  [<c0202e50>] ? sysenter_do_call+0x12/0x31
Dec  1 12:30:25 amd kernel: Code: 86 84 00 00 00 5e 5d c3 8d 74 26 00
55 81 fa 00 96 00 00 89 e5 89 c1 53 89 d3 74 18 8d 04 dd 00 00 00 00
31 d2 03 41 34 c1 e3 04 <f7> f3 5b 5d c3 8d 74 26 00 8b 40 7c 25
30 10 00 00 83 f8 30 75
Dec  1 12:30:25 amd kernel: EIP: [<c043de2f>]
uart_get_divisor+0x1f/0x40 SS:ESP 0068:c5fe7d08
Dec  1 12:30:25 amd kernel: ---[ end trace bab0b3b26c16fcf6 ]---

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
