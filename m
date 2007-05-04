Return-Path: <linux-kernel-owner+w=401wt.eu-S1031377AbXEDQgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031377AbXEDQgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031381AbXEDQgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:36:32 -0400
Received: from mailgate.ics.forth.gr ([139.91.1.2]:54818 "EHLO
	mailgate.ics.forth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031377AbXEDQgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:36:31 -0400
Message-ID: <1178296546.463b60e24ce76@webmail.ics.forth.gr>
Date: Fri,  4 May 2007 19:35:46 +0300
From: mcatos@ics.forth.gr
To: linux-kernel@vger.kernel.org
Subject: Re: Error using the buffer cache
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1253
Content-Transfer-Encoding: 8bit
User-Agent: Internet Messaging Program (IMP) 3.2.1
X-Originating-IP: 139.91.70.46
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have isolated the problem a little bit. Here's what I do:

struct buffer_head *bh;
sector_t sector = 0;
bh = __bread(bdev, sector, bdev_get_queue(bdev)->hardsect_size);
brelse(bh);
sector++;
bh = __bread(bdev, sector, bdev_get_queue(bdev)->hardsect_size);
brelse(bh);

And I get this error:

BUG: soft lockup detected on CPU#1!
[] show_trace_log_lvl+0x185/0x1a0
[] show_trace+0x12/0x20
[] dump_stack+0x19/0x20
[] softlockup_tick+0x9e/0xd0
[] run_local_timers+0x12/0x20
[] update_process_times+0x34/0x80
[] smp_apic_timer_interrupt+0x6d/0x80
[] apic_timer_interrupt+0x2a/0x30
[] _read_unlock_irq+0x24/0x30
DWARF2 unwinder stuck at _read_unlock_irq+0x24/0x30
Leftover inexact backtrace:
[] show_trace+0x12/0x20
[] dump_stack+0x19/0x20
[] softlockup_tick+0x9e/0xd0
[] run_local_timers+0x12/0x20
[] update_process_times+0x34/0x80
[] smp_apic_timer_interrupt+0x6d/0x80
[] apic_timer_interrupt+0x2a/0x30
[] find_lock_page+0x85/0xa0
[] find_or_create_page+0x3b/0xb0
[] __getblk+0xef/0x2e0
[] __bread+0x12/0xb0

What am I doing wrong?



-------------------------------------------------
This mail sent through IMP: http://horde.org/imp/

