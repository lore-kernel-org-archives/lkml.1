Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbZDBOBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbZDBOBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756357AbZDBOBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:01:06 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:43541 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573AbZDBOBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:01:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoFAChc1ElMQW1W/2dsb2JhbACBUr4+CI91gkMIgTEG
Date: Thu, 2 Apr 2009 10:00:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       David Rees <drees76@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux 2.6.29
Message-ID: <20090402140051.GA3030@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49C87B87.4020108@krogh.cc>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:36:20 up 33 days, 10:02,  1 user,  load average: 0.69, 0.32,
	0.25
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Linus Torvalds wrote:
> > This obviously starts the merge window for 2.6.30, although as usual, I'll 
> > probably wait a day or two before I start actively merging. I do that in 
> > order to hopefully result in people testing the final plain 2.6.29 a bit 
> > more before all the crazy changes start up again.
> 
> I know this has been discussed before:
> 
> [129401.996244] INFO: task updatedb.mlocat:31092 blocked for more than 
> 480 seconds.
> [129402.084667] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [129402.179331] updatedb.mloc D 0000000000000000     0 31092  31091
> [129402.179335]  ffff8805ffa1d900 0000000000000082 ffff8803ff5688a8 
> 0000000000001000
> [129402.179338]  ffffffff806cc000 ffffffff806cc000 ffffffff806d3e80 
> ffffffff806d3e80
> [129402.179341]  ffffffff806cfe40 ffffffff806d3e80 ffff8801fb9f87e0 
> 000000000000ffff
> [129402.179343] Call Trace:
> [129402.179353]  [<ffffffff802d3ff0>] sync_buffer+0x0/0x50
> [129402.179358]  [<ffffffff80493a50>] io_schedule+0x20/0x30
> [129402.179360]  [<ffffffff802d402b>] sync_buffer+0x3b/0x50
> [129402.179362]  [<ffffffff80493d2f>] __wait_on_bit+0x4f/0x80
> [129402.179364]  [<ffffffff802d3ff0>] sync_buffer+0x0/0x50
> [129402.179366]  [<ffffffff80493dda>] out_of_line_wait_on_bit+0x7a/0xa0
> [129402.179369]  [<ffffffff80252730>] wake_bit_function+0x0/0x30
> [129402.179396]  [<ffffffffa0264346>] ext3_find_entry+0xf6/0x610 [ext3]
> [129402.179399]  [<ffffffff802d3453>] __find_get_block+0x83/0x170
> [129402.179403]  [<ffffffff802c4a90>] ifind_fast+0x50/0xa0
> [129402.179405]  [<ffffffff802c5874>] iget_locked+0x44/0x180
> [129402.179412]  [<ffffffffa0266435>] ext3_lookup+0x55/0x100 [ext3]
> [129402.179415]  [<ffffffff802c32a7>] d_alloc+0x127/0x1c0
> [129402.179417]  [<ffffffff802ba2a7>] do_lookup+0x1b7/0x250
> [129402.179419]  [<ffffffff802bc51d>] __link_path_walk+0x76d/0xd60
> [129402.179421]  [<ffffffff802ba17f>] do_lookup+0x8f/0x250
> [129402.179424]  [<ffffffff802c8b37>] mntput_no_expire+0x27/0x150
> [129402.179426]  [<ffffffff802bcb64>] path_walk+0x54/0xb0
> [129402.179428]  [<ffffffff802bfd10>] filldir+0x0/0xf0
> [129402.179430]  [<ffffffff802bcc8a>] do_path_lookup+0x7a/0x150
> [129402.179432]  [<ffffffff802bbb55>] getname+0xe5/0x1f0
> [129402.179434]  [<ffffffff802bd8d4>] user_path_at+0x44/0x80
> [129402.179437]  [<ffffffff802b53b5>] cp_new_stat+0xe5/0x100
> [129402.179440]  [<ffffffff802b56d0>] vfs_lstat_fd+0x20/0x60
> [129402.179442]  [<ffffffff802b5737>] sys_newlstat+0x27/0x50
> [129402.179445]  [<ffffffff8020c35b>] system_call_fastpath+0x16/0x1b
> Consensus seems to be something with large memory machines, lots of 
> dirty pages and a long writeout time due to ext3.
> 
> At the moment this the largest "usabillity" issue in the serversetup I'm 
> working with. Can there be done something to "autotune" it .. or perhaps 
> even fix it? .. or is it just to shift to xfs or wait for ext4?
> 

Hi Jesper,

What you are seeing looks awefully like the bug I have spent some time
to try to figure out in this bugzilla thread :

[Bug 12309] Large I/O operations result in slow performance and high
            iowait times
http://bugzilla.kernel.org/show_bug.cgi?id=12309

I created a fio test case out of a lttng trace to reproduce the problem
and created a patch to try to account the pages used by the i/o elevator
in the vm page count used to calculate memory pressure. Basically, the
behavior I was seeing is a constant increase of memory usage when doing
a dd-like write to disk until the memory fills up, which is indeed
wrong. The patch I posted in that thread seems to cause other problems
though, so probably we should teach kjournald to do better.

Here is the patch attempt :
http://bugzilla.kernel.org/attachment.cgi?id=20172

Here is the fio test case :
http://bugzilla.kernel.org/attachment.cgi?id=19894

My findings were this (I hope other people with deeper knowledge of
block layer/vm interaction can correct me) :

- Upon heavy and long disk writes, the pages used to back the buffers
  continuously increase as if there was no memory pressure at all.
  Therefore, I suspect they are held in a nowhere land that's unaccounted
  for at the vm layer (not part of memory pressure). That would seem to
  be the I/O elevator.

Can you give a try at the dd and fio test cases pointed out in the
bugzilla entry ? You may also want to see if my patch helps to partially
solve your problem. Another hint is to try to use the cgroups to
restrict you heavy I/O processes to a limited amount of memory;
although it does not solve the core of the problem, it made it disappear
for me. And of course trying to get a LTTng trace to get your head
around the problem can be very efficient. It's available as a git tree
over 2.6.29, and includes VFS, block I/O layer and vm instrumentation,
which helps looking at their interaction. All information is at
http://www.lttng.org.

Hoping this helps,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
