Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXEDF6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXEDF6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 01:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932179AbXEDF6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 01:58:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37841 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932117AbXEDF6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 01:58:40 -0400
Date: Thu, 3 May 2007 22:58:32 -0700
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kenchen@google.com, linux-kernel@vger.kernel.org, agl@us.ibm.com,
       hermes@gibson.dropbear.id.au, wli@holomorphy.com, clameter@sgi.com
Subject: Re: + per-cpuset-hugetlb-accounting-and-administration.patch added
 to -mm tree
Message-Id: <20070503225832.972057ef.pj@sgi.com>
In-Reply-To: <20070503220331.8fd70ca5.akpm@linux-foundation.org>
References: <200705040104.l4414YFR026322@shell0.pdx.osdl.net>
	<20070503183821.b75e8f57.pj@sgi.com>
	<b040c32a0705032149t2a380f82t8145c1d0f8f6736@mail.gmail.com>
	<20070503220331.8fd70ca5.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> If it's per-cpuset information then shouldn't it be presented in
> /dev/cpuset/something?

Yeah - if huge pages were mainline future, rather than the more
controversial sideline they are now, then it would make more sense
to put in these stats in each cpuset.

Note, Ken, that if we did that, the calculation of these new Total and
Free stats would be a little different than your new code.  Instead of
looping over the memory nodes in the current tasks mems_allowed mask,
we would loop over the memory nodes allowed in the cpuset being queried
(the cpuset whose 'hugepages_total' or 'hugepages_free' special
file we were reading, not the current tasks cpuset.)

But I'm reluctant to entertain such cpuset additions until I see more
of where my colleague Christoph is going in related work.

Clearly as can be seen on one of his posts on the parallel lkml thread:

  Re: + pretend-cpuset-has-some-form-of-hugetlb-page-reservation.patch added to -mm tree

earlier today, Christoph is no great fan of the current implementation
of huge pages.

And clearly as memory continues to get bigger, we will be putting more
stress on these page size related mechanisms.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
