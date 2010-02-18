Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab0BRJc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:32:27 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:34624 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab0BRJcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:32:25 -0500
Subject: sysfs lockdep complaint
From: Johannes Berg <johannes@sipsolutions.net>
To: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 10:32:23 +0100
Message-ID: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get this when powernowd starts on my G5:

[   30.490674] =============================================
[   30.490708] [ INFO: possible recursive locking detected ]
[   30.490727] 2.6.33-rc8-wl-64012-g6917413 #160
[   30.490744] ---------------------------------------------
[   30.490763] powernowd/2577 is trying to acquire lock:
[   30.490782]  (s_active){++++.+}, at: [<c0000000001efa94>] .sysfs_addrm_finish+0x58/0xc0
[   30.490831] 
[   30.490833] but task is already holding lock:
[   30.490854]  (s_active){++++.+}, at: [<c0000000001eff80>] .sysfs_get_active_two+0x3c/0x84
[   30.490895] 
[   30.490896] other info that might help us debug this:
[   30.490921] 4 locks held by powernowd/2577:
[   30.490936]  #0:  (&buffer->mutex){+.+.+.}, at: [<c0000000001ed8d0>] .sysfs_write_file+0x60/0x1a4
[   30.490983]  #1:  (s_active){++++.+}, at: [<c0000000001eff80>] .sysfs_get_active_two+0x3c/0x84
[   30.491028]  #2:  (s_active){++++.+}, at: [<c0000000001eff98>] .sysfs_get_active_two+0x54/0x84
[   30.491073]  #3:  (dbs_mutex){+.+.+.}, at: [<d000000002c9c6e8>] .cpufreq_governor_dbs+0x424/0x548 [cpufreq_ondemand]
[   30.491128] 
[   30.491130] stack backtrace:
[   30.491148] Call Trace:
[   30.491166] [c00000021251af10] [c000000000012934] .show_stack+0xc0/0x200 (unreliable)
[   30.491205] [c00000021251afe0] [c0000000005a74b0] .dump_stack+0x28/0x3c
[   30.491234] [c00000021251b060] [c0000000000b88c8] .validate_chain+0x758/0x1044
[   30.491265] [c00000021251b1a0] [c0000000000b9b94] .__lock_acquire+0x9e0/0xac4
[   30.491294] [c00000021251b2d0] [c0000000000b9dc8] .lock_acquire+0x150/0x19c
[   30.491324] [c00000021251b3a0] [c0000000001eeeb8] .sysfs_deactivate+0xd0/0x16c
[   30.491354] [c00000021251b4f0] [c0000000001efa94] .sysfs_addrm_finish+0x58/0xc0
[   30.491385] [c00000021251b590] [c0000000001ecb98] .sysfs_hash_and_remove+0x7c/0xb0
[   30.491416] [c00000021251b640] [c0000000001f1710] .sysfs_remove_group+0xb4/0x138
[   30.491450] [c00000021251b6e0] [d000000002c9c6f8] .cpufreq_governor_dbs+0x434/0x548 [cpufreq_ondemand]
[   30.491487] [c00000021251b7e0] [c0000000004cc3e4] .__cpufreq_governor+0x1cc/0x250
[   30.491520] [c00000021251b890] [c0000000004cdb90] .__cpufreq_set_policy+0x1f8/0x2a8
[   30.491552] [c00000021251b940] [c0000000004ce1a0] .store_scaling_governor+0x1c0/0x21c
[   30.491584] [c00000021251bb50] [c0000000004cd954] .store+0x98/0xdc
[   30.491611] [c00000021251bc00] [c0000000001ed9a4] .sysfs_write_file+0x134/0x1a4
[   30.491644] [c00000021251bcc0] [c000000000176ca0] .vfs_write+0xe8/0x1fc
[   30.491672] [c00000021251bd70] [c000000000176ef0] .SyS_write+0x68/0xb0
[   30.491700] [c00000021251be30] [c0000000000075d4] syscall_exit+0x0/0x40


