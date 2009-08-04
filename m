Return-Path: <linux-kernel-owner+w=401wt.eu-S933101AbZHDSHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101AbZHDSHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932989AbZHDSHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:07:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57699 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978AbZHDSHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:07:23 -0400
Date: Tue, 4 Aug 2009 14:07:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Robert Richter <robert.richter@amd.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring-buffer: Fix advance of reader in rb_buffer_peek()
In-Reply-To: <20090804164927.GZ14610@erda.amd.com>
Message-ID: <alpine.DEB.2.00.0908041407020.21700@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0907271601210.30108@gandalf.stny.rr.com> <1249044963-26878-1-git-send-email-robert.richter@amd.com> <20090804164927.GZ14610@erda.amd.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 4 Aug 2009, Robert Richter wrote:

> On 31.07.09 14:56:03, Robert Richter wrote:
> > When calling rb_buffer_peek() from ring_buffer_consume() and a padding
> > event is returned, the function rb_advance_reader() is called
> > twice. This may lead to missing samples or under high workloads to the
> > warning below. This patch fixes this. If a padding event is returned
> > by rb_buffer_peek() it will be consumed by the calling function now.
> > 
> > Also, I simplified some code in ring_buffer_consume().
> > 
> > ------------[ cut here ]------------
> > WARNING: at /dev/shm/.source/linux/kernel/trace/ring_buffer.c:2289 rb_advance_reader+0x2e/0xc5()
> > Hardware name: Anaheim
> > Modules linked in:
> > Pid: 29, comm: events/2 Tainted: G        W  2.6.31-rc3-oprofile-x86_64-standard-00059-g5050dc2 #1
> > Call Trace:
> > [<ffffffff8106776f>] ? rb_advance_reader+0x2e/0xc5
> > [<ffffffff81039ffe>] warn_slowpath_common+0x77/0x8f
> > [<ffffffff8103a025>] warn_slowpath_null+0xf/0x11
> > [<ffffffff8106776f>] rb_advance_reader+0x2e/0xc5
> > [<ffffffff81068bda>] ring_buffer_consume+0xa0/0xd2
> > [<ffffffff81326933>] op_cpu_buffer_read_entry+0x21/0x9e
> > [<ffffffff810be3af>] ? __find_get_block+0x4b/0x165
> > [<ffffffff8132749b>] sync_buffer+0xa5/0x401
> > [<ffffffff810be3af>] ? __find_get_block+0x4b/0x165
> > [<ffffffff81326c1b>] ? wq_sync_buffer+0x0/0x78
> > [<ffffffff81326c76>] wq_sync_buffer+0x5b/0x78
> > [<ffffffff8104aa30>] worker_thread+0x113/0x1ac
> > [<ffffffff8104dd95>] ? autoremove_wake_function+0x0/0x38
> > [<ffffffff8104a91d>] ? worker_thread+0x0/0x1ac
> > [<ffffffff8104dc9a>] kthread+0x88/0x92
> > [<ffffffff8100bdba>] child_rip+0xa/0x20
> > [<ffffffff8104dc12>] ? kthread+0x0/0x92
> > [<ffffffff8100bdb0>] ? child_rip+0x0/0x20
> > ---[ end trace f561c0a58fcc89bd ]---
> > 
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: <stable@kernel.org>
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> 
> Steven, Ingo,
> 
> should I apply the patch to my tree? Or does somebody of you wants to
> apply it? I got a bug report and want to have it in a tree.

I'll pull it in and start doing some of my own tests on it. Thanks!

-- Steve

