Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbZJMMBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbZJMMBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbZJMMBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:01:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37212 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbZJMMBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:01:02 -0400
Date: Tue, 13 Oct 2009 14:00:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Subject: 2.6.32-rc3+: bluetooth needs lockdep anotation?
Message-ID: <20091013120018.GA29395@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I just got this in my dmesg:

							Pavel


drivers/usb/core/inode.c: creating file '005'
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub
uhci_hcd 0000:00:1d.3: reserve dev 5 ep81-INT, period 1, phase 0, 23 us
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
Pid: 1696, comm: udevd Not tainted 2.6.32-rc3-00192-gd33e6ec-dirty #78
Call Trace:
 [<c079e978>] ? printk+0x18/0x1a
 [<c0256432>] __lock_acquire+0x492/0xac0
 [<c0256ac8>] lock_acquire+0x68/0x90
 [<c067e3cd>] ? skb_dequeue+0x1d/0x70
 [<c07a1a5b>] _spin_lock_irqsave+0x3b/0x50
 [<c067e3cd>] ? skb_dequeue+0x1d/0x70
 [<c067e3cd>] skb_dequeue+0x1d/0x70
 [<c067f084>] skb_queue_purge+0x14/0x30
 [<c071fe8f>] l2cap_recv_frame+0x5df/0x32c0
 [<c025617d>] ? __lock_acquire+0x1dd/0xac0
 [<c025617d>] ? __lock_acquire+0x1dd/0xac0
 [<c067e2d9>] ? skb_queue_tail+0x39/0x50
 [<c025617d>] ? __lock_acquire+0x1dd/0xac0
 [<c025617d>] ? __lock_acquire+0x1dd/0xac0
 [<c0722d02>] l2cap_recv_acldata+0x192/0x3d0
 [<c0713d50>] ? hci_rx_task+0x280/0x460
 [<c0722b70>] ? l2cap_recv_acldata+0x0/0x3d0
 [<c0713d83>] hci_rx_task+0x2b3/0x460
 [<c025617d>] ? __lock_acquire+0x1dd/0xac0
 [<c02362d0>] tasklet_action+0x50/0xb0
 [<c0236a35>] __do_softirq+0x85/0x110
 [<c0236aed>] do_softirq+0x2d/0x40
 [<c0236c55>] irq_exit+0x65/0x90
 [<c0204c1f>] do_IRQ+0x4f/0xc0
 [<c025617d>] ? __lock_acquire+0x1dd/0xac0
 [<c02034a9>] common_interrupt+0x29/0x30
 [<c07a183a>] ? _spin_unlock_irqrestore+0x2a/0x40
 [<c0223f00>] __wake_up+0x40/0x50
 [<c030167e>] journal_stop+0x27e/0x2b0
 [<c02f4577>] __ext3_journal_stop+0x27/0x50
 [<c02ecdd9>] ext3_delete_inode+0x99/0xf0
 [<c02ecd40>] ? ext3_delete_inode+0x0/0xf0
 [<c02accf2>] generic_delete_inode+0x72/0x110
 [<c02acddf>] generic_drop_inode+0x4f/0x80
 [<c02abcf7>] iput+0x47/0x50
 [<c02a926f>] dentry_iput+0x6f/0xf0
 [<c02a93a5>] d_kill+0x25/0x50
 [<c02a9abd>] dput+0x5d/0x110
 [<c02a4125>] do_rmdir+0xb5/0xe0
 [<c024a296>] ? up_read+0x16/0x30
 [<c021c19e>] ? do_page_fault+0x15e/0x250
 [<c02a41b0>] sys_rmdir+0x10/0x20
 [<c0202e50>] sysenter_do_call+0x12/0x31
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
wlan0: Selected IBSS BSSID 7a:ad:1e:84:b0:4c based on configured SSID
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
wlan0: Selected IBSS BSSID 7a:ad:1e:84:b0:4c based on configured SSID


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
