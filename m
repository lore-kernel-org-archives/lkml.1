Return-Path: <linux-kernel-owner+w=401wt.eu-S1762078AbXISQoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762078AbXISQoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbXISQoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:44:01 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1511 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbXISQoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:44:00 -0400
Date: Wed, 19 Sep 2007 17:43:48 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc6-mm1 -- mkfs stuck in 'D'
Message-ID: <20070919164348.GC2519@shadowen.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seems I have a case of a largish i386 NUMA (NUMA-Q) which has a mkfs
stuck in a 'D' wait:

 =======================
mkfs.ext2     D c10220f4     0  6233   6222
       c344fc80 00000082 00000286 c10220f4 c344fc90 002ed099 c2963340 c2b9f640
       c142bce0 c2b9f640 c344fc90 002ed099 c344fcfc c344fcc0 c1219563 c1109bf2
       c344fcc4 c186e4d4 c186e4d4 002ed099 c1022612 c2b9f640 c186e000 c104000c
Call Trace:
 [<c10220f4>] lock_timer_base+0x19/0x35
 [<c1219563>] schedule_timeout+0x70/0x8d
 [<c1109bf2>] prop_fraction_single+0x37/0x5d
 [<c1022612>] process_timeout+0x0/0x5
 [<c104000c>] task_dirty_limit+0x3a/0xb5
 [<c12194da>] io_schedule_timeout+0x1e/0x28
 [<c10454b4>] congestion_wait+0x62/0x7a
 [<c102b021>] autoremove_wake_function+0x0/0x33
 [<c10402af>] get_dirty_limits+0x16a/0x172
 [<c102b021>] autoremove_wake_function+0x0/0x33
 [<c104040b>] balance_dirty_pages+0x154/0x1be
 [<c103bda3>] generic_perform_write+0x168/0x18a
 [<c103be38>] generic_file_buffered_write+0x73/0x107
 [<c103c346>] __generic_file_aio_write_nolock+0x47a/0x4a5
 [<c11b0fef>] do_sock_write+0x92/0x99
 [<c11b1048>] sock_aio_write+0x52/0x5e
 [<c103c3b9>] generic_file_aio_write_nolock+0x48/0x9b
 [<c105d2d6>] do_sync_write+0xbf/0xfc
 [<c102b021>] autoremove_wake_function+0x0/0x33
 [<c1010311>] do_page_fault+0x2cc/0x739
 [<c105d3a0>] vfs_write+0x8d/0x108
 [<c105d4c3>] sys_write+0x41/0x67
 [<c100260a>] syscall_call+0x7/0xb
 =======================

This machine and others have run numerous test runs on this kernel and
this is the first time I've see a hang like this.

I wonder if this is the ultimate cause of the couple of mainline hangs
which were seen, but not diagnosed.

-apw
