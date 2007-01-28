Return-Path: <linux-kernel-owner+w=401wt.eu-S1751935AbXA1MCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbXA1MCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 07:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbXA1MCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 07:02:15 -0500
Received: from mx33.mail.ru ([194.67.23.194]:31700 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXA1MCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 07:02:14 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: bluez-devel@lists.sourceforge.net
Subject: 2.6.20-rc6: LOCKDEP: possible recursive locking detected
Date: Sun, 28 Jan 2007 15:02:07 +0300
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701281502.09128.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I am not sure if I have seen it before, possibly yes.

Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
usb 1-1: new full speed USB device using ohci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb

=============================================
[ INFO: possible recursive locking detected ]
2.6.20-rc6-1avb #12
- ---------------------------------------------
kio_obex/8530 is trying to acquire lock:
 (sk_lock-AF_BLUETOOTH){--..}, at: [<dfed181f>] l2cap_sock_bind+0x3f/0xe0 
[l2cap]

but task is already holding lock:
 (sk_lock-AF_BLUETOOTH){--..}, at: [<dfef7035>] rfcomm_sock_connect+0x45/0xd0 
[rfcomm]

other info that might help us debug this:
2 locks held by kio_obex/8530:
 #0:  (sk_lock-AF_BLUETOOTH){--..}, at: [<dfef7035>] 
rfcomm_sock_connect+0x45/0xd0 [rfcomm]
 #1:  (rfcomm_mutex){--..}, at: [<c02a2fc1>] mutex_lock+0x21/0x30

stack backtrace:
 [<c0103fea>] show_trace_log_lvl+0x1a/0x30
 [<c01045f2>] show_trace+0x12/0x20
 [<c01046a6>] dump_stack+0x16/0x20
 [<c0134585>] __lock_acquire+0xad5/0xdb0
 [<c01348b7>] lock_acquire+0x57/0x70
 [<c0237d48>] lock_sock_nested+0xe8/0x100
 [<dfed181f>] l2cap_sock_bind+0x3f/0xe0 [l2cap]
 [<dfef489f>] rfcomm_dlc_open+0xaf/0x220 [rfcomm]
 [<dfef7099>] rfcomm_sock_connect+0xa9/0xd0 [rfcomm]
 [<c023685d>] sys_connect+0x5d/0x90
 [<c0236fbd>] sys_socketcall+0xbd/0x280
 [<c010300e>] sysenter_past_esp+0x5f/0x99
 =======================
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFvJDBR6LMutpd94wRAtIwAKDIpbGrwv4OWwr4Y1nMTsyUmHi63QCePElg
oRkNKcxrdHdiJjfn5deCBA4=
=RGl9
-----END PGP SIGNATURE-----
