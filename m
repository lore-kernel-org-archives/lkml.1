Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbZEVKIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbZEVKIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 06:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbZEVKIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 06:08:21 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:39527 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283AbZEVKIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 06:08:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18966.30958.755834.332163@cargo.ozlabs.ibm.com>
Date: Fri, 22 May 2009 20:05:34 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
 identical inherited contexts
In-Reply-To: <1242984129.26820.627.camel@twins>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	<18966.10666.517218.332164@cargo.ozlabs.ibm.com>
	<1242984129.26820.627.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> On Fri, 2009-05-22 at 14:27 +1000, Paul Mackerras wrote:
> > 
> >                 -----Unmodified-----            With this patch series
> > Counters:       none    2 HW    4H+4S   none    2 HW    4H+4S
> > 
> > 2 processes:
> > Average         3.44    6.45    11.24   3.12    3.39    3.60
> > St dev          0.04    0.04    0.13    0.05    0.17    0.19
> > 
> > 8 processes:
> > Average         6.45    8.79    14.00   5.57    6.23    7.57
> > St dev          1.27    1.04    0.88    1.42    1.46    1.42
> > 
> > 32 processes:
> > Average         5.56    8.43    13.78   5.28    5.55    7.15
> > St dev          0.41    0.47    0.53    0.54    0.57    0.81
> 
> Any clues as to why the time is still dependent on the number of
> counters in the context? The approach seems to be O(1) in that it
> does a simple counter context swap on sched_out and nothing on sched_in.

Only the context switches between the lat_ctx processes will be
optimized; switches between them and other processes will still do the
full PMU switch.  The CPU would be switching to other processes
from time to time during the run (e.g. to run various kernel daemons,
which seem to continue to proliferate) so some fraction of the context
switches would be as expensive as before.  Probably I should measure
what that fraction is, but it's Friday night and I'm feeling lazy. :)

Paul.
