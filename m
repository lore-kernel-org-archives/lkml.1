Return-Path: <linux-kernel-owner+w=401wt.eu-S932338AbZHQJ0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbZHQJ0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932284AbZHQJ0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:26:42 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:34703 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbZHQJ0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:26:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19081.8782.92022.727631@cargo.ozlabs.ibm.com>
Date: Mon, 17 Aug 2009 19:26:38 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: Check task on counter read IPI
In-Reply-To: <1250497016.5241.1675.camel@twins>
References: <19076.63614.277861.368125@drongo.ozlabs.ibm.com>
	<1250497016.5241.1675.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> > I don't have an example of an actual failure due to this race, but it
> > seems obvious that it could occur and we need to guard against it, so
> > I think this should go in .31.
> 
> Hmm, right.
> 
> However those other sites have retry loops in the caller, but callers of
> __perf_counter_read() do not. Granted, I'm not sure what they should
> retry on exactly, but this patch trades an invalid update to a missing
> update.

It relies on the counter sched-out updating ->count for all the
counters on the task.  We know that the sched-out happened very
recently, i.e. in the interval between deciding to send the IPI and
the IPI arriving.  So the counter value should be sufficiently up to
date.  Ingo pointed this out to me some time ago.

I tried to address that in the comments and the patch description but
perhaps I wasn't explicit enough.

Paul.
