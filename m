Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbXI0J1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbXI0J1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 05:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbXI0J1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 05:27:44 -0400
Received: from mx2.go2.pl ([193.17.41.42]:58189 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753960AbXI0J1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 05:27:43 -0400
Date: Thu, 27 Sep 2007 11:30:02 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel\@Vger\. Kernel\. Org" <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20070927093002.GA2431@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926133138.GA23187@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26-09-2007 15:31, Ingo Molnar wrote:
> * David Schwartz <davids@webmaster.com> wrote:
> 
>>>> I think the real fix would be for iperf to use blocking network IO 
>>>> though, or maybe to use a POSIX mutex or POSIX semaphores.
>>> So it's definitely not a bug in the kernel, only in iperf?
>> Martin:
>>
>> Actually, in this case I think iperf is doing the right thing (though not
>> the best thing) and the kernel is doing the wrong thing. [...]
> 
> it's not doing the right thing at all. I had a quick look at the source 
> code, and the reason for that weird yield usage was that there's a 
> locking bug in iperf's "Reporter thread" abstraction and apparently 
> instead of fixing the bug it was worked around via a horrible yield() 
> based user-space lock.
> 
> the (small) patch below fixes the iperf locking bug and removes the 
> yield() use. There are numerous immediate benefits of this patch:
...
> 
> sched_yield() is almost always the symptom of broken locking or other 
> bug. In that sense CFS does the right thing by exposing such bugs =B-)

...Only if it were under some DEBUG option. Even if iperf is doing
the wrong thing there is no explanation for such big difference in
the behavior between sched_compat_yield 1 vs. 0. It seems common
interfaces should work similarly and predictably on various
systems, and here, if I didn't miss something, linux looks like a
different kind?

Regards,
Jarek P.
