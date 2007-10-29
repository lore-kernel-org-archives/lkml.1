Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbXJ2Noe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbXJ2Noe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXJ2No1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:44:27 -0400
Received: from pat.uio.no ([129.240.10.15]:45464 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbXJ2No0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:44:26 -0400
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Florin Iucha <florin@iucha.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20071028152428.GJ7918@iucha.net>
References: <20071028152428.GJ7918@iucha.net>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 09:46:59 -0400
Message-Id: <1193665619.7396.8.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.149)
X-UiO-Scanned: 10DC7031CB4E34584355D3D72F84F139B572EF81
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1625 total 4783492 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-10-28 at 10:24 -0500, Florin Iucha wrote:
> Hello,
> 
> For a week or two I started noticing that some time after I'm logged
> in, my keyboard input becomes a bit staggering, there is a small delay
> between the keypress and the actual character appearing in the
> terminal.  This is on a AMD Athlon x2 4200+ with 2 GB RAM and just a
> gnome-terminal open.  The machine is as idle as possible - monitored
> via the system monitor applet.  I could not get any hard data on it,
> until now.
> 
> After I logged off from GNOME, I switched to the text console and ran
> top, with the option of showing one CPU stats line for each CPU.  Lo
> and behold, one core is 100% idle, and the other one is 25% idle and
> 75% waiting.  Periodically, a pdflush process in 'D' state raises to
> the top.  I did a 'echo t > /proc/sysrequest-trigger' and this is what
> is says for the two pdflush processes:
> 
>    [ 3687.824424] pdflush       S ffff8100057ffef8     0   247      2
>    [ 3687.824427]  ffff8100057ffed0 0000000000000046 ffff8100057ffe70 ffffffff8022a96c
>    [ 3687.824431]  ffff8100057fc000 ffff810003040770 ffff8100057fc208 0000000000000297
>    [ 3687.824434]  ffff8100057ffe90 ffff810002c1ba10 ffff8100057ffed0 ffffffff8022b9d2
>    [ 3687.824438] Call Trace:
>    [ 3687.824440]  [<ffffffff8022a96c>] enqueue_task_fair+0x21/0x34
>    [ 3687.824444]  [<ffffffff8022b9d2>] set_user_nice+0x110/0x12c
>    [ 3687.824448]  [<ffffffff80267165>] pdflush+0x0/0x1c3
>    [ 3687.824451]  [<ffffffff80267234>] pdflush+0xcf/0x1c3
>    [ 3687.824455]  [<ffffffff80245876>] kthread+0x49/0x77
>    [ 3687.824458]  [<ffffffff8020c598>] child_rip+0xa/0x12
>    [ 3687.824463]  [<ffffffff8024582d>] kthread+0x0/0x77
>    [ 3687.824466]  [<ffffffff8020c58e>] child_rip+0x0/0x12
>    [ 3687.824468] 
>    [ 3687.824470] pdflush       D ffffffff805787c0     0   248      2
>    [ 3687.824473]  ffff810006001d90 0000000000000046 0000000000000000 0000000000000286
>    [ 3687.824476]  ffff8100057fc770 ffff810003062000 ffff8100057fc978 0000000106001da0
>    [ 3687.824480]  0000000000000003 ffffffff8023b1b2 0000000000000000 0000000000000000
>    [ 3687.824483] Call Trace:
>    [ 3687.824488]  [<ffffffff8023b1b2>] __mod_timer+0xb8/0xca
>    [ 3687.824492]  [<ffffffff8055c87a>] schedule_timeout+0x8d/0xb4
>    [ 3687.824496]  [<ffffffff8023ad6c>] process_timeout+0x0/0xb
>    [ 3687.824499]  [<ffffffff8055c79a>] io_schedule_timeout+0x28/0x33
>    [ 3687.824503]  [<ffffffff8026bb24>] congestion_wait+0x6b/0x87
>    [ 3687.824506]  [<ffffffff80245983>] autoremove_wake_function+0x0/0x38
>    [ 3687.824510]  [<ffffffff8029e684>] writeback_inodes+0xcd/0xd5
>    [ 3687.824514]  [<ffffffff80266dc4>] wb_kupdate+0xbb/0x10d
>    [ 3687.824518]  [<ffffffff80267165>] pdflush+0x0/0x1c3
>    [ 3687.824520]  [<ffffffff8026727d>] pdflush+0x118/0x1c3
>    [ 3687.824523]  [<ffffffff80266d09>] wb_kupdate+0x0/0x10d
>    [ 3687.824527]  [<ffffffff80245876>] kthread+0x49/0x77
>    [ 3687.824530]  [<ffffffff8020c598>] child_rip+0xa/0x12
>    [ 3687.824535]  [<ffffffff8024582d>] kthread+0x0/0x77
>    [ 3687.824538]  [<ffffffff8020c58e>] child_rip+0x0/0x12
>    [ 3687.824540] 
> 
> What could cause this?  I use NFS4 to automount the home directories
> from a Solaris10 server, and this box found a few bugs in the NFS4
> code (fixed in the 2.6.22 kernel).
> 
> I'll try running with 2.6.23 again for a few days, to see if I get the
> pdflush stuck.  Any other ideas?

One of them appears to be waiting for i/o congestion to clear up. If the
filesystem is NFS, then that means that some other thread is busy
writing data out to the server. You'll need to look at the rest of the
thread dump to figure out which thread is writing the data out, and
where it is getting stuck.

Trond

