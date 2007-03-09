Return-Path: <linux-kernel-owner+w=401wt.eu-S1767328AbXCIOvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767328AbXCIOvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 09:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767330AbXCIOvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 09:51:49 -0500
Received: from mail.tmr.com ([64.65.253.246]:33718 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767328AbXCIOvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 09:51:48 -0500
Message-ID: <45F17514.5070509@tmr.com>
Date: Fri, 09 Mar 2007 09:54:12 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ed Tomlinson <edt@aei.ca>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Revell <rlrevell@joe-job.com>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
   scheduler
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org> <75b66ecd0703051020h1f0c1f85r15a5de082a80cec0@mail.gmail.com> <200703051419.25814.gene.heskett@gmail.com> <200703052123.29421.edt@aei.ca> <Pine.LNX.4.64.0703051849410.3998@woody.linux-foundation.org> <45F0DCB7.5020908@tmr.com> <Pine.LNX.4.64.0703082226530.10832@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703082226530.10832@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, 8 Mar 2007, Bill Davidsen wrote:
>   
>> Please, could you now rethink plugable scheduler as well? Even if one had to
>> be chosen at boot time and couldn't be change thereafter, it would still allow
>> a few new thoughts to be included.
>>     
>
> No. Really.
>
> I absolutely *detest* pluggable schedulers. They have a huge downside: 
> they allow people to think that it's ok to make special-case schedulers. 
>   
But it IS okay for people to make special-case schedulers. Because it's 
MY machine, and how it behaves under mixed load is not a technical 
issue, it's a POLICY issue, and therefore the only way you can allow the 
admin to implement that policy is to either provide several schedulers 
or to provide all sorts of tunable knobs. And by having a few schedulers 
which have been heavily tested and reviewed, you can define the policy 
the scheduler implements and document it. Instead of people writing 
their own, or hacking the code, they could have a few well-tested 
choices, with known policy goals.
> And I simply very fundamentally disagree.
>
> If you want to play with a scheduler of your own, go wild. It's easy 
> (well, you'll find out that getting good results isn't, but that's a 
> different thing). But actual pluggable schedulers just cause people to 
> think that "oh, the scheduler performs badly under circumstance X, so 
> let's tell people to use special scheduler Y for that case".
>   
And has that been a problem with io schedulers? I don't see any vast 
proliferation of them, I don't see contentious exchanges on LKML, or 
people asking how to get yet another into mainline. In fact, I would say 
that the io scheduler situation is as right as anything can be, choices 
for special cases, lack of requests for something else.
> And CPU scheduling really isn't that complicated. It's *way* simpler than 
> IO scheduling. There simply is *no*excuse* for not trying to do it well 
> enough for all cases, or for having special-case stuff.
>   
This supposes that the desired behavior, the policy, is the same on all 
machines or that there is currently a way to set the target. If I want 
interactive response with no consideration to batch (and can't trust 
users to use nice), I want one policy. If I want a compromise, the 
current scheduler or RSDL are candidates, but they do different things.
> But even IO scheduling actually ends up being largely the same. Yes, we 
> have pluggable schedulers, and we even allow switching them, but in the 
> end, we don't want people to actually do it. It's much better to have a 
> scheduler that is "good enough" than it is to have five that are "perfect" 
> for five particular cases.
>   
We not only have multiple io schedulers, we have many tunable io 
parameters, all of which allow people to make their system behave the 
way they think is best. It isn't causing complaint, confusion, or 
instability. We have many people requesting a different scheduler, so 
obviously what we have isn't "good enough" and I doubt any one scheduler 
can be, given that the target behavior is driven by non-technical choices.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

