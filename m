Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYI0UFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYI0UFA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 16:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYI0UEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 16:04:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38215 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbYI0UEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 16:04:52 -0400
Date: Sat, 27 Sep 2008 22:04:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: unpredictability in scheduler test results -- still present
Message-ID: <20080927200433.GC28937@elte.hu>
References: <48D2DA0D.4060300@nortel.com> <48DA5A84.8030704@nortel.com> <48DACF55.3070209@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DACF55.3070209@nortel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Friesen <cfriesen@nortel.com> wrote:

> Chris Friesen wrote:
>
>> This behaviour (that load balancing is messed up) is now almost  
>> continuous with both current tip/master and current Linus git.  On the  
>> first test after booting, it seems to work okay (although there are  
>> still issues with fairness).  On every subsequent test, fairness is 
>> good but it only uses one of the two cpus.
>>
>> Also, building a kernel with "-j10" results in one cpu being mostly 
>> idle while the other one is 100% busy. It used to be both 100% busy--if 
>> I get time today I may try bisecting it.
>
> It turns out that disabling CONFIG_DYNAMIC_FTRACE makes the load 
> balancing problem go away and causes all cpus to be used.
>
> With this option enabled, the problem seems to be present as far back 
> as 2.6.27-rc2.  (2.6.27-rc1 doesn't compile on my machine, and 2.6.26 
> doesn't have ftrace).
>
> I have no idea why turning on dynamic ftrace would affect load 
> balancing behaviour, but it's very repeatable.  The very first test 
> run after booting works fine, and all successive runs fail to balance 
> properly.

very weird. Would be very nice to figure it out.

and in tip/master we dont have the 'ftraced' kernel-patching kernel 
thread anymore, so ftrace should be passive by all means.

OTOH, what does 'truning on dftrace' exactly mean? Just enabling it in 
the .config, or also activating it via /debug/tracing/current_tracer?

	Ingo
