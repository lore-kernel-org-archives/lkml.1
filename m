Return-Path: <linux-kernel-owner+w=401wt.eu-S1761523AbXHCCxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523AbXHCCxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 22:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbXHCCxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 22:53:34 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:1874 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbXHCCxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 22:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=j0jl2Z6H9SxcdIiFAmKfGDPSGhA8fNEcTApTuk5welHYh0XGXWUhM+eyDjpIMbypfdt17YzOvx6Ubi/pX4jH8WKn8HbKyN6jQzb0gTg7Bb/qBU+5MvkWAKv7p6i3o05q/EHbsM0wPCa/isRIXFy9pXIH8NSMVEZOO9TrlSwmvlE=
Message-ID: <a44ae5cd0708021953q79d03484k3c191bfe4894cd9a@mail.gmail.com>
Date: Thu, 2 Aug 2007 19:53:32 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jgarzik@pobox.com>
Subject: 2.6.23-rc1-mm2 + cpufreq patch -- inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am running Ubuntu Gutsy with latest updates.
When I run "/etc/init.d/networking stop" with my custom kernel, I get:

=================================
[ INFO: inconsistent lock state ]
2.6.23-rc1-mm2 #21
---------------------------------
inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
ifconfig/8982 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&tp->lock){++..}, at: [<f8b9d65a>] rtl8139_interrupt+0x22/0x377 [8139too]
{in-hardirq-W} state was registered at:
  [<c0144837>] __lock_acquire+0x430/0xbca
  [<c0145047>] lock_acquire+0x76/0x9d
  [<c031ffe0>] _spin_lock+0x23/0x32
  [<f8b9d65a>] rtl8139_interrupt+0x22/0x377 [8139too]
  [<c0154b44>] handle_IRQ_event+0x1a/0x4f
  [<c0155c6c>] handle_fasteoi_irq+0x7d/0xb6
  [<c0109a5a>] do_IRQ+0xaf/0xd9
  [<ffffffff>] 0xffffffff
irq event stamp: 1501
hardirqs last  enabled at (1501): [<c0173232>] kfree+0xc7/0xdb
hardirqs last disabled at (1500): [<c01731d2>] kfree+0x67/0xdb
softirqs last  enabled at (1480): [<c02cf082>] dev_deactivate+0x87/0xa0
softirqs last disabled at (1478): [<c031fffa>] _spin_lock_bh+0xb/0x37

other info that might help us debug this:
1 lock held by ifconfig/8982:
 #0:  (rtnl_mutex){--..}, at: [<c031ed95>] mutex_lock+0x1c/0x1f

stack backtrace:
 [<c01080ab>] show_trace_log_lvl+0x12/0x25
 [<c0108a9e>] show_trace+0xd/0x10
 [<c0108bac>] dump_stack+0x16/0x18
 [<c0143374>] print_usage_bug+0x107/0x114
 [<c0143bdd>] mark_lock+0x1e9/0x400
 [<c01448ab>] __lock_acquire+0x4a4/0xbca
 [<c0145047>] lock_acquire+0x76/0x9d
 [<c031ffe0>] _spin_lock+0x23/0x32
 [<f8b9d65a>] rtl8139_interrupt+0x22/0x377 [8139too]
 [<c015506f>] free_irq+0xc9/0xf2
 [<f8b9ef56>] rtl8139_close+0xac/0x14a [8139too]
 [<c02c2135>] dev_close+0x4e/0x6b
 [<c02c128a>] dev_change_flags+0x9f/0x152
 [<c03015f2>] devinet_ioctl+0x209/0x506
 [<c0301f5a>] inet_ioctl+0x86/0xa4
 [<c02b8211>] sock_ioctl+0x1a9/0x1c7
 [<c017ffca>] do_ioctl+0x22/0x67
 [<c0180258>] vfs_ioctl+0x249/0x25c
 [<c0180297>] sys_ioctl+0x2c/0x45
 [<c0106f02>] sysenter_past_esp+0x6b/0xb5
 =======================
eth2: link down
