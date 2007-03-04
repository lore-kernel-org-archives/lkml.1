Return-Path: <linux-kernel-owner+w=401wt.eu-S964978AbXCDB4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978AbXCDB4n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 20:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965010AbXCDB4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 20:56:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964978AbXCDB4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 20:56:42 -0500
Message-ID: <45EA274B.5090103@redhat.com>
Date: Sat, 03 Mar 2007 20:56:27 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>	<45E9DD4A.2060806@redhat.com>	<20070303131204.6706a95c.akpm@linux-foundation.org>	<45E9E910.2070804@redhat.com>	<20070303140744.b22699dd.akpm@linux-foundation.org>	<45E9F5DA.2070708@redhat.com>	<20070303145221.2a42cc0f.akpm@linux-foundation.org>	<45EA0C3D.1010001@redhat.com>	<20070303170237.31d26382.akpm@linux-foundation.org>	<45EA1F7B.9060107@redhat.com> <20070303174927.2d314a71.akpm@linux-foundation.org>
In-Reply-To: <20070303174927.2d314a71.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>>> Doing a refault thing would help a bit, but stops working at a certain point.
>> At what point does it stop working?
> 
> We need to store that this-page-got-reclaimed info somewhere.  I don't know
> how space-efficient that is.  Did anyone ever do an implementation?

One 32 bit word per evicted page that we keep track of.

> Of course, the pages need to be re-read again so there's a potential 100%
> hit there, which is in fact not a huge amount in this context.  Depends how
> often it occurs (all the time when refault is being useful?) versus what we
> gain from it.

At this point, when we see that a refaulted page is more
active than the coldest page on the active list, we can
also immediately shrink the active list.  That gives the
next inactive page a better chance to get promoted before
it gets evicted.

>> I am not asking this to be difficult, I just want to get Linux
>> a VM that does not need to be kludged up every time a distro
>> ships it to its customers.
> 
> We have a communication problem here.  Please please please work harder to
> get these problems communicated to the MM developers.  The only vendor MM
> kludge of which I'm aware is a thing which Andrea is working on to address
> a large-shm-segment versus bulk-IO problem (yup, database).
> 
> If you have enough of an understanding of a problem to be able to develop
> and productise a fix then share that info madly, asap.

The problem is that most of the distro patches are
kludges, which we would rather not see again in
future kernels.  They tend to work around the problem,
instead of being a proper fix, since reorganizing the
VM in the middle of a release is not an option.

However, incremental small-to-medium changes might
be an option for the upstream kernel, if you are
interested.

>> I believe one starting point would be a concept that people
>> cannot shoot holes in any more.  That is no guarantee, but
>> as long as the concept has known holes coding it up is likely
>> to be a waste of time since the code will need kludges to
>> deal with the problems later on and we'd be back to square
>> one.
> 
> You mean design it and review the design before coding it?  You'll find few
> objections there.

Few objections, but sadly also very few people interested in
actually reviewing the design :(

If you can find holes in http://linux-mm.org/PageReplacementDesign
please let me know :)

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
