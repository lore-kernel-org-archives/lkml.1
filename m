Return-Path: <linux-kernel-owner+w=401wt.eu-S965862AbXCSPZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965862AbXCSPZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965885AbXCSPZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:25:23 -0400
Received: from il.qumranet.com ([82.166.9.18]:57381 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965862AbXCSPZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:25:22 -0400
Message-ID: <45FEAB60.7090704@argo.co.il>
Date: Mon, 19 Mar 2007 17:25:20 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: davids@webmaster.com
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: is RSDL an "unfair" scheduler too?
References: <MDEHLPKNGKAHNMBLJOLKGEMBCFAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEMBCFAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[what happened to the 'To' header?]

David Schwartz wrote:
>> I didn't suggest adding any unfairness!  I suggested being fair by
>> user/job/process instead of being fair by thread (which is actually
>> unfair as it favors multi threaded processes over single threaded
>> processes).
>>     
>
> Wouldn't that be unfair because it favors multi-user approaches over
> single-user approaches with the same number of processes?
>
> Consider two otherwise equivalent web server designs. They both use a helper
> process owned by the user who owns the file the web server is sending. One
> does a lot of work in the helper process, the other does very little. A
> "fair by user" scheduler would give the approach that puts more work in the
> helper process more CPU than the one that puts little work in the helper
> process.
>   

A fairly contrived example, but I see your point.  Of course any system 
can be broken.  I think that user-level scheduling is good for real 
multi user systems, where 'user' means a person, not an artificial 
entity.  It's also good for a multi application server, where typically 
each service runs (or can be made to run) as a separate user.

> Being fair by user builds lots of assumptions into the scheduler. When
> they're not true, the scheduler becomes sub-optimal. For example, consider a
> web server that runs two very important tools, 'foo' and 'bar'. Rather than
> running them as root, they run as users 'foo' and 'bar' for security. "Fair
> to user" would mean that just because most other people are using 'foo', I
> get less CPU when I try to use 'foo', because the OS doesn't know the "real
> user", just the fake user who owns the process -- a security decision that
> has no relationship to fairness. This would be handled perfectly by a "fair
> to process" approach.
>   

Perhaps we need a scheduling class instead, defaulting to each user 
being in its own class, and system processes in another (or maybe more 
than one) class.  Root can configure the relative priorities of the 
various classes according to preferences.

> As for favoring multi-threaded processes over single-threaded processes,
> sometimes that's what you want. Consider two servers, one using thread per
> job the other using process per job. Does it make sense to give the "process
> per job" server as much CPU to do a single task as the "thread per job"
> server gets for all the clients it's dealing with?
>
>   

That's why I wanted the job abstraction, which currently isn't 
communicated to the kernel (or at least not well).  Within a user's 
quota, jobs are scheduled fairly.

> It's really more important that the scheduler be tunable and predictable.
> That way, we can tell it what we want and get it. But the scheduler cannot
> read our minds.
>   

For multiuser systems, it also has to provide predictable response to 
unpredictable loads.  RSDL accomplishes part of this by removing 
heuristics.  User-level scheduling does more by limiting the impact of a 
single user to 1/N of the system's cpu capacity, and similarly limits 
the impact of a single job to 1/number_of_active_jobs_for_this_user.

-- 
error compiling committee.c: too many arguments to function

