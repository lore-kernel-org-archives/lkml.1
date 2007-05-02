Return-Path: <linux-kernel-owner+w=401wt.eu-S1766806AbXEBTnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766806AbXEBTnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766810AbXEBTnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:43:10 -0400
Received: from holomorphy.com ([66.93.40.71]:40780 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766806AbXEBTnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:43:06 -0400
Date: Wed, 2 May 2007 12:42:47 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ting Yang <tingy@cs.umass.edu>,
       linux-kernel@vger.kernel.org, "Tong N. Li" <tong.n.li@intel.com>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502194247.GW31925@holomorphy.com>
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu> <20070502173634.GA11308@in.ibm.com> <20070502174829.GX19966@holomorphy.com> <20070502181533.GA19479@elte.hu> <20070502185613.GU31925@holomorphy.com> <20070502191235.GA2455@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502191235.GA2455@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> Things are moving in good directions on all this as far as I'm 
>> concerned. Moving according to Ting Yang's analysis should wrap up the 
>> soundness concerns about intra-queue policy I've had. OTOH load 
>> balancing I know much less about (not that I was ever any sort of an 
>> expert on single queue affairs). [...]

On Wed, May 02, 2007 at 09:12:35PM +0200, Ingo Molnar wrote:
> the whole move to ->load_weight based calculations was to make CFS 
> integrate better with load-balancing and to bring the smpnice 
> infrastructure even more into the scheduler mainstream. [ There's a 
> small smpnice related buglet i fixed in -v9-to-be (based on Balbir 
> Singh's feedback), but otherwise it behaves quite well on SMP and that's 
> not a big surprise: i left the load-balancer largely intact. ]

Despite the original motive, the ->load_weight -based calculations
largely resolved my concerns about intra-queue prioritization. They
were the change to the ->fair_key computation I wanted to see, which
were still not enough because of the O(rq->nr_running) lag issue due to
the differences from EEVDF, but I wasn't entirely aware of that, only
suspicious that some issue remained.

Load balancing has non-negligible impacts on fairness but I'm almost
entirely ignorant of the aspects of the theory relating to it. More
knowledgeable people, e.g. Tong Li and Ting Yang, need to take over
reviewing here much as they did on the intra-queue front, where I only
knew enough to drop hints and not to make more useful suggestions.

O(1) vs. O(lg(n)) priority queues are not what matter here (well,
obviously O(n) priority queues would break), but rather O(1) vs. O(n)
lag.


-- wli
