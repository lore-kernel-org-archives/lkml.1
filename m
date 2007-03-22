Return-Path: <linux-kernel-owner+w=401wt.eu-S934177AbXCVSVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177AbXCVSVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 14:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964844AbXCVSVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 14:21:11 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1342 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934179AbXCVSVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 14:21:10 -0400
From: Mariusz =?iso-8859-2?q?Koz=B3owski?= <m.kozlowski@tuxland.pl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [1/6] 2.6.21-rc4: known regressions
Date: Thu, 22 Mar 2007 19:24:08 +0100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org> <46020385.50301@yahoo.com.au>
In-Reply-To: <46020385.50301@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703221924.09331.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > In contrast, the hang reported by Mariusz Kozlowski has a slightly 
> > different feel to it, but there's a tantalizing pattern in there too:

Just to make things clear. I didn't say I could reproduce it on 2.6.21-rc4.
In fact I'm running 2.6.21-rc4-mm1 with no problems so far. I just replied
to show my sysrq dumps of processes states with 2.6.21-rc2-mm1.

I could reproduce similar (but still each time slightly different) hangs 
on -mm series from 2.6.20-mm1 to 2.6.21-rc2-mm1. 2.6.21-rc3-mm1 worked well
for me so not sure If my report is still valid here.

Sorry if I didn't make it clear enough.

> >   http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/1243.html
> > 
> > 	Call Trace:
> > 	[<c03ec87e>] io_schedule+0x42/0x59
> > 	[<c0184915>] sleep_on_buffer+0x8/0xc
> > 	[<c03ed217>] __wait_on_bit+0x47/0x6c
> > 	[<c03ed297>] out_of_line_wait_on_bit+0x5b/0x64
> > 	[<c01848a8>] __wait_on_buffer+0x27/0x2d
> > 	[<c01b4228>] journal_commit_transaction+0x707/0x127f
> > 	[<c01b868b>] kjournald+0xac/0x1ed
> > 	[<c0126af5>] kthread+0xa2/0xc9
> > 	[<c010422b>] kernel_thread_helper+0x7/0x1c
> > 
> > which certainly also looks like an IO never completed (or completed but 
> > never woke anything up).

As I previously noticed each time the system hang I/O activity to disk looked
dead (couldn't even sysrq-s).

> It could be possible that ext3 is doing something weird and expecting

True. I'm using ext3.

> fs: nobh data leak... again hard to see how it could cause an unlock/wakeup
> to get lost. Is Mariusz using the nobh mount option?

No. He is not.

Regards,

	Mariusz Kozlowski
