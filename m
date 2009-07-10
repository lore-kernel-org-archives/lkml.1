Return-Path: <linux-kernel-owner+w=401wt.eu-S1751313AbZGJHEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbZGJHEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbZGJHEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:04:32 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:34429 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZGJHEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:04:31 -0400
Message-ID: <4A56E7F9.9030405@in.ibm.com>
Date: Fri, 10 Jul 2009 12:34:25 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: OOM with hackbench against next 0708
References: <20090708173104.d39108bb.sfr@canb.auug.org.au> <4A5499B4.5050007@in.ibm.com> <1247066549.14309.1029.camel@nimitz>
In-Reply-To: <1247066549.14309.1029.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> This doesn't look like a kernel bug at all to me.  You're out of memory,
> out of swap, and the thing that got killed was the thing allocating
> memory.  You're also down to 65MB of pagecache, which is awfully low for
> a 6GB machine.  That tells me it's also been effective in reclaiming
> disk cache.
>
> There are a couple of possibilities:
> 1. hackbench is broken, allocating too much memory and ooming, or it
>    has been misconfigured by a user
> 2. hackbench broke because something the kernel is telling it is wrong
> 3. The kernel is leaking (or just plain using) some memory more than a
>    few releases ago, and that caused the oom.
>
> I'd go back and carefully examine how hackbench is being run and that it
> is consistent.  You should also double-check your finding that the
> several-day-old -next isn't seeing this issue.
>   
Thanks Dave for the pointers.

I am able to consistently recreate this issue with next 0708. hackbench
creates 3600 tasks in my case. After starting the tests machine becomes
unresponsive and i finally have to reboot it.

The test ran successfully on next03, but unfortunately i did
not save the config file for that run. If i use the config file from
0708 and compile a 0703, the machine becomes unresponsive because
of OOM's. I can't explain why the test ran successfully against
0703 :-( in previous attempt.

Only data point i have at this time is the same tests runs successfully
against 2.6.31-rc2. But may be that's not even an argument :-)

Thanks
-Sachin



-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

