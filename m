Return-Path: <linux-kernel-owner+w=401wt.eu-S933351AbXGQIQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351AbXGQIQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbXGQIPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:15:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59753 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbXGQIPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:15:51 -0400
Date: Tue, 17 Jul 2007 10:15:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] sched: fix newly idle load balance in case of SMT
Message-ID: <20070717081542.GB17234@elte.hu>
References: <20070716235214.GD3318@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716235214.GD3318@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> In the presence of SMT, newly idle balance was never happening for 
> multi-core and SMP domains(even when both the logical siblings are 
> idle).
> 
> If thread 0 is already idle and when thread 1 is about to go to idle, 
> newly idle load balance always think that one of the threads is not 
> idle and skips doing the newly idle load balance for multi-core and 
> SMP domains.
> 
> This is because of the idle_cpu() macro, which checks if the current 
> process on a cpu is an idle process. But this is not the case for the 
> thread doing the load_balance_newidle().
> 
> Fix this by using runqueue's nr_running field instead of idle_cpu(). 
> And also skip the logic of 'only one idle cpu in the group will be 
> doing load balancing' during newly idle case.

ah, indeed - good catch! I've checked the other uses of idle_cpu() and 
those seem to be fine. I've added your patch to my queue.

	Ingo
