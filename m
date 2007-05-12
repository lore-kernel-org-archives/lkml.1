Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbXELFvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbXELFvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 01:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXELFvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 01:51:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59995 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750930AbXELFvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 01:51:03 -0400
Date: Fri, 11 May 2007 22:51:11 -0700
From: Paul Jackson <pj@sgi.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: nickpiggin@yahoo.com.au, ray-lk@madrabbit.org, mingo@elte.hu,
       ck@vds.kolivas.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: swap prefetch improvements
Message-Id: <20070511225111.fee05bb9.pj@sgi.com>
In-Reply-To: <200705121516.00070.kernel@kolivas.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<200705121446.04191.kernel@kolivas.org>
	<20070511220314.f7af1d31.pj@sgi.com>
	<200705121516.00070.kernel@kolivas.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con wrote:
> Hmm I'm not really sure what it takes to make it cpuset aware;
> ...
> It is numa aware to some degree. It stores the node id and when it starts 
> prefetching it only prefetches to nodes that are suitable for prefetching to 
> ...
> It would be absolutely trivial to add a check for 'number_of_cpusets' <= 1
> in  the prefetch_enabled() function. Would you like that?

Hmmm ... it seems that we shadow boxing here ... trying to pick a solution
to solve a problem when we aren't even sure we have a problem, much less
what the problem is.

That does not usually lead to the right path.

Could you put some more effort into characterizing what problems
can arise if one has prefetch and cpusets active at the same time?

My first wild guess is that the only incompatibility would have been that
prefetch might mess up NUMA placement (get pages on wrong nodes), which
it seems you have tried to address in your current patches.  So it would
not surprise me if there was no problem here.

We may just have to lean on Nick some more, if he is the only one who
understands what the problem is, to try again to explain it to us.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
