Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYJCEpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYJCEpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 00:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbYJCEpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 00:45:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:38261 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYJCEpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 00:45:23 -0400
Date: Thu, 2 Oct 2008 21:45:11 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002214511.3a567c2d@infradead.org>
In-Reply-To: <20081002214000.89420bb3.akpm@linux-foundation.org>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<20081002062736.GR19428@kernel.dk>
	<20081001235501.2b7f50fe.akpm@linux-foundation.org>
	<20081002061236.3c71c877@infradead.org>
	<20081002132457.46ad8d05.akpm@linux-foundation.org>
	<20081002210117.0f5062f7@infradead.org>
	<20081002212355.621a4fb6@infradead.org>
	<20081002214000.89420bb3.akpm@linux-foundation.org>
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

On Thu, 2 Oct 2008 21:40:00 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 2 Oct 2008 21:23:55 -0700 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> > On Thu, 2 Oct 2008 21:01:17 -0700
> > Arjan van de Ven <arjan@infradead.org> wrote:
> > 
> > > > _
> > > > 
> > > > perhaps for varying values of "1".
> > > 
> > 
> > caught a few, a few were over 3 1/2 seconds in stall time 
> > (specifically I know this for the last one)
> > 
> > (I've stripped out the ? entries to keep them reasonable)
> > 
> > [  410.168277] WARNING: at kernel/sched.c:5652
> > io_schedule+0x77/0xb0() [  410.168347] Pid: 699, comm: kjournald
> > Not tainted 2.6.27-rc8-tip #50 [  410.168366]  [<c042ee64>]
> > warn_on_slowpath+0x41/0x65 [  410.168414]  [<c070ec83>]
> > io_schedule+0x77/0xb0 [  410.168421]  [<c04abc72>]
> > sync_buffer+0x33/0x37 [  410.168429]  [<c070f123>]
> > __wait_on_bit+0x36/0x5d [  410.168445]  [<c070f1f5>]
> > out_of_line_wait_on_bit+0xab/0xb3 [  410.168471]  [<c04abbd1>]
> > __wait_on_buffer+0x19/0x1c [  410.168478]  [<c04de796>]
> > journal_commit_transaction+0x484/0xcb2 [  410.168519]  [<c04e14ae>]
> > kjournald+0xc7/0x1ea [  410.168544]  [<c043fb87>] kthread+0x3b/0x61
> > [  410.168559]  [<c040499f>] kernel_thread_helper+0x7/0x10
> > [  410.168567]  =======================
> > [  410.168572] ---[ end trace de523043f88bd9a7 ]---
> > [  451.605034] ------------[ cut here ]------------
> > [  451.605041] WARNING: at kernel/sched.c:5652
> > io_schedule+0x77/0xb0() [  451.605114] Pid: 699, comm: kjournald
> > Tainted: G        W 2.6.27-rc8-tip #50
> >
> > ...
> >
> 
> hm, they're all kjournald getting stuck on lock_buffer().  That _may_
> be related to the one we care about, but it doesn't seem likely.

one of them is (based on timestamps of the printk) is less than 3
seconds before the "real" one, while the real one's delay was 4 seconds.
To me that implies they're at least somewhat correlated...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
