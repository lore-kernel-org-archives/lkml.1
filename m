Return-Path: <linux-kernel-owner+w=401wt.eu-S966117AbXDJItO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966117AbXDJItO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966120AbXDJItO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:49:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33826 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966117AbXDJItN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:49:13 -0400
Message-ID: <461B4F76.1010807@garzik.org>
Date: Tue, 10 Apr 2007 04:48:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Robin Holt <holt@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>	<4616CBF0.7090606@garzik.org>	<20070409172339.48d661d6.akpm@linux-foundation.org>	<20070410015912.GE1994@redhat.com>	<20070409193056.6b52c354.akpm@linux-foundation.org>	<461B3754.9040107@garzik.org>	<20070410003702.f8a49b75.akpm@linux-foundation.org>	<461B4BF5.6070909@garzik.org> <20070410014102.fd730911.akpm@linux-foundation.org>
In-Reply-To: <20070410014102.fd730911.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Well that obviously would be a dumb way to use keventd.  One would need
> to do schedule_work(), kick off the reset then do schedule_delayed_work()
> to wait (or poll) for its termination.

Far too complex.  See what Russell wrote, for instance.

When you are in a kernel thread, you can write more simple, 
straightforward, easy-to-debug code that does

	blah
	msleep()
	blah

rather than creating an insanely complicated state machine for the same 
thing.

ESPECIALLY if you are already inside a state machine (the case with 
libata PIO data xfer), you do not want to add another state machine 
inside of that.

A great many uses of kernel threads are to simplify device reset and 
polling in this way.  I know; a year ago I audited every kernel thread, 
because I was so frustrated with the per-CPU thread explosion.

Thus, rather than forcing authors to make their code more complex, we 
should find another solution.

	Jeff


