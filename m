Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZBLGAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZBLGAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 01:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbZBLGAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 01:00:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58605 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZBLGAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:00:09 -0500
Message-ID: <4993BA44.2070809@cn.fujitsu.com>
Date: Thu, 12 Feb 2009 13:57:24 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@usa.net>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       Derek Fults <dfults@sgi.com>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the
 unallowed node when memory spread is set
References: <4976D77C.3020107@cn.fujitsu.com>	 <200902091502.27056.nickpiggin@yahoo.com.au>	 <6599ad830902100337mbde885fr89e5942f1016a1c@mail.gmail.com>	 <200902121154.02868.nickpiggin@yahoo.com.au> <6599ad830902111719n2750ac29u458face30bf3f7cb@mail.gmail.com>
In-Reply-To: <6599ad830902111719n2750ac29u458face30bf3f7cb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2009-2-12 9:19 Paul Menage wrote:
> On Wed, Feb 11, 2009 at 4:54 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>> It would be possible, depending on timing, for the allocating thread to
>> see either pre or post mems_allowed even if access was fully locked.
> 
> Right - seeing either the pre set or the post set is fine.
> 
>> The only difference is that a partially changed mems_allowed could be
>> seen. But what does this really mean? Some combination of the new and
>> the old nodes. I don't think this is too much of a problem.
> 
> But if the old and new nodes are disjoint, that could lead to seeing no nodes.
> 
> Also, having the results of cpuset_zone_allowed() and
> cpuset_current_mems_allowed change at random times over the course of
> a call to alloc_pages() might cause interesting effects (e.g. we make
> progress freeing pages from one set of nodes, and then call
> get_page_from_freelist() on a different set of nodes).
> 
>> This could work if we *really* need an atomic snapshot of mems_allowed.
>> seqcount synchronisation would be an alternative too that could allow
>> sleeping more easily than SRCU (OTOH if you don't need sleeping, then
>> RCU should be faster than seqcount).
>>
>> But I'm not convinced we do need this to be atomic.
> 
> It's possible that I'm being overly-paranoid here. The decision to
> make mems_allowed updates be purely pulled by the task itself predates
> my involvement with cpusets code by a long time. Paul Jackson (CC'd)
> may have opinions here, but I suspect his sgi.com email address no
> longer works, and I don't have any more recent address for him.

I think it's pj@usa.net(CC'd).

Author: Paul Jackson <pj@sgi.com>
Date:   Fri Oct 3 15:23:42 2008 -0700

    cpusets: remove pj from cpuset maintainers

    Remove myself from the kernel MAINTAINERS file for cpusets.  I am leaving
    SGI and probably will not be active in Linux kernel work.  I can be
    reached at <pj@usa.net>.  Contact Derek Fults <dfults@sgi.com> for future
    SGI+cpuset related issues.  I'm off to the next chapter of this good life.

    Signed-off-by: Paul Jackson <pj@sgi.com>
    Cc: Paul Menage <menage@google.com>
    Cc: Derek Fults <dfults@sgi.com>
    Cc: John Hesterberg <jh@sgi.com>
    Cc: Paul Jackson <pj@usa.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Thanks!
Miao

> 
> Paul
> 
> 
> 


