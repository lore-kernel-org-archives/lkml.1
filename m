Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbXENOyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbXENOyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 10:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbXENOyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 10:54:38 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49028 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbXENOyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 10:54:36 -0400
Date: Mon, 14 May 2007 20:32:34 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Ingo Molnar <mingo@elte.hu>, William Lee Irwin III <wli@holomorphy.com>,
       efault@gmx.de, tingy@cs.umass.edu, linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Message-ID: <20070514150234.GB6103@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070514083358.GA29775@in.ibm.com> <20070514110500.GV19966@holomorphy.com> <20070514115049.GA28721@elte.hu> <200705141031.13528.dhazelton@enter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705141031.13528.dhazelton@enter.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 10:31:13AM -0400, Daniel Hazelton wrote:
> Hrm... Okay, so you're saying that "fair_clock" runs slower the more process 
> there are running to keep the above run-up in "Time Spent on CPU" I noticed 
> based solely on your initial example? If that is the case, then I can see the 
> fairness - its just not visible from a really quick look at the code and the 
> simplified description you gave earlier.

>From the code:

update_curr() 

        delta_fair = delta_exec * NICE_0_LOAD;
        do_div(delta_fair, rq->raw_weighted_load);

	..

	rq->fair_clock += delta_fair;

Although wall clock would have advanced by delta_exec, fair clock
advances only by delta_fair.

More the load on the CPU (rq->raw_weighted_load), slower is this advance
compared to wall clock.



-- 
Regards,
vatsa
