Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbZCYJb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbZCYJb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbZCYJbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:31:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53334 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbZCYJbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:31:16 -0400
Date: Wed, 25 Mar 2009 10:30:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 00/11] sched: find_busiest_group() cleanup
Message-ID: <20090325093052.GD2341@elte.hu>
References: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gautham R Shenoy <ego@in.ibm.com> wrote:

> Hi,
> 
> This patchset contains the cleanup of the humongous 
> find_busiest_group() function.
> 
> Vaidy had  tried a hand at this before. His approach can be
> found here:
> http://lkml.org/lkml/2008/9/24/201 and
> http://lkml.org/lkml/2008/10/9/176
> 
> Though the code in this patchset has been written from scratch I 
> have reused some of the ideas that Vaidy had originally proposed. 
> Credit has been given whereever it is due :)
> 
> The patches in this series are incremental. Each one is a 
> functional patch, which compiles fine.
> 
> The steps followed in the cleanup are as follows:
> - Fix indentations.
> 
> - Group variables that serve a common high-level purpose into a single
>   structure.
> 
> - Use helper functions to perform all the calculatations, like calculating
>   the sched_domain and sched_group statistics, calculating the imbalance, etc.
> 
> - Move the power_savings_balance part, which depends on
>   (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) into a different section, thereby
>   eliminating the #ifdef jungle in helper functions.
> 
> - Add /** style comments for all the functions, including find_busiest_group()
> 
> - Add additional comments whereever appropriate.
> 
> After applying all the patches, the size of find_busiest_group() 
> goes down from 313 lines to 76 lines. Of course, there are the 
> helpers, but effort has been put to keep all the helper functions 
> within the 80 line limit.

Very nice series!

> Any feedback on the patches and how the functionality can be 
> tested is greatly appreciated.

I'll try my best to get this tested.

	Ingo
