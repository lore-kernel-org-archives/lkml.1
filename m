Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbXEGWuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbXEGWuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbXEGWuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:50:13 -0400
Received: from as1.cineca.com ([130.186.84.251]:47635 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbXEGWuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:50:11 -0400
Message-ID: <463FACF9.2080301@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] VM: per-user overcommit policy
References: <463F764E.5050009@users.sourceforge.net> <20070507212322.6d60210b@the-village.bc.nu>
In-Reply-To: <20070507212322.6d60210b@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Tue,  8 May 2007 00:49:57 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> - allow uid=1001 and uid=1002 (common users) to allocate memory only if the
>>   total committed space is below the 50% of the physical RAM + the size of
>>   swap:
>> root@host # echo 1001:2:50 > /proc/overcommit_uid
>> root@host # echo 1002:2:50 > /proc/overcommit_uid
> 
> There are some fundamental problems with this model - the moment you mix
> strict overcommit with anything else it ceases to be a strict overcommit
> and you might as well use existing overcommit rules for most stuff
> 
> The other thing you are sort of faking is per user resource management -
> which is a subset of per group of users resource management which is
> useful - eg "students can't hog the machine"
> 
> I don't see that this is the right approach compared with the container
> work and openvz work that is currently active and far more flexible.
> 

Obviously I was not proposing a nice theoretical model, my work is more similar
to a quick and dirty hack that could resolve some problems (at least in my case)
like the crash of critical services due to OOM-killing (or due to the failure of
a malloc() when OOM-killer is disabled).

When $VERY_CRITICAL_DAEMON dies *all* the users blame the sysadmin [me]. If a
user application dies because a malloc() returns NULL, the sysadmin [I] can
blame the user saying: "hey! _you_ tried to hog the machine and _your_
application is not able to handle the NULL result of the malloc()s!"... :-)

A solution could be to define the critical processes unkillable via
/proc/<pid>/oom_adj, but the per-process approach doesn't resolve all the
possible cases and it's quite difficult to manage in big environments, like HPC
clusters.

Anyway, it seems that I need to deepen my knowledge about the recent development
of process containers and openvz...

Thanks,
-Andrea
