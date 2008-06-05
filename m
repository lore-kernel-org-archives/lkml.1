Return-Path: <linux-kernel-owner+w=401wt.eu-S1761180AbYFES4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761180AbYFES4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYFES4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:56:43 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:36364 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYFES4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:56:42 -0400
Message-ID: <484836E7.2060003@ct.jp.nec.com>
Date: Thu, 05 Jun 2008 11:56:39 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] per-task-delay-accounting: add memory reclaim delay
References: <20080604115917.9408.KOSAKI.MOTOHIRO@jp.fujitsu.com> <4846D632.4030803@ct.jp.nec.com> <20080605092451.9C1D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080605092451.9C1D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>>>> +	delayacct_freepages_start();
>>>>  	did_some_progress = try_to_free_pages(zonelist, order, gfp_mask);
>>>> +	delayacct_freepages_end();
>>> Shouldn't we consider memcgroup reclaim?
>> thanks for pointing this.
>> Unfortunately, we're not so familiar to memcgroup.
>> Will look into this.
>> Could you tell us pointers to memcgroup?
> 
> Documentation/controllers/memory.txt is good guide :)

thanks, and playing with this is good too.
I see it's easy to use this feature :)

> 
> <abstract>
> try_to_free_pages():	         global reclaim entry point
> try_to_free_mem_cgroup_pages():  memcgroup reclaim entry point
> do_try_to_free_pages():	         common layer

I see the point that, on memcgroup enabled system, there are
memcgroup memory reclaim points and try_to_free_mem_cgroup_pages()
is called when the page charge reach the limit.
So if we want to account delay for memory reclaim, we should
account at both of try_to_free_pages() and try_to_free_mem_cgroup_pages().
Accounting at do_try_to_free_pages() covers this case.

> Unfortunately, I don't know your requirement and
> memcgroup reclaim shold be mesured.
> I hope you explain your purpose and benefit more.

Ah, sure.
We have an issue that a process which accesses a DB sometime slows down.
We want to know what causes it, without the reproducer.
We have only the report of the problem, memory usage, vmstat...
And, I don't know the memory reclaim really causes the problem.

If we can see what kind of delay is the matter in the test bed, it will
help us to take a next action.

Thanks,
Hiroshi Shimamoto

