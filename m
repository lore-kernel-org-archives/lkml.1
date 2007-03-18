Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbXCRFzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbXCRFzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 01:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbXCRFzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 01:55:25 -0400
Received: from mtaout2.012.net.il ([84.95.2.4]:59696 "EHLO mtaout2.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbXCRFzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 01:55:24 -0400
Date: Sun, 18 Mar 2007 07:55:21 +0200
From: Avi Kivity <avi@argo.co.il>
Subject: Re: is RSDL an "unfair" scheduler too?
In-reply-to: <20070318052439.GT943@1wt.eu>
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <45FCD449.60303@argo.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Sun,
 18 Mar 2007 07:55:22 +0200 (IST)
References: <200703042335.26785.a1426z@gawab.com>
 <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru>
 <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu>
 <45FC525D.5000708@argo.co.il> <20070318012533.GB2986@holomorphy.com>
 <Pine.LNX.4.64.0703171830130.4964@woody.linux-foundation.org>
 <20070318052439.GT943@1wt.eu>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Sat, Mar 17, 2007 at 06:32:29PM -0700, Linus Torvalds wrote:
>   
>> On Sat, 17 Mar 2007, William Lee Irwin III wrote:
>>     
>>> One issue this raises is prioritizing users on a system, threads within
>>> processes, jobs within users, etc.
>>>       
>> Doing some "classing" even by just euid might be a good idea. It would 
>> actually catch X automatically most of the time, because the euid of the X 
>> server is likely to be root, so even for the "trivial" desktop example, it 
>> would kind of automatically mean that X would get about 50% of CPU time 
>> even if you have a hundred user clients, just because that's "fair" by 
>> euid.
>>     
>
> Warning: all these ideas seem interesting for desktop, but are definitely
> not for servers. I found RSDL to be excellent on servers, compared to
> mainline in which some services are starving under load. I can understand
> that on the desktop people want some unfairness, and I like the pgrp idea
> for instance. But this one will certainly fail on servers, or make the
> admins get grey hair very soon.
>   

I didn't suggest adding any unfairness!  I suggested being fair by 
user/job/process instead of being fair by thread (which is actually 
unfair as it favors multi threaded processes over single threaded 
processes).

> Maybe we're all discussing the problem because we have reached the point
> where we need two types of schedulers : one for the desktop and one for
> the servers. After all, this is already what is proposed with preempt,
> it would make sense provided they share the same core and avoid ifdefs
> or unused structure members. Maybe adding OPTIONAL unfairness to RSDL
> would help some scenarios, but in any case it is important to retain
> the default fairness it provides.
>   

I hope not.  I think that reducing the timeslice base, combined with 
renicing X all the way to hell should suffice.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

