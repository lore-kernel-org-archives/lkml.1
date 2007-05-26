Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbXEZAR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbXEZAR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 20:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbXEZARv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 20:17:51 -0400
Received: from omta03sl.mx.bigpond.com ([144.140.92.155]:43222 "EHLO
	omta03sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbXEZARv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 20:17:51 -0400
Message-ID: <46577CA6.8000807@bigpond.net.au>
Date: Sat, 26 May 2007 10:17:42 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: vatsa@in.ibm.com
CC: Kirill Korotaev <dev@sw.ru>, Nick Piggin <nickpiggin@yahoo.com.au>,
       tingy@cs.umass.edu, ckrm-tech@lists.sourceforge.net,
       Balbir Singh <balbir@in.ibm.com>, efault@gmx.de, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, wli@holomorphy.com, tong.n.li@intel.com,
       containers@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
References: <20070523164859.GA6595@in.ibm.com> <3d8471ca0705231112rfac9cfbt9145ac2da8ec1c85@mail.gmail.com> <20070523183824.GA7388@elte.hu> <4654BF88.3030404@yahoo.fr> <20070525074500.GD6157@in.ibm.com> <20070525082951.GA25280@elte.hu> <4656DF0C.9090306@sw.ru> <20070525153450.GA4679@in.ibm.com> <46570C70.4050209@sw.ru> <20070525180850.GA26884@in.ibm.com>
In-Reply-To: <20070525180850.GA26884@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta03sl.mx.bigpond.com from [60.231.45.148] using ID pwil3058@bigpond.net.au at Sat, 26 May 2007 00:17:47 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> Good example :) USER2's single task will have to share its CPU with
> USER1's 50 tasks (unless we modify the smpnice load balancer to
> disregard cpu affinity that is - which I would not prefer to do).

I don't think that ignoring cpu affinity is an option.  Setting the cpu 
affinity of tasks is a deliberate policy action on the part of the 
system administrator and has to be honoured.  Load balancing has to do 
the best it can in these circumstances which may mean sub optimal 
distribution of the load BUT it is result of a deliberate policy 
decision by the system administrator.

> 
> Ingo/Peter, any thoughts here?  CFS and smpnice probably is "broken" 
> with respect to such example as above albeit for nice-based tasks.
> 

See above.  I think that faced with cpu affinity use by the system 
administrator that smpnice will tend towards a task to cpu allocation 
that is (close to) the best that can be achieved without violating the 
cpu affinity assignments.  (It may take a little longer than normal but 
it should get there eventually.)

You have to assume that the system administrator knows what (s)he's 
doing and is willing to accept the impact of their policy decision on 
the overall system performance.

Having said that, if it was deemed necessary you could probably increase 
the speed at which the load balancer converged on a good result in the 
face of cpu affinity by keeping a "pinned weighted load" value for each 
run queue and using that to modify find_busiest_group() and 
find_busiest_queue() to be a bit smarter.   But I'm not sure that it 
would be worth the added complexity.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
