Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbZELIGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbZELIGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZELIF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:05:56 -0400
Received: from mail-qy0-f129.google.com ([209.85.221.129]:46914 "EHLO
	mail-qy0-f129.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbZELIFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=p3cub/7b+HKMjbSBtfkr+/jJE7TODNJ1+nVwKO7t6dvDLN+mK8d7Rw2Ap3iJVtZIMe
         FIKyFbFeVTtHa85Sn9MNOtVD9GyunVFv6qJIRNWHrVmK8Dk6A/SsposqrO/oO3mxkvn0
         xReh+YqIcj2n+EVZ0pkqQUVLhmFsWcxFIUys4=
MIME-Version: 1.0
Date: Tue, 12 May 2009 13:35:54 +0530
Message-ID: <aecf5e530905120105o580f120bi13d213c2c9237101@mail.gmail.com>
Subject: recursive locking detected in usbnet file
From: Sasa Sasa <sasak.1983@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am getting the following dump in usbnet while disabling the
interface eth0 on linux-2.6.27. Has anybody seen this dump earlier or
is there any patch on later kernel version? This will occur only when
we enable kernel hacking options like lock detection etc.

Regards
Sasa

Dump:-

ifconfig eth0 down

=============================================
[ INFO: possible recursive locking detected ]
2.6.27-ndk20-dirty #14
---------------------------------------------
exe/330 is trying to acquire lock:
 (&list->lock){++..}, at: [<c02d802c>] defer_bh+0xfc/0x218

but task is already holding lock:
 (&list->lock){++..}, at: [<c02d7d14>] unlink_urbs+0x60/0x17c

other info that might help us debug this:
2 locks held by exe/330:
 #0:  (rtnl_mutex){--..}, at: [<c03c2d78>] rtnl_lock+0x3c/0x60
 #1:  (&list->lock){++..}, at: [<c02d7d14>] unlink_urbs+0x60/0x17c

stack backtrace:
[<c00528f8>] (dump_stack+0x0/0x54) from [<c00ed1b4>]
(validate_chain+0x12b8/0x2aa0)
 r7:00000000 r6:00000001 r4:00000001
[<c00ebefc>] (validate_chain+0x0/0x2aa0) from [<c00f0368>]
(__lock_acquire+0x19cc/0x1b1c)
[<c00ee99c>] (__lock_acquire+0x0/0x1b1c) from [<c00f0654>]
(lock_acquire+0x19c/0x238)
[<c00f04b8>] (lock_acquire+0x0/0x238) from [<c04995c4>]
(_spin_lock_irqsave+0xf0/0x148)
[<c04994d4>] (_spin_lock_irqsave+0x0/0x148) from [<c02d802c>]
(defer_bh+0xfc/0x218)
[<c02d7f30>] (defer_bh+0x0/0x218) from [<c02d9dd4>] (rx_complete+0x29c/0x3f8)
[<c02d9b38>] (rx_complete+0x0/0x3f8) from [<c0320e14>]
(usb_hcd_giveback_urb+0x1dc/0x2c4)
[<c0320c38>] (usb_hcd_giveback_urb+0x0/0x2c4) from [<c03559cc>]
(__musb_giveback+0x17c/0x1e0)
[<c0355850>] (__musb_giveback+0x0/0x1e0) from [<c0355c88>]
(musb_giveback+0x258/0x488)
[<c0355a30>] (musb_giveback+0x0/0x488) from [<c0355f64>]
(musb_advance_schedule+0xac/0x284)
[<c0355eb8>] (musb_advance_schedule+0x0/0x284) from [<c03564d4>]
(musb_cleanup_urb+0x398/0x3e0)
[<c035613c>] (musb_cleanup_urb+0x0/0x3e0) from [<c0358c50>]
(musb_urb_dequeue+0x320/0x3dc)
[<c0358930>] (musb_urb_dequeue+0x0/0x3dc) from [<c0321110>]
(unlink1+0x214/0x260)
[<c0320efc>] (unlink1+0x0/0x260) from [<c0322e28>]
(usb_hcd_unlink_urb+0x78/0xf4)
[<c0322db0>] (usb_hcd_unlink_urb+0x0/0xf4) from [<c0324d2c>]
(usb_unlink_urb+0xb0/0xd4)
[<c0324c7c>] (usb_unlink_urb+0x0/0xd4) from [<c02d7d60>]
(unlink_urbs+0xac/0x17c)
 r7:c7ec8e48 r6:c0a1cfe0 r5:c0a1cfe0 r4:c6125af8
[<c02d7cb4>] (unlink_urbs+0x0/0x17c) from [<c02da6b4>] (usbnet_stop+0x2a4/0x550)
[<c02da410>] (usbnet_stop+0x0/0x550) from [<c03a31a0>] (dev_close+0x19c/0x220)
[<c03a3004>] (dev_close+0x0/0x220) from [<c03a2b74>]
(dev_change_flags+0x17c/0x3fc)
 r9:00000000 r8:00000001 r7:00001042 r6:c0a439b8 r5:00000000
r4:c03a3004
