Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbXEAORK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbXEAORK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbXEAORB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:17:01 -0400
Received: from holomorphy.com ([66.93.40.71]:41927 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbXEAOQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:16:48 -0400
Date: Tue, 1 May 2007 07:17:14 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Andi Kleen <ak@suse.de>, ebiederm@xmission.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the 2G/2G split.
Message-ID: <20070501141714.GT19966@holomorphy.com>
References: <20070501557.815359000@suse.de> <20070501035829.1C93D13CAF@wotan.suse.de> <20070501043735.GR31925@holomorphy.com> <46374171.1050009@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46374171.1050009@rtr.ca>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> There's some sort of insanity going on here. Since when is 0x78000000
>> a 2GB/2GB split? Mark, dare I ask what you were thinking? That should
>> be VMSPLIT_2G_OPT for 2GB laptops analogously to VMSPLIT_3G_OPT, if
>> nothing else, as it's certainly not 2GB/2GB.

On Tue, May 01, 2007 at 09:32:33AM -0400, Mark Lord wrote:
> You need to go search the archives and read the *extensive* thread
> on this from when it was introduced.  Lots of high profile kernel
> developers were in on this one.

Various good points were raised. The NX bit requiring
3-level pagetables suggests that 3-level pagetables without highmem
would be valuable, at which point the unaligned splits to avoid highmem
with 3-level pagetables gain additional relevance. I'll queue that up
to be written along with split pmd affairs, and check for features
dependent on 4-level pagetables, too.


On Tue, May 01, 2007 at 09:32:33AM -0400, Mark Lord wrote:
> The idea is really simple:  eliminate the need for HIGHMEM
> on common machines.  

Of course. Everything is simple until it's done properly. It's
why everyone forgets the "and no simpler" half of the quote, which
turns the meaning of what everyone tries to quote on its head.

I guess looking over it I don't blame you so much. I should've been
around to clean up these issues at the time it was happening. People
seem to have been trying to use the RAM in their laptops without big
slowdowns, and may not have had the VM "sophistication" to deal with
the sorts of issues I'm raising.


On Tue, May 01, 2007 at 09:32:33AM -0400, Mark Lord wrote:
> And yes, VMSPLIT_2G really means VMSPLIT_2G_OPT,
> in the same way as the (added last) VMSPLIT_3G_OPT flag.

This was a large portion of the substance of my complaint.


-- wli
