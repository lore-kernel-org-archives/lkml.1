Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbXJCRop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbXJCRop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbXJCRoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:44:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51205 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754811AbXJCRog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:44:36 -0400
Date: Wed, 3 Oct 2007 10:44:33 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-Id: <20071003104433.083337ea.pj@sgi.com>
In-Reply-To: <200710030632.00062.nickpiggin@yahoo.com.au>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<200710030356.18090.nickpiggin@yahoo.com.au>
	<20071003051729.df3d8ab9.pj@sgi.com>
	<200710030632.00062.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick wrote:
> There won't be any CPU cycles used, if the tasks are paused (surely
> they're not spin waiting).

Consider the case when there are two, smaller, non-overlapping cpusets
with active jobs, and one larger cpuset, covering both those smaller
ones, with only paused tasks.

If we realize we don't need to balance the larger cpuset, then we can
have two smaller sched domains rather than one larger one.

Since the CPU cycle cost of load balancing increases more than linearly
with the size of the sched domain, therefore it will save CPU cycles to
have the two smaller ones, rather than the one larger one.

If user space can just tell us that the larger cpuset doesn't need
balancing, then the kernel has enough information to perform this
optimization.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
