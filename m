Return-Path: <linux-kernel-owner+w=401wt.eu-S1759148AbXH2NLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbXH2NLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 09:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbXH2NLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 09:11:16 -0400
Received: from mail.tmr.com ([64.65.253.246]:34901 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbXH2NLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 09:11:15 -0400
Message-ID: <46D5706E.4050002@tmr.com>
Date: Wed, 29 Aug 2007 09:11:10 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Al Boldi <a1426z@gawab.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
References: <200708111344.42934.a1426z@gawab.com> <200708220127.30698.a1426z@gawab.com> <20070824134510.GA21382@elte.hu> <200708260127.32238.a1426z@gawab.com> <46D4E9FE.6080306@tmr.com> <20070829034542.GA32164@elte.hu>
In-Reply-To: <20070829034542.GA32164@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Bill Davidsen <davidsen@tmr.com> wrote:
>
>   
>>> There is another way to show the problem visually under X 
>>> (vesa-driver), by starting 3 gears simultaneously, which after 
>>> laying them out side-by-side need some settling time before 
>>> smoothing out.  Without __update_curr it's absolutely smooth from 
>>> the start.
>>>       
>> I posted a LOT of stuff using the glitch1 script, and finally found a 
>> set of tuning values which make the test script run smooth. See back 
>> posts, I don't have them here.
>>     
>
> but you have real 3D hw and DRI enabled, correct? In that case X uses up 
> almost no CPU time and glxgears makes most of the processing. That is 
> quite different from the above software-rendering case, where X spends 
> most of the CPU time.
>   

No, my test machine for that is a compile server, and uses the built-in 
motherboard graphics which are very limited. This is not in any sense a 
graphics powerhouse, it is used to build custom kernels and 
applications, and for testing of kvm and xen, and I grabbed it because 
it had the only Core2 CPU I could reboot to try new kernel versions and 
"from cold boot" testing, discovered the graphics smoothness issue by 
having several windows open on compiles, and developed the glitch1 
script as a way to reproduce it.

The settings I used, features=14, granularity=500000, work to improve 
smoothness on other machines for other uses, but they do seem to impact 
performance for compiles, video processing, etc, so they are not optimal 
for general use. I regard the existence of these tuning knobs as one of 
the real strengths of CFS, when you change the tuning it has a visible 
effect.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

