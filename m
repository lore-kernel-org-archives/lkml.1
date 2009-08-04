Return-Path: <linux-kernel-owner+w=401wt.eu-S933029AbZHDQur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029AbZHDQur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932889AbZHDQuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:50:46 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:52601 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbZHDQup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:50:45 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz62a3L1432R98dN936eMzz1202hzzz32i6bh203h43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KNV2S5-01-93I-02
X-M-MSG: 
Date: Tue, 4 Aug 2009 18:49:28 +0200
From: Robert Richter <robert.richter@amd.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring-buffer: Fix advance of reader in rb_buffer_peek()
Message-ID: <20090804164927.GZ14610@erda.amd.com>
References: <alpine.DEB.2.00.0907271601210.30108@gandalf.stny.rr.com> <1249044963-26878-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1249044963-26878-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 Aug 2009 16:49:29.0358 (UTC) FILETIME=[889E12E0:01CA1523]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.07.09 14:56:03, Robert Richter wrote:
> When calling rb_buffer_peek() from ring_buffer_consume() and a padding
> event is returned, the function rb_advance_reader() is called
> twice. This may lead to missing samples or under high workloads to the
> warning below. This patch fixes this. If a padding event is returned
> by rb_buffer_peek() it will be consumed by the calling function now.
> 
> Also, I simplified some code in ring_buffer_consume().
> 
> ------------[ cut here ]------------
> WARNING: at /dev/shm/.source/linux/kernel/trace/ring_buffer.c:2289 rb_advance_reader+0x2e/0xc5()
> Hardware name: Anaheim
> Modules linked in:
> Pid: 29, comm: events/2 Tainted: G        W  2.6.31-rc3-oprofile-x86_64-standard-00059-g5050dc2 #1
> Call Trace:
> [<ffffffff8106776f>] ? rb_advance_reader+0x2e/0xc5
> [<ffffffff81039ffe>] warn_slowpath_common+0x77/0x8f
> [<ffffffff8103a025>] warn_slowpath_null+0xf/0x11
> [<ffffffff8106776f>] rb_advance_reader+0x2e/0xc5
> [<ffffffff81068bda>] ring_buffer_consume+0xa0/0xd2
> [<ffffffff81326933>] op_cpu_buffer_read_entry+0x21/0x9e
> [<ffffffff810be3af>] ? __find_get_block+0x4b/0x165
> [<ffffffff8132749b>] sync_buffer+0xa5/0x401
> [<ffffffff810be3af>] ? __find_get_block+0x4b/0x165
> [<ffffffff81326c1b>] ? wq_sync_buffer+0x0/0x78
> [<ffffffff81326c76>] wq_sync_buffer+0x5b/0x78
> [<ffffffff8104aa30>] worker_thread+0x113/0x1ac
> [<ffffffff8104dd95>] ? autoremove_wake_function+0x0/0x38
> [<ffffffff8104a91d>] ? worker_thread+0x0/0x1ac
> [<ffffffff8104dc9a>] kthread+0x88/0x92
> [<ffffffff8100bdba>] child_rip+0xa/0x20
> [<ffffffff8104dc12>] ? kthread+0x0/0x92
> [<ffffffff8100bdb0>] ? child_rip+0x0/0x20
> ---[ end trace f561c0a58fcc89bd ]---
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: <stable@kernel.org>
> Signed-off-by: Robert Richter <robert.richter@amd.com>

Steven, Ingo,

should I apply the patch to my tree? Or does somebody of you wants to
apply it? I got a bug report and want to have it in a tree.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

