Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbZGHRRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbZGHRRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbZGHRRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:17:44 -0400
Received: from lazybastard.de ([212.112.238.170]:39865 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbZGHRRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:17:43 -0400
Date: Wed, 8 Jul 2009 19:17:32 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MAX_STACK_TRACE_ENTRIES too low (2.6.31-rc2)
Message-ID: <20090708171732.GB1650@logfs.org>
References: <20090707163223.GA24481@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090707163223.GA24481@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 July 2009 12:32:23 -0400, Dave Jones wrote:
> 
> I see this every time I boot.

Same here, with a slightly different backtrace.  Seems to go away
after quadrupling the value.  Not that I understand any of it.

BUG: MAX_STACK_TRACE_ENTRIES too low!
turning off the locking correctness validator.
Pid: 264, comm: pdflush Not tainted 2.6.31-rc2 #4
Call Trace:
 [<ffffffff81016c7b>] ? save_stack_trace+0x2f/0x4d
 [<ffffffff8106c8b9>] save_trace+0x93/0x9b
 [<ffffffff8106c940>] add_lock_to_list+0x7f/0xc0
 [<ffffffff810706c9>] __lock_acquire+0x135c/0x16bb
 [<ffffffff8122877e>] ? scsi_setup_fs_cmnd+0xbc/0xc5
 [<ffffffff81227dc2>] ? scsi_request_fn+0x1cd/0x535
 [<ffffffff81070af7>] lock_acquire+0xcf/0xfb
 [<ffffffff81227dc2>] ? scsi_request_fn+0x1cd/0x535
 [<ffffffff813235bf>] _spin_lock+0x36/0x6b
 [<ffffffff81227dc2>] ? scsi_request_fn+0x1cd/0x535
 [<ffffffff81323428>] ? _spin_unlock+0x2b/0x2f
 [<ffffffff81227dc2>] scsi_request_fn+0x1cd/0x535
 [<ffffffff81173a63>] __generic_unplug_device+0x35/0x3a
 [<ffffffff8116deab>] elv_insert+0x24f/0x258
 [<ffffffff8116df53>] __elv_add_request+0x9f/0xa7
 [<ffffffff81174640>] __make_request+0x38c/0x40b
 [<ffffffff81171cb5>] generic_make_request+0x326/0x370
 [<ffffffff8106e3cd>] ? mark_held_locks+0x4d/0x6b
 [<ffffffff81171dca>] submit_bio+0xcb/0xd4
 [<ffffffff8110b87b>] submit_bh+0x106/0x12a
 [<ffffffff8110e54a>] __block_write_full_page+0x1fb/0x2f6
 [<ffffffff8110ce66>] ? end_buffer_async_write+0x0/0x184
 [<ffffffff811109a6>] ? blkdev_get_block+0x0/0x65
 [<ffffffff8110e719>] block_write_full_page_endio+0xd4/0xd8
 [<ffffffff8110e732>] block_write_full_page+0x15/0x17
 [<ffffffff811118c0>] blkdev_writepage+0x18/0x1a
 [<ffffffff810bc6de>] __writepage+0x1a/0x40
 [<ffffffff810bcff0>] write_cache_pages+0x262/0x3a8
 [<ffffffff810bc6c4>] ? __writepage+0x0/0x40
 [<ffffffff810bd15d>] generic_writepages+0x27/0x2d
 [<ffffffff810bd193>] do_writepages+0x30/0x40
 [<ffffffff81106951>] writeback_single_inode+0x189/0x395
 [<ffffffff81107025>] generic_sync_sb_inodes+0x2a6/0x44a
 [<ffffffff810bdfbe>] ? pdflush+0x0/0x239
 [<ffffffff811072f7>] writeback_inodes+0xa2/0xfa
 [<ffffffff810bd30d>] wb_kupdate+0xb3/0x129
 [<ffffffff810be113>] pdflush+0x155/0x239
 [<ffffffff810bd25a>] ? wb_kupdate+0x0/0x129
 [<ffffffff8105dc98>] kthread+0x8d/0x95
 [<ffffffff8100ce8a>] child_rip+0xa/0x20
 [<ffffffff8100c810>] ? restore_args+0x0/0x30
 [<ffffffff8105dc0b>] ? kthread+0x0/0x95
 [<ffffffff8100ce80>] ? child_rip+0x0/0x20


Jörn

-- 
Correctness comes second.
Features come third.
Performance comes last.
Maintainability is easily forgotten.
