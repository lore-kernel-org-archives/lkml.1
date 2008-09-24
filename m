Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbYIXPTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbYIXPTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 11:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYIXPTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 11:19:39 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:55256 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYIXPTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 11:19:39 -0400
Message-ID: <48DA5A84.8030704@nortel.com>
Date: Wed, 24 Sep 2008 09:19:32 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: unpredictability in scheduler test results -- still present
References: <48D2DA0D.4060300@nortel.com>
In-Reply-To: <48D2DA0D.4060300@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2008 15:19:33.0962 (UTC) FILETIME=[F3007AA0:01C91E58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:

> I'm using the test config listed at the bottom.  It's pretty 
> straightforward.

> On the second run, the task distribution is almost perfect, but the 
> system was only using one of the two cpus as seen by the difference 
> between actual and expected cpu time.
> 
> Warning, actual cpu time different than expected. actual: 10033.011108, 
> expected: 20000.000000
> group       actual(%)     expected(%)  avg latency(ms) max_latency(ms)
>      1   0.24(30.59/29.88)    30.00      26/27             68/58
>      2       39.87            40.00       20                36
>      3   29.89(29.87/29.91)   30.00      28/27             47/60

This behaviour (that load balancing is messed up) is now almost 
continuous with both current tip/master and current Linus git.  On the 
first test after booting, it seems to work okay (although there are 
still issues with fairness).  On every subsequent test, fairness is good 
but it only uses one of the two cpus.

Also, building a kernel with "-j10" results in one cpu being mostly idle 
while the other one is 100% busy. It used to be both 100% busy--if I get 
time today I may try bisecting it.

Chris
