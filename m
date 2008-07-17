Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbYGQSxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbYGQSxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760519AbYGQSxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:53:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2628 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351AbYGQSxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:53:02 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5340"; a="4809693"
Message-ID: <487F9509.9050802@qualcomm.com>
Date: Thu, 17 Jul 2008 11:52:57 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, dmitry.adamushko@gmail.com,
       torvalds@linux-foundation.org, pj@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu hotplug, sched: Introduce	cpu_active_map	and	redoscheddomain
 managment (take 2)
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com> <487DAD86.BA47.005A.0@novell.com> <487E6BD7.3020006@qualcomm.com> <487E7B6C.BA47.005A.0@novell.com> <487EF1E9.2040101@qualcomm.com> <487EFB71.BA47.005A.0@novell.com>
In-Reply-To: <487EFB71.BA47.005A.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>>>> On Thu, Jul 17, 2008 at  3:16 AM, in message <487EF1E9.2040101@qualcomm.com>,
> Max Krasnyansky <maxk@qualcomm.com> wrote: 
> 
>> Gregory Haskins wrote:
>>> Well, admittedly I am not entirely clear on what problem is being solved as
>>> I was not part of the original thread with Linus.  My impression of what you
>>> were trying to solve was to eliminate the need to rebuild the domains for a
>>> hotplug event (which I think is a good problem to solve), thus eliminating
>>> some complexity and (iiuc) races there.
>>>
>>> However, based on what you just said, I am not sure I've got that entirely
>>> right anymore.  Can you clarify the intent (or point me at the original 
>> thread)
>>> so we are on the same page?
>> Here is the link to the original thread
>> 	http://lkml.org/lkml/2008/7/11/328
>> And here is where Linus explained the idea
>> 	http://lkml.org/lkml/2008/7/12/137
>>
>> I'll reply to the rest of your email tomorrow (can't keep my yes open any
>> longer :)).
>>
>> Max
> 
> Hi Max,
>   Thanks for the pointers.  I see that I did indeed misunderstand the intent of the patch.
> It seems you already solved the rebuild problem, and were just trying to solve the
> "migrate to a dead cpu" problem that Linus mentions as a solution with cpu_active_map.
Yes. btw they are definitely related, because the reason we were blowing away
the domains is to avoid "migration to a dead cpu". ie We were relying on the
fact that domain masks never contain cpus that are either dying or already dead.

> In that case, note that rq->rd->online already fits the bill, I believe.  In a nutshell,
> rq->rd->span contains all the cpus within your disjoint cpuset, and rq->rd->online,
> contains the subset of rq->rd->span that are online.  The online bit is cleared at the
> earliest point in cpu hotplug removal (DYING), and it is set at the very latest point on
> insertion (ONLINE).  Therefore it is redundant with the cpus_active_map concept.
> 
> I think the simplest solution is to make sure that we cpus_and against rq->rd->online
> before allowing a migration.  This is how I intended the mask to be used, anyway.  Its
> what the RT scheduler does.  It sounds like we just need to touch up the few places
> in the CFS side that were causing those oops.
> 
> Thoughts?
None at this point :). I need to run right now and will try to look at this
later today. My knowledge of the internal sched structs is definitely lacking
so I need to look at the rq->rd thing to have and opinion.

Thanx
Max


