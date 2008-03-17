Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYCQHT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYCQHT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 03:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbYCQHTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 03:19:51 -0400
Received: from n10.bullet.mail.mud.yahoo.com ([209.191.125.208]:32679 "HELO
	n10.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752626AbYCQHTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 03:19:50 -0400
X-Yahoo-Newman-Id: 794807.92119.bm@omp416.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=ek1c8YRL8S6YGUKLJ8O/REItZmgl7zTjrLQz4nKlaX/wznUe+TwVMGbAXNGh5GXolyXJ2W3wb/PlQUJjcpAZI2Cfwq3OZn7aB56mQPX3dMsxTJ3sLRSMja+j9TaDR+TTec5q5PFW154MpWSZoytavNENKHVl85FwNC07gb2D61s=  ;
X-YMail-OSG: L8q9bhEVM1k4YPzZLlvYlX4YjzxXGyWiPj.cAubnW7wzXl7OwQSynilp0A2yzSYLby5zKQjz1Q--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Date: Mon, 17 Mar 2008 18:19:38 +1100
User-Agent: KMail/1.9.5
Cc: Ray Lee <ray-lk@madrabbit.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, "LKML," <linux-kernel@vger.kernel.org>
References: <200803111749.29143.nickpiggin@yahoo.com.au> <2c0942db0803162216r1892782bsc894d4188b51481b@mail.gmail.com> <20080317052134.GD13012@1wt.eu>
In-Reply-To: <20080317052134.GD13012@1wt.eu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803171819.38892.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008 16:21, Willy Tarreau wrote:
> On Sun, Mar 16, 2008 at 10:16:36PM -0700, Ray Lee wrote:
> > On Sun, Mar 16, 2008 at 5:44 PM, Nick Piggin <nickpiggin@yahoo.com.au> 
> > > Can this be changed by default, please?
> >
> > Not without benchmarks of interactivity, please. There are far, far
> > more linux desktops than there are servers. People expect to have to
> > tune servers (I do, for the servers I maintain). People don't expect
> > to have to tune a desktop to make it run well.
>
> Oh and even on servers, when your anti-virus proxy reaches a load of 800,
> you're happy no to have too large a time-slice so that you regularly get
> a chance of being allowed to type in commands over SSH.

Your ssh session should be allowed to run anyway. I don't see the difference.
If the runqueue length is 100 and the time-slice is (say) 10ms, then if your
ssh only needs average of 5ms of CPU time per second, then it should be run
next when it becomes runnable. If it wants 20ms of CPU time per second, then
it has to wait for 2 seconds anyway to be run next, regardless of whether
the timeslice was 10ms or 20ms.


> Large time-slices are needed only in HPC environments IMHO, where only
> one task runs.

That's silly. By definition if there is only one task running, you don't
care what the timeslice is.

We actually did conduct some benchmarks, and a 10ms timeslice can start
hurting even things like kbuild quite a bit.

But anyway, I don't care what the time slice is so much (although it should
be higher -- if the scheduler can't get good interactive behaviour with a
20-30ms timeslice in most cases then it's no good IMO). I care mostly that
the timeslice does not decrease when load increases.

