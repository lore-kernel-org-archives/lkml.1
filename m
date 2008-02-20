Return-Path: <linux-kernel-owner+w=401wt.eu-S1761189AbYBTNiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761189AbYBTNiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYBTNiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:38:10 -0500
Received: from sacred.ru ([62.205.161.221]:35536 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbYBTNiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:38:09 -0500
Message-ID: <47BC2619.1060309@openvz.org>
Date: Wed, 20 Feb 2008 16:07:37 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Nick Andrew <nick@nick-andrew.net>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 2.6.25-rc2 3/9] config: Improve init/Kconfig help	descriptions
 - namespaces
References: <20080219140609.GA26619@tull.net> <20080219143307.GA27352@tull.net> <47BAEABF.6050005@openvz.org> <20080219151028.GA28294@tull.net> <47BAF2E5.8050001@openvz.org> <20080219084420.f3104e3f.randy.dunlap@oracle.com> <20080220121915.GA2169@tull.net> <47BC1BA9.5040009@openvz.org> <20080220130142.GC2169@tull.net>
In-Reply-To: <20080220130142.GC2169@tull.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 20 Feb 2008 16:07:29 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Andrew wrote:
> On Wed, Feb 20, 2008 at 03:23:05PM +0300, Pavel Emelyanov wrote:
>>> +	  This is used by container systems (i.e. vservers).
>>> +	  Tasks in the container are placed in the PID namespace
>>> +	  corresponding to the container, and can only see or
>>> +	  affect processes in the same PID namespace.
>> same of one of child namespaces. In other words when you create
>> a new pid namespace, you still see the tasks from this new one,
>> but the tasks from this one, doesn't see yours :)
> 
> Due to the hierarchial nature, I see. I'm still trying to grok
> it. Would it be adequate to describe what a process _cannot_
> do? i.e.
> 
>           This is used by container systems (i.e. vservers).
>           Tasks in the container are placed in the PID namespace
>           corresponding to the container, and cannot see or
>           affect processes in any parent PID namespaces.

This looks better.

> Or maybe I should say both what it cannot do and what it can,
> so readers don't have to use their imagination much :-)

I think this would be redundant.

> Let's see if I understand how it works with an example. Say we've
> got a hierarchy of PID namespaces ... pidA/pidB/pidC and a new
> process created in pidC. This new process may have pid 18925 in
> pidA, 2263 in pidB and 56 in pidC?

Yes.

> So if there's another process running in pidC, the first process
> may be signaled as pid 56, and if a process is running in pidB
> it would be 2263 and not 56. Can a process running in pidB see
> all processes running in pidC only with their pidB PIDs?

Yes it can.

> Now, a process A running in pidA can send a signal to a process
> C running in pidC but not vice-versa. 

Right.

> Process C cannot know where the signal came from. 

Signal delivery is not yet finished, but this is what we
plan to do.

> Is there any kernel mechanism
> which normally would provide that kind of information to
> process C but which breaks when PID namespaces are used,
> because there's no way to name process A from the context
> of pidC ?

If the process from pidC receives a signal from pidB or pidA
then the appropriate siginfo will (ok - should :)) contain the 
SI_KERNEL code and zero pid, as if the kernel shoot this process.

> Nick.
> 

