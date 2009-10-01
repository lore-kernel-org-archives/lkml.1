Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZJARXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZJARXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZJARXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:23:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:52380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311AbZJARXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:23:31 -0400
Message-ID: <4AC4E55F.6070102@kernel.org>
Date: Fri, 02 Oct 2009 02:22:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: jeff@garzik.org, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 19/19] workqueue: implement concurrency managed workqueue
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-20-git-send-email-tj@kernel.org> <alpine.LFD.2.01.0910011008210.6996@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910011008210.6996@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 17:22:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Linus Torvalds wrote:
> 
> On Thu, 1 Oct 2009, Tejun Heo wrote:
>> To solve the above issues, this patch implements concurrency-managed
>> workqueue.
> 
> Ok, all the other patches in the series looked great, this one looks 
> scary. Everything else was pretty small and targeted, and if bugs appear, 
> bisection would show the step that was nasty.
> 
> And then comes the big flag-day patch that actually introduces all the new 
> logic, and is the most complex of the lot.
> 
> Maybe it's inevitable, but if this one could be split up a bit more, I'd 
> find the series less scary.
> 
> I don't know how, though (except by adding code that simply isn't used in 
> previous patches, and that doesn't really help anything at all), so maybe 
> the big "switch everything over at once" thing is unavoidable.

Yeap, this one is pretty scary.  I tried pretty hard to at least make
the diffs fall into relevant sections (ie. updates to certain part of
logic shows up as diffs to the original part) but I agree this patch
is a tad too big.  Maybe I can introduce gcwq first.  The big problem
is the strong inter-dependency between the single global worker pool
and the hotplug logic.  I tried to introduce the hotplug logic first
but it basically required implementing different interim mechanism
altogether.  One solution could be disabling or crippling cpu hotplug
support for several commits so that the processing part and hotplug
part can be introduced separately.  Would that be acceptable?

Thanks.

-- 
tejun
