Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbYKRFTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbYKRFTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 00:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbYKRFTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 00:19:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:36307 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbYKRFTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 00:19:23 -0500
Subject: Re: busted CFS group load balancer?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Ken Chen <kenchen@google.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4921DFD8.9060509@nortel.com>
References: <20081115011452.GA28135@google.com>
	 <49218FB4.6090805@nortel.com>
	 <b040c32a0811171204p4ce6d706j3ee2c018d0f33548@mail.gmail.com>
	 <4921DFD8.9060509@nortel.com>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 06:19:08 +0100
Message-Id: <1226985548.29743.6.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-17 at 15:19 -0600, Chris Friesen wrote:
> Ken Chen wrote:
> > On Mon, Nov 17, 2008 at 7:37 AM, Chris Friesen wrote:
> >>> It appears that the fair-group load balancer in 2.6.27 does not work
> >>> properly.
> >> There was an issue fixed post 2.6.27 where the load balancer didn't work
> >> properly if there was one task per group per cpu.  You might try
> >> backporting commit 38736f4 and see if that helps.
> > 
> > Tested git commit 38736f4, it doesn't fix the problem I'm seeing.
> > 
> 
> I plugged in the same weights into my test app (groups 1 and 2 instead 
> of ant/bee) and got the results below for a 10-sec run.  The "actual" 
> numbers give the overall average and then the values for each hog 
> separately.  In this case we see that both tasks in group 2 ended up 
> sharing a cpu with one of the tasks from group 1.
> 
>    group      actual(%)      expected(%)  ctx switches   max_latency(ms)
>        1  99.69(99.38/99.99)   99.81       160/262          4/0
>        2   0.31( 0.31/0.31)     0.19       32/33         391/375
> 
> I've only got a 2-way system.  If the results really are that much worse 
> on larger systems, then that's going to cause problems for us as well. 
> I'll see if I can get some time on a bigger machine.

Note that with larger cpu count and/or lower group weight we'll quickly
run into numerical trouble...

I would recommend trying this with the minimum weight in the order of
8-16 times number of cpus on your system.

There is only so much one can do with 10 bit fixed precision math :/


