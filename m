Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbZLOLBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbZLOLBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 06:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZLOLBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 06:01:07 -0500
Received: from ozlabs.org ([203.10.76.45]:40428 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759480AbZLOLBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 06:01:04 -0500
Date: Tue, 15 Dec 2009 22:00:55 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH 1/2] perf_event: Fix incorrect range check on cpu number
Message-ID: <20091215110055.GC18661@brick.ozlabs.ibm.com>
References: <20091215084032.GA18661@brick.ozlabs.ibm.com>
 <1260873092.4165.354.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260873092.4165.354.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 11:31:32AM +0100, Peter Zijlstra wrote:

> On Tue, 2009-12-15 at 19:40 +1100, Paul Mackerras wrote:
> > It is quite legitimate for CPUs to be numbered sparsely, meaning that
> > it possible for an online CPU to have a number which is greater than
> > the total count of possible CPUs.
> > 
> > Currently find_get_context() has a sanity check on the cpu number
> > where it checks it against num_possible_cpus().  This test can fail
> > for a legitimate cpu number if the cpu_possible_mask is sparsely
> > populated.
> > 
> > This fixes the problem by checking the CPU number against
> > nr_cpumask_bits instead, since that is the appropriate check to ensure
> > that the cpu number is same to pass to cpu_isset() subsequently.
> 
> Cute, do you actually have hardware that does this?

Yeah, Mikey ran across this on a POWER7 box here.

Paul.
