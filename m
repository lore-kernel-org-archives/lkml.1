Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbZIYBXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbZIYBXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 21:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZIYBXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 21:23:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53038 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbZIYBXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 21:23:22 -0400
Message-ID: <4ABC1B55.3020108@cn.fujitsu.com>
Date: Fri, 25 Sep 2009 09:22:29 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf_counter: cleanup for __perf_event_sched_*()
References: <4AB88F06.10900@cn.fujitsu.com>	 <19128.39768.149110.673711@cargo.ozlabs.ibm.com>	 <4AB98BB0.6020202@cn.fujitsu.com>	 <19129.38627.94363.857137@cargo.ozlabs.ibm.com>	 <4AB9D7FA.5040707@cn.fujitsu.com> <1253695230.7695.122.camel@twins>
In-Reply-To: <1253695230.7695.122.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:

> 
> Hrm.. I think its not just a cleanup, but an actual bugfix.
> 
> The intent was to call event_sched_{in,out}() for single counter groups
> because that's cheaper than group_sched_{in,out}(), however..
> 
>  - as you noticed, I got the condition wrong, it should have read:
> 
>      list_empty(&event->sibling_list)
> 
>  - it failed to call group_can_go_on() which deals with ->exclusive.
> 
>  - it also doesn't call hw_perf_group_sched_in() which might break
>    power.
> 

Yeah, I'll fix the title

> Also, I'm not sure I like the comments and WARN_ON bits, the changelog
> should be sufficient.
> 

Um, I'll remove the comments and WARN_ON_ONCE()

Thanks,
Xiao
