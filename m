Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbZHQJf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbZHQJf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932417AbZHQJf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:35:58 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:59091 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383AbZHQJf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:35:58 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perf_counter: Check task on counter read IPI
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <19081.8782.92022.727631@cargo.ozlabs.ibm.com>
References: <19076.63614.277861.368125@drongo.ozlabs.ibm.com>
	 <1250497016.5241.1675.camel@twins>
	 <19081.8782.92022.727631@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 11:35:23 +0200
Message-Id: <1250501723.5241.1709.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 19:26 +1000, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > > I don't have an example of an actual failure due to this race, but it
> > > seems obvious that it could occur and we need to guard against it, so
> > > I think this should go in .31.
> > 
> > Hmm, right.
> > 
> > However those other sites have retry loops in the caller, but callers of
> > __perf_counter_read() do not. Granted, I'm not sure what they should
> > retry on exactly, but this patch trades an invalid update to a missing
> > update.
> 
> It relies on the counter sched-out updating ->count for all the
> counters on the task.  We know that the sched-out happened very
> recently, i.e. in the interval between deciding to send the IPI and
> the IPI arriving.  So the counter value should be sufficiently up to
> date.  Ingo pointed this out to me some time ago.
> 
> I tried to address that in the comments and the patch description but
> perhaps I wasn't explicit enough.

Or its still early and I hadn't had my morning juice yet..

Yes, you're right, in case we missed it due to a race with schedule, the
schedule action itself will have indeed updated the count and we're good
again.

So sorry for the confusion,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

