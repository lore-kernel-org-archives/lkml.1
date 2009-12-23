Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZLWHGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZLWHGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 02:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbZLWHGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 02:06:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:46318 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZLWHGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 02:06:39 -0500
Message-ID: <4B31C210.4010100@kernel.org>
Date: Wed, 23 Dec 2009 16:09:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <4B2EE5A5.2030208@kernel.org> <1261387377.4314.37.camel@laptop> <4B2F7879.2080901@kernel.org> <1261405604.4314.154.camel@laptop> <4B3009DC.7020407@kernel.org> <1261480001.4937.21.camel@laptop> <4B319A20.9010305@kernel.org> <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain> <20091223060229.GA14805@elte.hu>
In-Reply-To: <20091223060229.GA14805@elte.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On 12/23/2009 03:02 PM, Ingo Molnar wrote:
> Not from lack of trying though ;-)
> 
> One key thing i havent seen in this discussion are actual measurements. I 
> think a lot could be decided by simply testing this patch-set, by looking at 
> the hard numbers: how much faster (or slower) did a particular key workload 
> get before/after these patches.

As Jeff pointed out, I don't think this is gonna result in any major
performance increase or decrease.  The upside would be lowered cache
pressure coming from different types of works sharing the same context
(this will be very difficult to measure).  The downside would be the
more complex code workqueue has to run to manage the shared pool.  I
don't think it's gonna be anything noticeable either way.  Anyways, I
can try to set up a synthetic case which involves a lot of work
executions and at least make sure there's no noticeable slow down.

> Likewise, if there's a reduction in complexity, that is a tangible metric as 
> well: lets do a few conversions as part of the patch-set and see how much 
> simpler things have become as a result of it.

Doing several conversions shouldn't be difficult at all.  I'll try to
convert async and slow work.

> We really are not forced to the space of Gedankenexperiments here.

Sure but there's a reason why I posted the patchset without the actual
conversions.  I wanted to make sure that it's not rejected on the
ground of its basic design.  I thought it was acceptable after the
first RFC round but while trying to merge the scheduler part, Peter
seemed mightily unhappy with the whole thing, so this second RFC
round.  So, if anyone has major issues with the basic design, please
step forward *now* before I go spending more time working on it.

Another thing is that after spending a couple of months polishing the
patchset, it feels quite tiring to keep the patchset floating (you
know - Oh, this new thing should be merged into this patch.  Dang, now
I have to refresh 15 patches on top of it).  I would really appreciate
if I can set up a stable tree.  Would it be possible to set up a sched
devel branch?

Thanks.

-- 
tejun
