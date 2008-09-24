Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbYIXXiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbYIXXiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYIXXiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:38:08 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:42043 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbYIXXiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:38:07 -0400
Message-ID: <48DACF55.3070209@nortel.com>
Date: Wed, 24 Sep 2008 17:37:57 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: unpredictability in scheduler test results -- still present
References: <48D2DA0D.4060300@nortel.com> <48DA5A84.8030704@nortel.com>
In-Reply-To: <48DA5A84.8030704@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2008 23:37:59.0509 (UTC) FILETIME=[9418D050:01C91E9E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:

> This behaviour (that load balancing is messed up) is now almost 
> continuous with both current tip/master and current Linus git.  On the 
> first test after booting, it seems to work okay (although there are 
> still issues with fairness).  On every subsequent test, fairness is good 
> but it only uses one of the two cpus.
> 
> Also, building a kernel with "-j10" results in one cpu being mostly idle 
> while the other one is 100% busy. It used to be both 100% busy--if I get 
> time today I may try bisecting it.

It turns out that disabling CONFIG_DYNAMIC_FTRACE makes the load 
balancing problem go away and causes all cpus to be used.

With this option enabled, the problem seems to be present as far back as 
2.6.27-rc2.  (2.6.27-rc1 doesn't compile on my machine, and 2.6.26 
doesn't have ftrace).

I have no idea why turning on dynamic ftrace would affect load balancing 
behaviour, but it's very repeatable.  The very first test run after 
booting works fine, and all successive runs fail to balance properly.

Chris
