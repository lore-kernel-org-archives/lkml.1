Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbZIVJjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbZIVJjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 05:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZIVJji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 05:39:38 -0400
Received: from ozlabs.org ([203.10.76.45]:34125 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbZIVJji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:39:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19128.39768.149110.673711@cargo.ozlabs.ibm.com>
Date: Tue, 22 Sep 2009 19:39:36 +1000
From: Paul Mackerras <paulus@samba.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: cleanup for __perf_event_sched_in()
In-Reply-To: <4AB88F06.10900@cn.fujitsu.com>
References: <4AB88F06.10900@cn.fujitsu.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong writes:

> It must be a group leader if event->attr.pinned is "1"

Actually, looking at this more closely, it has to be a group leader
anyway since it's at the top level of ctx->group_list.  In fact I see
four places where we do:

		list_for_each_entry(event, &ctx->group_list, group_entry) {
			if (event == event->group_leader)
				...

or the equivalent, three of which appear to have been introduced by
afedadf2 ("perf_counter: Optimize sched in/out of counters") back in
May by Peter Z.

As far as I can see the if () is superfluous in each case (a singleton
event will be a group of 1 and will have its group_leader pointing to
itself).  Peter, do you agree or have I missed something?

Paul.
