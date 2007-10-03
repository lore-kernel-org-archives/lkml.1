Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbXJCH0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbXJCH0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 03:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbXJCH0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 03:26:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35596 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751761AbXJCH0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 03:26:02 -0400
Date: Wed, 3 Oct 2007 00:25:55 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-Id: <20071003002555.045bea2a.pj@sgi.com>
In-Reply-To: <200710022335.05357.nickpiggin@yahoo.com.au>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<200709301335.00441.nickpiggin@yahoo.com.au>
	<20071001111528.5487b4f4.pj@sgi.com>
	<200710022335.05357.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick wrote:
> BTW. as far as the sched.c changes in your patch go, I much prefer
> the partition_sched_domains API: http://lkml.org/lkml/2006/10/19/85
> 
> The caller should manage everything itself, rather than
> partition_sched_domains doing half of the memory allocation.

Please take a closer look at my partition_sched_domains() and its
interface to the scheduler.

You should recognize this API, once you look at it.  It simply passes
the full flat, hard partition, in its entirety.  This is the
partitioning that you speak of, I believe.  It's here; just not where
you expected it.

The portion of the code that is in kernel/sched.c is just a little bit
of optimization.  It avoids rebuilding all the sched domains and
reattaching every task to its sched domain; rather it determines which
sched domains were added or removed and just rebuilds them.

Once you take a closer look, I hope you will agree that this new
interface between the cpuset and sched code provides a cleaner
separation.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
