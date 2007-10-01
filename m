Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbXJASPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbXJASPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXJASPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:15:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49351 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751817AbXJASPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:15:33 -0400
Date: Mon, 1 Oct 2007 11:15:28 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-Id: <20071001111528.5487b4f4.pj@sgi.com>
In-Reply-To: <200709301335.00441.nickpiggin@yahoo.com.au>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<200709300521.03356.nickpiggin@yahoo.com.au>
	<20070930110753.19b03388.pj@sgi.com>
	<200709301335.00441.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick wrote:
> which you could equally achieve by adding
> a second set of sched domains (and the global domains could keep
> globally balancing).

Hmmm ... this could be the key to this discussion.

Nick - can two sched domains overlap?  And if they do, what does that
mean on any user or application behaviour.

>From the cpuset side - this patch handles overlap by joining the 'cpus'
into one sched domain.  If two cpusets with overlapping 'cpus' are both
marked 'sched_load_balance', then this patch forms a single, combined
sched domain.

As best as I can tell, you and I are actually in agreement in the
case that there is no overlap.  If the several cpusets which have
'sched_load_balance' enabled have mutually disjoint 'cpus' (no
overlap), then my patch forms exactly one sched domain for each such
cpuset, having the same 'cpus'.

The issue is the overlapping cases - are overlapping sched domains
allowed, and if so, how do they affect user space?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
