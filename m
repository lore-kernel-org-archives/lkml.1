Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbYDBIlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbYDBIlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 04:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYDBIlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 04:41:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53700 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbYDBIlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 04:41:44 -0400
Message-ID: <47F346A8.5000801@jp.fujitsu.com>
Date: Wed, 02 Apr 2008 17:41:12 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH 2/2] Customize sched domain via cpuset
References: <47F21C38.8090608@jp.fujitsu.com> <1207050712.8514.715.camel@twins>
In-Reply-To: <1207050712.8514.715.camel@twins>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-04-01 at 20:27 +0900, Hidetoshi Seto wrote:
>> The implementation is here.
>>
>>  - Add 2 new cpuset files:
>>      sched_wake_idle_far
>>      sched_balance_newidle_far
>>
>>  - Modify partition_sched_domains() and build_sched_domains()
>>    to take flags parameter passed from cpuset.
>>
>>  - Fill newidle_idx for node domains which currently unused but
>>    might be required for sched_balance_newidle_far.
> 
> Just to be clear; the same effect can be had by poking into:
> 
>  /proc/sys/kernel/sched_domain/$cpu/$domain/flags
> 
> but this interface you now propose gives a more stable interface in that
> you'd have to re-do your setting after every cpuset change (admittedly
> those are rare, but I see how it could be a nuisance).

And the sysctl entry "sched_domain" is not available unless SCHED_DEBUG.

So it is common sense that this sysctl is not open to public yet,
and that the expected users are scheduler developers, Ingo and friends.

> Or do you actually add something that wasn't available through the
> initial domain interface?

At this time I have no idea, but it would be possible if there are
something unreasonable on global system but acceptable on a part.

In other words, we can invent other sched_* families which has special
effect that "default scheduler" never have.

Thanks,
H.Seto
