Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbZG0UGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbZG0UGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbZG0UGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:06:44 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:5793 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbZG0UGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:06:42 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2009 16:06:42 EDT
X-SpamScore: -1
X-BigFish: VPS-1(z16d9m6f5iz62a3L4015Lzz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNGHTS-02-9JA-02
X-M-MSG: 
Date: Mon, 27 Jul 2009 21:51:11 +0200
From: Robert Richter <robert.richter@amd.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: WARNING: at kernel/trace/ring_buffer.c:2289
	rb_advance_reader+0x2e/0xc5()
Message-ID: <20090727195058.GA25478@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 27 Jul 2009 19:51:12.0613 (UTC) FILETIME=[9828C150:01CA0EF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

I have workloads for oprofile that trigger warnings like this:

------------[ cut here ]------------
WARNING: at /dev/shm/.source/linux/kernel/trace/ring_buffer.c:2289 rb_advance_reader+0x2e/0xc5()
Hardware name: Anaheim
Modules linked in:
Pid: 29, comm: events/2 Tainted: G        W  2.6.31-rc3-oprofile-x86_64-standard-00059-g5050dc2 #1
Call Trace:
[<ffffffff8106776f>] ? rb_advance_reader+0x2e/0xc5
[<ffffffff81039ffe>] warn_slowpath_common+0x77/0x8f
[<ffffffff8103a025>] warn_slowpath_null+0xf/0x11
[<ffffffff8106776f>] rb_advance_reader+0x2e/0xc5
[<ffffffff81068bda>] ring_buffer_consume+0xa0/0xd2
[<ffffffff81326933>] op_cpu_buffer_read_entry+0x21/0x9e
[<ffffffff810be3af>] ? __find_get_block+0x4b/0x165
[<ffffffff8132749b>] sync_buffer+0xa5/0x401
[<ffffffff810be3af>] ? __find_get_block+0x4b/0x165
[<ffffffff81326c1b>] ? wq_sync_buffer+0x0/0x78
[<ffffffff81326c76>] wq_sync_buffer+0x5b/0x78
[<ffffffff8104aa30>] worker_thread+0x113/0x1ac
[<ffffffff8104dd95>] ? autoremove_wake_function+0x0/0x38
[<ffffffff8104a91d>] ? worker_thread+0x0/0x1ac
[<ffffffff8104dc9a>] kthread+0x88/0x92
[<ffffffff8100bdba>] child_rip+0xa/0x20
[<ffffffff8104dc12>] ? kthread+0x0/0x92
[<ffffffff8100bdb0>] ? child_rip+0x0/0x20
---[ end trace f561c0a58fcc89bd ]---

I am wondering when this may happen. It seems the following code in
rb_get_reader_page() triggers this:

        /* check if we caught up to the tail */
        reader = NULL;
        if (cpu_buffer->commit_page == cpu_buffer->reader_page)
                goto out;

It is very hard to find out the conditions for equal commit and reader
pages.

Maybe you have any idea or could shortly explain the use of head,
tail, commit and reader page pointers? When an overrun happens?
(... or point me to some documentation.)

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

