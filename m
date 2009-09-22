Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbZIVLRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbZIVLRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbZIVLRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:17:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:48989 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZIVLRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:17:10 -0400
Subject: Re: [PATCH] perf_counter: cleanup for __perf_event_sched_in()
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <19128.39768.149110.673711@cargo.ozlabs.ibm.com>
References: <4AB88F06.10900@cn.fujitsu.com>
	 <19128.39768.149110.673711@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Sep 2009 13:17:10 +0200
Message-Id: <1253618230.7695.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 19:39 +1000, Paul Mackerras wrote:
> Xiao Guangrong writes:
> 
> > It must be a group leader if event->attr.pinned is "1"
> 
> Actually, looking at this more closely, it has to be a group leader
> anyway since it's at the top level of ctx->group_list.  In fact I see
> four places where we do:
> 
> 		list_for_each_entry(event, &ctx->group_list, group_entry) {
> 			if (event == event->group_leader)
> 				...
> 
> or the equivalent, three of which appear to have been introduced by
> afedadf2 ("perf_counter: Optimize sched in/out of counters") back in
> May by Peter Z.
> 
> As far as I can see the if () is superfluous in each case (a singleton
> event will be a group of 1 and will have its group_leader pointing to
> itself).  Peter, do you agree or have I missed something?

/me kicks those neurons back to work..

Ah, yes, I think you're right, the second hunk of afedadf2 is a
pessimisation due to the extra branch.


