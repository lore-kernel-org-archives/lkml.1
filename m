Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbYKQVTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbYKQVTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYKQVT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:19:27 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:42601 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbYKQVT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:19:26 -0500
Message-ID: <4921DFD8.9060509@nortel.com>
Date: Mon, 17 Nov 2008 15:19:20 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Ken Chen <kenchen@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: busted CFS group load balancer?
References: <20081115011452.GA28135@google.com> <49218FB4.6090805@nortel.com> <b040c32a0811171204p4ce6d706j3ee2c018d0f33548@mail.gmail.com>
In-Reply-To: <b040c32a0811171204p4ce6d706j3ee2c018d0f33548@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2008 21:19:22.0480 (UTC) FILETIME=[29116700:01C948FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Chen wrote:
> On Mon, Nov 17, 2008 at 7:37 AM, Chris Friesen wrote:
>>> It appears that the fair-group load balancer in 2.6.27 does not work
>>> properly.
>> There was an issue fixed post 2.6.27 where the load balancer didn't work
>> properly if there was one task per group per cpu.  You might try
>> backporting commit 38736f4 and see if that helps.
> 
> Tested git commit 38736f4, it doesn't fix the problem I'm seeing.
> 

I plugged in the same weights into my test app (groups 1 and 2 instead 
of ant/bee) and got the results below for a 10-sec run.  The "actual" 
numbers give the overall average and then the values for each hog 
separately.  In this case we see that both tasks in group 2 ended up 
sharing a cpu with one of the tasks from group 1.

   group      actual(%)      expected(%)  ctx switches   max_latency(ms)
       1  99.69(99.38/99.99)   99.81       160/262          4/0
       2   0.31( 0.31/0.31)     0.19       32/33         391/375

I've only got a 2-way system.  If the results really are that much worse 
on larger systems, then that's going to cause problems for us as well. 
I'll see if I can get some time on a bigger machine.

Chris
