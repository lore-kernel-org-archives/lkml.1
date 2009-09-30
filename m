Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZI3O5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZI3O5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZI3O5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:57:09 -0400
Received: from kcmailp01.birch.net ([216.212.0.96]:61779 "EHLO mx01.birch.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751977AbZI3O5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:57:08 -0400
Message-ID: <4AC371C6.3050104@softplc.com>
Date: Wed, 30 Sep 2009 09:57:10 -0500
From: Dick Hollenbeck <dick@softplc.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.31.1 boot crash, compiled with ftrace
References: <4AC22613.4090803@softplc.com>  <1254297804.2963.14.camel@frodo> <1254301761.7286.4.camel@frodo>
In-Reply-To: <1254301761.7286.4.camel@frodo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2009-09-30 at 04:03 -0400, Steven Rostedt wrote:
>   
>> On Tue, 2009-09-29 at 10:21 -0500, Dick Hollenbeck wrote:
>>     
>>> Please help with a kernel boot crash.  This is happening with ftrace 
>>> enabled.   (I have yet to try without ftrace.)  This same box runs 
>>> kernel 2.6.26 fine.
>>>
>>> While running 'make oldconfig' coming up from 2.6.26, the three most 
>>> significant changes were:
>>>
>>> 1) changed CPU from 486 to Pentium-Classic
>>>
>>> 2) Added "High Memory Support" 4 GB
>>>
>>> 3) Enabled various ftrace options, because I am on the hunt for some 
>>> insane latency problems.
>>>
>>>       
>> Hi Dick,
>>
>> Thanks for reporting this. Peter and I have been taking some look at it.
>> We are not sure that it is ftrace related. have you tried booting the
>> kernel without adding ftrace?
>>     
>
> Hi,
>
> I just booted your config a couple of times without any issues. How
> reproducible is this?
>
> Thanks,
>
> -- Steve
>   

Steve,

Thank you *very* much for your help.  *This* is what makes linux great, 
not just the code, and you are part of it.

The target is an embedded industrial box, and I'm booting from CF card 
via IDE.  I switched build computers, target box stayed the same and the 
CF card stayed the same.  With the switch, the compiler changed and the 
USB CF writer changed (used to create the root fs on the CF card before 
it is moved), as did some configuration options.  I am now booting.  I 
am most suspicious of the original CF card writer device at this point.  
Please do not spend any more time on it unless I come back for another 
plea for help, such as if its the config options change.  I need more 
time to narrow down the explanation for the failure to boot.

My real pursuit here is to find the reason for a nearly 1 second latency 
when running a SCHED_RR userspace process.  The filesystem is ext3 off 
the flash card via IDE. Linux is yanking the machine away from this 
process sporadically for up to 1 second, no disk file calls in this 
proces, only some serial port and networking (epoll) userspace calls in 
a loop.  It is insane.  So I have to get either LTT or FTRACE enabled, 
never used either before.  Its been a tough 2 weeks.  Just getting the 
LTT patches in sync with a decent kernel has been nearly unbearable.

Thanks again,

Dick


