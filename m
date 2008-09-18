Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbYIRWpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbYIRWpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 18:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbYIRWpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 18:45:42 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:47318 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbYIRWpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 18:45:41 -0400
Message-ID: <48D2DA0D.4060300@nortel.com>
Date: Thu, 18 Sep 2008 16:45:33 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: unpredictability in scheduler test results
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Sep 2008 22:45:37.0400 (UTC) FILETIME=[44C68780:01C919E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was running some tests with the "fairtest" testcase and noticed that 
successive runs could give wildly different results.

I was originally using the tip/master tree as of Sep 16, but I also 
confirmed the behaviour with Linus' tree as of Sep 14 (with the 
__load_balance_iterator() fix applied).  The same behaviour is present 
in both cases.

I'm using the test config listed at the bottom.  It's pretty 
straightforward.

The first run gave the following results.  As expected, the system 
picked a static task distribution and didn't migrate tasks during the test.

group       actual(%)     expected(%)  avg latency(ms) max_latency(ms)
     1   33.31(33.33/33.2    30.00      23/23            37/37
     2        36.29          40.00       5               25
     3   30.40(27.40/33.40)  30.00      22/23            60/40



On the second run, the task distribution is almost perfect, but the 
system was only using one of the two cpus as seen by the difference 
between actual and expected cpu time.

Warning, actual cpu time different than expected. actual: 10033.011108, 
expected: 20000.000000
group       actual(%)     expected(%)  avg latency(ms) max_latency(ms)
     1   0.24(30.59/29.88)    30.00      26/27             68/58
     2       39.87            40.00       20                36
     3   29.89(29.87/29.91)   30.00      28/27             47/60


Any ideas what's going on?

Chris



test config file:
#delay (secs)
1

#duration (secs)
10

#groupname,share,numhogs
1,750,n
2,1000,1
3,750,n


