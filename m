Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbXH2DiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbXH2DiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 23:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXH2Dhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 23:37:52 -0400
Received: from mail.tmr.com ([64.65.253.246]:34875 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbXH2Dhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 23:37:51 -0400
Message-ID: <46D4E9FE.6080306@tmr.com>
Date: Tue, 28 Aug 2007 23:37:34 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
References: <200708111344.42934.a1426z@gawab.com> <200708220127.30698.a1426z@gawab.com> <20070824134510.GA21382@elte.hu> <200708260127.32238.a1426z@gawab.com>
In-Reply-To: <200708260127.32238.a1426z@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Ingo Molnar wrote:
>> * Al Boldi <a1426z@gawab.com> wrote:
>>>>> The problem is that consecutive runs don't give consistent results
>>>>> and sometimes stalls.  You may want to try that.
>>>> well, there's a natural saturation point after a few hundred tasks
>>>> (depending on your CPU's speed), at which point there's no idle time
>>>> left. From that point on things get slower progressively (and the
>>>> ability of the shell to start new ping tasks is impacted as well),
>>>> but that's expected on an overloaded system, isnt it?
>>> Of course, things should get slower with higher load, but it should be
>>> consistent without stalls.
>>>
>>> To see this problem, make sure you boot into /bin/sh with the normal
>>> VGA console (ie. not fb-console).  Then try each loop a few times to
>>> show different behaviour; loops like:
>>>
>>> # for ((i=0; i<3333; i++)); do ping 10.1 -A > /dev/null & done
>>>
>>> # for ((i=0; i<3333; i++)); do nice -99 ping 10.1 -A > /dev/null & done
>>>
>>> # { for ((i=0; i<3333; i++)); do
>>>         ping 10.1 -A > /dev/null &
>>>     done } > /dev/null 2>&1
>>>
>>> Especially the last one sometimes causes a complete console lock-up,
>>> while the other two sometimes stall then surge periodically.
>> ok. I think i might finally have found the bug causing this. Could you
>> try the fix below, does your webserver thread-startup test work any
>> better?
> 
> It seems to help somewhat, but the problem is still visible.  Even v20.3 on 
> 2.6.22.5 didn't help.
> 
> It does look related to ia-boosting, so I turned off __update_curr like Roman 
> mentioned, which had an enormous smoothing effect, but then nice levels 
> completely break down and lockup the system.
> 
> There is another way to show the problem visually under X (vesa-driver), by 
> starting 3 gears simultaneously, which after laying them out side-by-side 
> need some settling time before smoothing out.  Without __update_curr it's 
> absolutely smooth from the start.

I posted a LOT of stuff using the glitch1 script, and finally found a 
set of tuning values which make the test script run smooth. See back 
posts, I don't have them here.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
