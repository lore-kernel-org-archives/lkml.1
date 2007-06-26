Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbXFZKa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbXFZKa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 06:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXFZKaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 06:30:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:36226 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751984AbXFZKaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 06:30:18 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX1/eBOwHrPjeSGuss1mCfMKgjhAxQDSdPEh6BKmzCM
	+8pPV6s9unoLQR
Message-ID: <4680EAB8.10703@gmx.de>
Date: Tue, 26 Jun 2007 12:30:16 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG: held lock freed!
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there ...

I removed xfs from my system. The first reboot after replacing xfs with
ext3 brought be

Jun 26 08:43:17 pearl =========================
Jun 26 08:43:17 pearl [ BUG: held lock freed! ]
Jun 26 08:43:17 pearl -------------------------
Jun 26 08:43:17 pearl udevd/3064 is freeing memory c16fbe40-c16fbe7f,
with a lock still held there!
Jun 26 08:43:17 pearl (&sbinfo->stat_lock){--..}, at: [<c0157eb1>]
shmem_delete_inode+0xc1/0xda
Jun 26 08:43:17 pearl 1 lock held by udevd/3064:
Jun 26 08:43:17 pearl #0:  (&sbinfo->stat_lock){--..}, at: [<c0157eb1>]
shmem_delete_inode+0xc1/0xda
Jun 26 08:43:17 pearl
Jun 26 08:43:17 pearl stack backtrace:
Jun 26 08:43:17 pearl [<c0135331>] debug_check_no_locks_freed+0xe7/0x11a
Jun 26 08:43:17 pearl [<c0158649>] kfree+0x45/0x7f
Jun 26 08:43:17 pearl [<c016c3d2>] free_fdtable_rcu+0x3a/0x70
Jun 26 08:43:17 pearl [<c012a95f>] __rcu_process_callbacks+0xfd/0x165
Jun 26 08:43:17 pearl [<c012a9d6>] rcu_process_callbacks+0xf/0x1e
Jun 26 08:43:17 pearl [<c0120c69>] tasklet_action+0x3d/0x68
Jun 26 08:43:17 pearl [<c0120b9e>] __do_softirq+0x41/0x92
Jun 26 08:43:17 pearl [<c0120c16>] do_softirq+0x27/0x3d
Jun 26 08:43:17 pearl [<c0120fae>] irq_exit+0x35/0x64
Jun 26 08:43:17 pearl [<c0106108>] do_IRQ+0x7e/0x92
Jun 26 08:43:17 pearl [<c0104634>] common_interrupt+0x24/0x34
Jun 26 08:43:17 pearl [<c010463e>] common_interrupt+0x2e/0x34
Jun 26 08:43:17 pearl [<c0136513>] lock_acquire+0x68/0x6e
Jun 26 08:43:17 pearl [<c0157eb1>] shmem_delete_inode+0xc1/0xda
Jun 26 08:43:17 pearl [<c02e4daa>] _spin_lock+0x29/0x34
Jun 26 08:43:17 pearl [<c0157eb1>] shmem_delete_inode+0xc1/0xda
Jun 26 08:43:17 pearl [<c0157eb1>] shmem_delete_inode+0xc1/0xda
Jun 26 08:43:17 pearl [<c0157df0>] shmem_delete_inode+0x0/0xda
Jun 26 08:43:17 pearl [<c016b2a8>] generic_delete_inode+0x8c/0xf4
Jun 26 08:43:17 pearl [<c016aa33>] iput+0x60/0x62
Jun 26 08:43:17 pearl [<c01636d7>] do_unlinkat+0xbe/0x132
Jun 26 08:43:17 pearl [<c0103bfa>] sysenter_past_esp+0x8f/0x99
Jun 26 08:43:17 pearl [<c0135227>] trace_hardirqs_on+0x11e/0x141
Jun 26 08:43:17 pearl [<c0103bca>] sysenter_past_esp+0x5f/0x99
Jun 26 08:43:17 pearl =======================

But it only came once, several reboots after that were ok. I changed my
kernel config today: e1000 is now "=y" (was "=m"), I removed PCMCIA as I
do not use it and some other modules complained about it, and I added
CONFIG_HIGHMEM4G=y (was CONFIG_NOHIGHMEM=y)

The running kernel is 2.6.22.5 +cfs +squashfs. My distribution is gentoo
(x86), quite up to date, udev is 104-r12.

Please CC me as I'm not subscribed to the list.

Thomas

-- 
keep mailinglists in english, feel free to send PM in german
