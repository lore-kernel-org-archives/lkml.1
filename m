Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXJCMRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXJCMRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbXJCMRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:17:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51138 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755499AbXJCMRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:17:31 -0400
Date: Wed, 3 Oct 2007 05:17:29 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-Id: <20071003051729.df3d8ab9.pj@sgi.com>
In-Reply-To: <200710030356.18090.nickpiggin@yahoo.com.au>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<200710030209.56879.nickpiggin@yahoo.com.au>
	<20071003025518.7c184905.pj@sgi.com>
	<200710030356.18090.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick wrote:
> OK, so I don't exactly understand you either. To make it simple, can
> you give a concrete example of a cpuset hierarchy that wouldn't
> work?

It's more a matter of knowing how my third party batch scheduler
coders think.  They will be off in some corner of their code with a
cpuset in hand that they know is just being used to hold inactive
(paused) tasks, and they can likely be persuaded to mark those cpusets
as not being in need of any wasted CPU cycles load balancing them.

But these inactive cpusets will overlap in unknown (to them at
the time, in that piece of code) ways with other cpusets holding
active jobs, and there is no chance, unless it is a matter of major
performance impact, that they will be in any position to comment on
the proper partitioning of the sched domains on all the CPUs under the
control of their batch scheduler, much less comment on the partitioning
of the rest of the system.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
