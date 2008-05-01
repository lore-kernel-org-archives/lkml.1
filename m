Return-Path: <linux-kernel-owner+w=401wt.eu-S1765138AbYEAXJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765138AbYEAXJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933454AbYEAXGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:06:17 -0400
Received: from simmts12-qfe0.srvr.bell.ca ([206.47.199.141]:34794 "EHLO
	simmts12-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933439AbYEAXGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:06:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqoBALbpGUicIvqD/2dsb2JhbAAIimyGDZtm
Message-ID: <481A4CE1.2060503@gmail.com>
Date: Thu, 01 May 2008 20:06:09 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       mingo@elte.hu
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080430135405.ddc42075.akpm@linux-foundation.org> <4818 <alpine.LFD.1.10.0804301513350.2980@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301513350.2980@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 30 Apr 2008, Andrew Morton wrote:
>>> For busy (or lazy) people like myself, the big problem with linux-next are
>>> the frequent merge breakages, when pulling the tree stops with "you are in
>>> the middle of a merge conflict".
>> Really?  Doesn't Stephen handle all those problems?  It should be a clean
>> fetch each time?
> 
> It should indeed be a clean fetch, but I wonder if Dmitri perhaps does a 
> "git pull" - which will do the fetch, but then try to _merge_ that fetched 
> state into whatever the last base Dmitri happened to have.
> 
> Dmitry: you cannot just "git pull" on linux-next, because each version of 
> linux-next is independent of the next one. What you should do is basically
> 
> 	# Set this up just once..
> 	git remote add linux-next git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> 
> and then after that, you keep on just doing
> 
> 	git fetch linux-next
> 	git checkout linux-next/master
> 
> which will get you the actual objects and check out the state of that 
> remote (and then you'll normally never be on a local branch on that tree, 
> git will end up using a so-called "detached head" for this).
> 
> IOW, you should never need to do any merges, because Stephen did all those 
> in linux-next already.
> 

Just to add some emphasis here - this is something that took me a long time to figure out, and since it is the pattern for dealing with the x86 trees and with the mm git tree and with linux-next, it would help if it were documented somewhere (not that I can imagine where).  Once you know it, it becomes obvious, but try staring at a merge conflict for a while trying to figure out what to do, and it gets frustrating.  I wonder if we can guess how many testers abandon the mm git tree or the linux-next tree because of this.

It might be nice if git supported a command like git-remote-help or something that would fetch a predefined help file from a remote tree that describes the workflow for that tree.

But at least with an extra reply to this mail, it might creep higher in the google search results when looking for merge conflicts with linux-next.

-- 
Kevin Winchester
 
