Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbZCXGU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbZCXGU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 02:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZCXGUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 02:20:14 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:52858 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbZCXGUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 02:20:12 -0400
Message-ID: <49C87B87.4020108@krogh.cc>
Date: Tue, 24 Mar 2009 07:19:51 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> This obviously starts the merge window for 2.6.30, although as usual, I'll 
> probably wait a day or two before I start actively merging. I do that in 
> order to hopefully result in people testing the final plain 2.6.29 a bit 
> more before all the crazy changes start up again.

I know this has been discussed before:

[129401.996244] INFO: task updatedb.mlocat:31092 blocked for more than 
480 seconds.
[129402.084667] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[129402.179331] updatedb.mloc D 0000000000000000     0 31092  31091
[129402.179335]  ffff8805ffa1d900 0000000000000082 ffff8803ff5688a8 
0000000000001000
[129402.179338]  ffffffff806cc000 ffffffff806cc000 ffffffff806d3e80 
ffffffff806d3e80
[129402.179341]  ffffffff806cfe40 ffffffff806d3e80 ffff8801fb9f87e0 
000000000000ffff
[129402.179343] Call Trace:
[129402.179353]  [<ffffffff802d3ff0>] sync_buffer+0x0/0x50
[129402.179358]  [<ffffffff80493a50>] io_schedule+0x20/0x30
[129402.179360]  [<ffffffff802d402b>] sync_buffer+0x3b/0x50
[129402.179362]  [<ffffffff80493d2f>] __wait_on_bit+0x4f/0x80
[129402.179364]  [<ffffffff802d3ff0>] sync_buffer+0x0/0x50
[129402.179366]  [<ffffffff80493dda>] out_of_line_wait_on_bit+0x7a/0xa0
[129402.179369]  [<ffffffff80252730>] wake_bit_function+0x0/0x30
[129402.179396]  [<ffffffffa0264346>] ext3_find_entry+0xf6/0x610 [ext3]
[129402.179399]  [<ffffffff802d3453>] __find_get_block+0x83/0x170
[129402.179403]  [<ffffffff802c4a90>] ifind_fast+0x50/0xa0
[129402.179405]  [<ffffffff802c5874>] iget_locked+0x44/0x180
[129402.179412]  [<ffffffffa0266435>] ext3_lookup+0x55/0x100 [ext3]
[129402.179415]  [<ffffffff802c32a7>] d_alloc+0x127/0x1c0
[129402.179417]  [<ffffffff802ba2a7>] do_lookup+0x1b7/0x250
[129402.179419]  [<ffffffff802bc51d>] __link_path_walk+0x76d/0xd60
[129402.179421]  [<ffffffff802ba17f>] do_lookup+0x8f/0x250
[129402.179424]  [<ffffffff802c8b37>] mntput_no_expire+0x27/0x150
[129402.179426]  [<ffffffff802bcb64>] path_walk+0x54/0xb0
[129402.179428]  [<ffffffff802bfd10>] filldir+0x0/0xf0
[129402.179430]  [<ffffffff802bcc8a>] do_path_lookup+0x7a/0x150
[129402.179432]  [<ffffffff802bbb55>] getname+0xe5/0x1f0
[129402.179434]  [<ffffffff802bd8d4>] user_path_at+0x44/0x80
[129402.179437]  [<ffffffff802b53b5>] cp_new_stat+0xe5/0x100
[129402.179440]  [<ffffffff802b56d0>] vfs_lstat_fd+0x20/0x60
[129402.179442]  [<ffffffff802b5737>] sys_newlstat+0x27/0x50
[129402.179445]  [<ffffffff8020c35b>] system_call_fastpath+0x16/0x1b

Consensus seems to be something with large memory machines, lots of 
dirty pages and a long writeout time due to ext3.

At the moment this the largest "usabillity" issue in the serversetup I'm 
working with. Can there be done something to "autotune" it .. or perhaps 
even fix it? .. or is it just to shift to xfs or wait for ext4?

Jesper
-- 
Jesper
