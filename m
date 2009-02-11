Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZBKMwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZBKMwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbZBKMwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:52:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:46684 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbZBKMwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:52:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XAxtlTWy+M0kqkguScDtq9gsSfjdBCOBV6whMxsqxfJar1iKR07bVyZFzUInKq072P
         SF/9NIYKiBrk9K9zmNdl1soRuQsvHOOIXjrBEq468YaHDPcZ8y1g81QW9BhEhcsgs2/C
         7IivWOGG97UoSb38RMvP1FewZfMtucYEBUdgU=
MIME-Version: 1.0
In-Reply-To: <1234355201.23438.134.camel@twins>
References: <a4423d670902110414r72f14c1eq850cda59533bd9db@mail.gmail.com>
	 <1234355010.23438.132.camel@twins> <1234355070.23438.133.camel@twins>
	 <1234355201.23438.134.camel@twins>
Date: Wed, 11 Feb 2009 15:52:05 +0300
Message-ID: <a4423d670902110452s5fb6d041l2363c8ad9b9618fb@mail.gmail.com>
Subject: Re: next-20090211: BUG: MAX_LOCKDEP_SUBCLASSES too low!
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/11 Peter Zijlstra <peterz@infradead.org>:
> On Wed, 2009-02-11 at 13:24 +0100, Peter Zijlstra wrote:
>> On Wed, 2009-02-11 at 13:23 +0100, Peter Zijlstra wrote:
>> > On Wed, 2009-02-11 at 15:14 +0300, Alexander Beregalov wrote:
>> > > Hi
>> > >
>> > > Full dmesg is attached.
>> > >
>> > > Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
>> > > .... MAX_LOCKDEP_SUBCLASSES:  8
>> > > .... MAX_LOCK_DEPTH:          48
>> > > .... MAX_LOCKDEP_KEYS:        8191
>> > > .... CLASSHASH_SIZE:          4096
>> > > .... MAX_LOCKDEP_ENTRIES:     8192
>> > > .... MAX_LOCKDEP_CHAINS:      16384
>> > > .... CHAINHASH_SIZE:          8192
>> > >  memory used by lock dependency info: 4351 kB
>> > >  per task-struct memory footprint: 2688 bytes
>> > > <..>
>> > > BUG: MAX_LOCKDEP_SUBCLASSES too low!
>> > > turning off the locking correctness validator.
>> >
>> > Is this an allyesconfig or something other massive bloated?
>>
>> Sorry, not playing attention, its SUB classes.. let me look at that,
>> that smells like a rotten annotation.
>
> Could you run with the below patch, so that we can see where this
> happens?

BUG: MAX_LOCKDEP_SUBCLASSES too low!
turning off the locking correctness validator.
Pid: 2105, comm: btrfs-endio-wri Not tainted 2.6.29-rc4-next-20090211-dirty #2
Call Trace:
 [<ffffffff8026cbf9>] __lock_acquire+0x6b9/0x12c0
 [<ffffffff8026d891>] lock_acquire+0x91/0xc0
 [<ffffffff80447324>] ? btrfs_tree_lock+0xc4/0x160
 [<ffffffff8062eb36>] _spin_lock_nested+0x46/0x80
 [<ffffffff80447324>] ? btrfs_tree_lock+0xc4/0x160
 [<ffffffff80447324>] btrfs_tree_lock+0xc4/0x160
 [<ffffffff804471a0>] ? btrfs_wake_function+0x0/0x10
 [<ffffffff8040bce6>] btrfs_init_new_buffer+0xa6/0x150
 [<ffffffff80412fa1>] btrfs_alloc_free_block+0x81/0x90
 [<ffffffff80402a16>] __btrfs_cow_block+0x7a6/0xb70
 [<ffffffff804034e2>] btrfs_cow_block+0x112/0x2d0
 [<ffffffff804072f3>] btrfs_search_slot+0x223/0xb00
 [<ffffffff80235a99>] ? sub_preempt_count+0xa9/0xf0
 [<ffffffff804178d1>] btrfs_lookup_csum+0x61/0x150
 [<ffffffff8026c2ed>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff80418356>] btrfs_csum_file_blocks+0xc6/0x7d0
 [<ffffffff802c2315>] ? kmem_cache_free+0xb5/0x110
 [<ffffffff802c2315>] ? kmem_cache_free+0xb5/0x110
 [<ffffffff8026c2ed>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff80437c76>] ? free_extent_state+0x46/0x70
 [<ffffffff80439462>] ? clear_extent_bit+0xe2/0x2e0
 [<ffffffff8042166a>] add_pending_csums+0x4a/0x70
 [<ffffffff80422ac5>] btrfs_finish_ordered_io+0x115/0x1e0
 [<ffffffff80422ba0>] btrfs_writepage_end_io_hook+0x10/0x20
 [<ffffffff8043abf4>] end_bio_extent_writepage+0x104/0x1e0
 [<ffffffff8026c282>] ? trace_hardirqs_on_caller+0x182/0x1e0
 [<ffffffff802ef0cc>] bio_endio+0x1c/0x40
 [<ffffffff8041b02b>] end_workqueue_fn+0xeb/0x120
 [<ffffffff804446ea>] worker_loop+0x7a/0x1b0
 [<ffffffff80444670>] ? worker_loop+0x0/0x1b0
 [<ffffffff80259126>] kthread+0x56/0x90
 [<ffffffff8020cc5a>] child_rip+0xa/0x20
 [<ffffffff80235969>] ? finish_task_switch+0x89/0x110
 [<ffffffff8062f546>] ? _spin_unlock_irq+0x36/0x60
 [<ffffffff8020c640>] ? restore_args+0x0/0x30
 [<ffffffff802590d0>] ? kthread+0x0/0x90
 [<ffffffff8020cc50>] ? child_rip+0x0/0x20
