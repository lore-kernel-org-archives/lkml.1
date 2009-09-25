Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZIYIzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZIYIzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbZIYIzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:55:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZIYIzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:55:00 -0400
Subject: Re: [PATCH 1/2 v2] perf_counter: fix for __perf_event_sched_*()
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4ABC5A55.7000208@cn.fujitsu.com>
References: <4AB88F06.10900@cn.fujitsu.com>
	 <19128.39768.149110.673711@cargo.ozlabs.ibm.com>
	 <4AB98BB0.6020202@cn.fujitsu.com>
	 <19129.38627.94363.857137@cargo.ozlabs.ibm.com>
	 <4AB9D7FA.5040707@cn.fujitsu.com> <1253695230.7695.122.camel@twins>
	 <4ABC5A55.7000208@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Sep 2009 10:55:37 +0200
Message-Id: <1253868937.10287.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 13:51 +0800, Xiao Guangrong wrote:
> Paul Mackerras says:
> "Actually, looking at this more closely, it has to be a group leader
> anyway since it's at the top level of ctx->group_list.  In fact I see
> four places where we do:
> 
>   list_for_each_entry(event, &ctx->group_list, group_entry) {
> 	if (event == event->group_leader)
> 		...
> 
> or the equivalent, three of which appear to have been introduced by
> afedadf2 ("perf_counter: Optimize sched in/out of counters") back in
> May by Peter Z.
> 
> As far as I can see the if () is superfluous in each case (a singleton
> event will be a group of 1 and will have its group_leader pointing to
> itself)."
> [Can be found at http://marc.info/?l=linux-kernel&m=125361238901442&w=2]
> 
> And Peter Zijlstra point out this is an bugfix:
> "The intent was to call event_sched_{in,out}() for single counter groups
> because that's cheaper than group_sched_{in,out}(), however..
> 
>  - as you noticed, I got the condition wrong, it should have read:
> 
>      list_empty(&event->sibling_list)
> 
>  - it failed to call group_can_go_on() which deals with ->exclusive.
> 
>  - it also doesn't call hw_perf_group_sched_in() which might break
>    power."
> [Can be found at http://marc.info/?l=linux-kernel&m=125369523318583&w=2]
> 
> Changelog v1->v2:
> - fix the title name as Peter Zijlstra's suggestion
> - remove the comments and WARN_ON_ONCE() as Peter Zijlstra's suggestion
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Thanks,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
