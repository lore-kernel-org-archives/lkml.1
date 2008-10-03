Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYJCEYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYJCEYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 00:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYJCEYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 00:24:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:34085 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYJCEYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 00:24:08 -0400
Date: Thu, 2 Oct 2008 21:23:55 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002212355.621a4fb6@infradead.org>
In-Reply-To: <20081002210117.0f5062f7@infradead.org>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<20081002062736.GR19428@kernel.dk>
	<20081001235501.2b7f50fe.akpm@linux-foundation.org>
	<20081002061236.3c71c877@infradead.org>
	<20081002132457.46ad8d05.akpm@linux-foundation.org>
	<20081002210117.0f5062f7@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 21:01:17 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> > _
> > 
> > perhaps for varying values of "1".
> 

caught a few, a few were over 3 1/2 seconds in stall time 
(specifically I know this for the last one)

(I've stripped out the ? entries to keep them reasonable)

[  410.168277] WARNING: at kernel/sched.c:5652 io_schedule+0x77/0xb0()
[  410.168347] Pid: 699, comm: kjournald Not tainted 2.6.27-rc8-tip #50
[  410.168366]  [<c042ee64>] warn_on_slowpath+0x41/0x65
[  410.168414]  [<c070ec83>] io_schedule+0x77/0xb0
[  410.168421]  [<c04abc72>] sync_buffer+0x33/0x37
[  410.168429]  [<c070f123>] __wait_on_bit+0x36/0x5d
[  410.168445]  [<c070f1f5>] out_of_line_wait_on_bit+0xab/0xb3
[  410.168471]  [<c04abbd1>] __wait_on_buffer+0x19/0x1c
[  410.168478]  [<c04de796>] journal_commit_transaction+0x484/0xcb2
[  410.168519]  [<c04e14ae>] kjournald+0xc7/0x1ea
[  410.168544]  [<c043fb87>] kthread+0x3b/0x61
[  410.168559]  [<c040499f>] kernel_thread_helper+0x7/0x10
[  410.168567]  =======================
[  410.168572] ---[ end trace de523043f88bd9a7 ]---
[  451.605034] ------------[ cut here ]------------
[  451.605041] WARNING: at kernel/sched.c:5652 io_schedule+0x77/0xb0()
[  451.605114] Pid: 699, comm: kjournald Tainted: G        W 2.6.27-rc8-tip #50
[  451.605133]  [<c042ee64>] warn_on_slowpath+0x41/0x65
[  451.605182]  [<c070ec83>] io_schedule+0x77/0xb0
[  451.605189]  [<c04abc72>] sync_buffer+0x33/0x37
[  451.605198]  [<c070f123>] __wait_on_bit+0x36/0x5d
[  451.605213]  [<c070f1f5>] out_of_line_wait_on_bit+0xab/0xb3
[  451.605240]  [<c04abbd1>] __wait_on_buffer+0x19/0x1c
[  451.605248]  [<c04de796>] journal_commit_transaction+0x484/0xcb2
[  451.605300]  [<c04e14ae>] kjournald+0xc7/0x1ea
[  451.605324]  [<c043fb87>] kthread+0x3b/0x61
[  451.605339]  [<c040499f>] kernel_thread_helper+0x7/0x10
[  451.605348]  =======================
[  451.605353] ---[ end trace de523043f88bd9a7 ]---
[  514.780993] ------------[ cut here ]------------
[  514.781001] WARNING: at kernel/sched.c:5652 io_schedule+0x77/0xb0()
[  514.781074] Pid: 699, comm: kjournald Tainted: G        W 2.6.27-rc8-tip #50
[  514.781092]  [<c042ee64>] warn_on_slowpath+0x41/0x65
[  514.781152]  [<c070ec83>] io_schedule+0x77/0xb0
[  514.781159]  [<c04abc72>] sync_buffer+0x33/0x37
[  514.781167]  [<c070f010>] __wait_on_bit_lock+0x34/0x5e
[  514.781183]  [<c070f0e5>] out_of_line_wait_on_bit_lock+0xab/0xb3
[  514.781210]  [<c04abfa1>] __lock_buffer+0x24/0x2a
[  514.781218]  [<c04de597>] journal_commit_transaction+0x285/0xcb2
[  514.781288]  [<c04e14ae>] kjournald+0xc7/0x1ea
[  514.781313]  [<c043fb87>] kthread+0x3b/0x61
[  514.781334]  [<c040499f>] kernel_thread_helper+0x7/0x10
[  514.781345]  =======================
[  514.781352] ---[ end trace de523043f88bd9a7 ]---
[  517.064300] ------------[ cut here ]------------
[  517.064379] Pid: 699, comm: kjournald Tainted: G        W 2.6.27-rc8-tip #50
[  517.064398]  [<c042ee64>] warn_on_slowpath+0x41/0x65
[  517.064474]  [<c070ec83>] io_schedule+0x77/0xb0
[  517.064481]  [<c04abc72>] sync_buffer+0x33/0x37
[  517.064490]  [<c070f123>] __wait_on_bit+0x36/0x5d
[  517.064505]  [<c070f1f5>] out_of_line_wait_on_bit+0xab/0xb3
[  517.064530]  [<c04abbd1>] __wait_on_buffer+0x19/0x1c
[  517.064538]  [<c04de796>] journal_commit_transaction+0x484/0xcb2
[  517.064579]  [<c04e14ae>] kjournald+0xc7/0x1ea
[  517.064603]  [<c043fb87>] kthread+0x3b/0x61
[  517.064618]  [<c040499f>] kernel_thread_helper+0x7/0x10
[  517.064626]  =======================
[  517.064631] ---[ end trace de523043f88bd9a7 ]---
[  517.067487] ------------[ cut here ]------------
[  517.067493] WARNING: at kernel/sched.c:5652 io_schedule+0x77/0xb0()
[  517.067556] Pid: 4320, comm: claws-mail Tainted: G        W 2.6.27-rc8-tip #50
[  517.067572]  [<c042ee64>] warn_on_slowpath+0x41/0x65
[  517.067652]  [<c070ec83>] io_schedule+0x77/0xb0
[  517.067659]  [<c04abc72>] sync_buffer+0x33/0x37
[  517.067666]  [<c070f010>] __wait_on_bit_lock+0x34/0x5e
[  517.067682]  [<c070f0e5>] out_of_line_wait_on_bit_lock+0xab/0xb3
[  517.067707]  [<c04abfa1>] __lock_buffer+0x24/0x2a
[  517.067715]  [<c04dd7fc>] do_get_write_access+0x64/0x3b1
[  517.067743]  [<c04ddb64>] journal_get_write_access+0x1b/0x2a
[  517.067752]  [<c04da374>] __ext3_journal_get_write_access+0x19/0x3c
[  517.067761]  [<c04cf672>] ext3_reserve_inode_write+0x34/0x68
[  517.067769]  [<c04cf6d5>] ext3_mark_inode_dirty+0x2f/0x46
[  517.067777]  [<c04cf7f7>] ext3_dirty_inode+0x53/0x67
[  517.067784]  [<c04a7bed>] __mark_inode_dirty+0x29/0x144
[  517.067794]  [<c049e60f>] file_update_time+0x80/0xa9
[  517.067803]  [<c046b66c>] __generic_file_aio_write_nolock+0x2f0/0x41b
[  517.067842]  [<c046bf0d>] generic_file_aio_write+0x5a/0xb7
[  517.067850]  [<c04cdc65>] ext3_file_write+0x1a/0x89
[  517.067858]  [<c048da41>] do_sync_write+0xab/0xe9
[  517.067896]  [<c048e302>] vfs_write+0x8a/0x12e
[  517.067903]  [<c048e43f>] sys_write+0x3b/0x60
[  517.067910]  [<c0403b0b>] sysenter_do_call+0x12/0x2f
[  517.067919]  =======================
[  517.067923] ---[ end trace de523043f88bd9a7 ]---


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
