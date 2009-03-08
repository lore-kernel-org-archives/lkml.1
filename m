Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbZCHPec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbZCHPec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 11:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZCHPeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 11:34:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42723 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbZCHPeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 11:34:22 -0400
Date: Sun, 8 Mar 2009 16:33:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, manfred@colorfullife.com,
       Nadia.Derbey@bull.net, miltonm@austin.ibm.com,
       akpm@linux-foundation.org, peterz@infradead.org,
       lnxninja@linux.vnet.ibm.com, efault@gmx.de, riel@redhat.com
Subject: Re: [PATCH] make idr_remove_all() do removal -before- free_layer()
Message-ID: <20090308153336.GA19658@elte.hu>
References: <20090307222511.GA10727@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090307222511.GA10727@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> The following patch fixes a problem in the IDR system, where 
> an idr_remove_all() hands a data element to call_rcu() (via 
> free_layer()) before making that data element inaccessible to 
> new readers.  This is very bad, and results in readers still 
> having a reference to this data element at the end of the 
> grace period.  Tests on large machines that concurrently map 
> and unmap user-space memory within the same multithreaded 
> process result in crashes within about five minutes.  Applying 
> this patch increases the kernel's longevity to the 
> three-to-eight-hour range.
> 
> There appear to be other similar problems in 
> idr_get_empty_slot() and sub_remove(), but I fixed the easy 
> one in idr_remove_all() first.  It is therefore no surprise 
> that failures still occur.
> 
> (Yes, and I did look at the relevant patch last year without 
> spotting this one.  Goes to show the value of testing as well 
> as code review, I guess...)
> 
> Nadia, Manfred, any thoughts?
> 
> Located-by: Milton Miller II <miltonm@austin.ibm.com>
> Tested-by: Milton Miller II <miltonm@austin.ibm.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Hm, looks like something we really want to see fixed in 
2.6.29-final, right?

	Ingo
