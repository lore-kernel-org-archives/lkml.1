Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbYHKS2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbYHKS2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbYHKS2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:28:17 -0400
Received: from gw.goop.org ([64.81.55.164]:54650 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688AbYHKS2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:28:17 -0400
Message-ID: <48A084AC.4090006@goop.org>
Date: Mon, 11 Aug 2008 11:27:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       npiggin@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com
Subject: Re: [PATCH] stack and rcu interaction bug in smp_call_function_mask()
References: <20080808193753.GA21964@linux-os.sc.intel.com> <200808101624.15112.nickpiggin@yahoo.com.au> <489FBF6A.40402@goop.org> <200808111449.48123.nickpiggin@yahoo.com.au>
In-Reply-To: <200808111449.48123.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Well that's implemented with the optimized call-single code of course,
> so it could be used to implement the masked calls...
>
> I had wanted to look into finding a good cutoff point and use the
> percpu queues for light weight masks, and the single global queue for
> larger ones.
>
> Queue per cpu is not going to be perfect, though. In the current
> implementation, you would need a lot of data structures. You could
> alleviate this problem by using per CPU vectors rather than lists,
> but then you get the added problem of resource starvation at the
> remote end too.
>
> For heavy weight masks on large systems, the single queue I'd say
> will be a win. But I never did detailed measurements, so I'm open
> to be proven wrong.
>   

Yeah, there's a lot of parameters there.  And as I've mentioned before, 
I wonder whether we should take NUMA topology into account when deciding 
where and when to use queues.  My intuition is that most cross-cpu calls 
are going to be within cpus on a node, on the grounds that most are 
mm->cpu_vm_mask calls, and the rest of the system tries hard to 
co-locate processes sharing memory on one node.

Waffle, handwave.

    J
