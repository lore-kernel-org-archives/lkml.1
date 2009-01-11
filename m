Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZAKULi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZAKULi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 15:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZAKULM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 15:11:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52822 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZAKULL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 15:11:11 -0500
Date: Sun, 11 Jan 2009 21:10:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Subject: native_smp_send_reschedule WARN_ON in .29rc1 on reboot
Message-ID: <20090111201043.GA17990@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just got this while rebooting 2.6.29rc1.

-Andi

sd 0:0:0:0: [sda] Synchronizing SCSI cache
igb 0000:01:00.1: PME# enabled
igb 0000:01:00.1: PME# enabled
igb 0000:01:00.0: PME# enabled
igb 0000:01:00.0: PME# enabled
Restarting system.
machine restart
------------[ cut here ]------------
WARNING: at /home/lsrc/git/linux-2.6/arch/x86/kernel/smp.c:118 resched_cpu+0x65/0x78()
Hardware name: ...
Modules linked in:
Pid: 6777, comm: reboot Not tainted 2.6.29-rc1 #59
Call Trace:
 <IRQ>  [<ffffffff802393bb>] warn_slowpath+0xd8/0xf5
 [<ffffffff8022ef6e>] place_entity+0x52/0x75
 [<ffffffff8022e3b8>] target_load+0x2a/0x4f
 [<ffffffff8037e6e8>] cpumask_next_and+0x2a/0x3e
 [<ffffffff80230fb3>] find_busiest_group+0x263/0x795
 [<ffffffff80250aad>] getnstimeofday+0x57/0xb7
 [<ffffffff8024d307>] ktime_get_ts+0x22/0x4b
 [<ffffffff8022f987>] resched_cpu+0x65/0x78
 [<ffffffff80250aad>] getnstimeofday+0x57/0xb7
 [<ffffffff8024d307>] ktime_get_ts+0x22/0x4b
 [<ffffffff80250aad>] getnstimeofday+0x57/0xb7
 [<ffffffff8022ee64>] update_curr+0x57/0x9b
 [<ffffffff8022f987>] resched_cpu+0x65/0x78
 [<ffffffff80236bfb>] scheduler_tick+0x12d/0x1c0
 [<ffffffff80241c47>] update_process_times+0x44/0x50
 [<ffffffff80254125>] tick_sched_timer+0x76/0x9c
 [<ffffffff8024cbbe>] __run_hrtimer+0x6a/0x9c
 [<ffffffff8024d3fc>] hrtimer_interrupt+0x8b/0xd9
 [<ffffffff8021dd2d>] smp_apic_timer_interrupt+0x8e/0xac
 [<ffffffff8020c8f3>] apic_timer_interrupt+0x13/0x20
 <EOI> <4>---[ end trace 47498389a6a28900 ]---
-- 
ak@linux.intel.com
