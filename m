Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbZE2LRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbZE2LRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 07:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbZE2LR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 07:17:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:48745 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbZE2LR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 07:17:27 -0400
Subject: Re: [PATCH RFC] perf_counter: Don't swap contexts containing
 locked mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <18975.50009.814331.113052@cargo.ozlabs.ibm.com>
References: <18975.31580.520676.619896@drongo.ozlabs.ibm.com>
	 <1243584388.23657.156.camel@twins> <1243584793.23657.168.camel@twins>
	 <1243585721.23657.177.camel@twins> <20090529085916.GA21461@elte.hu>
	 <20090529091608.GA15278@elte.hu>
	 <18975.50009.814331.113052@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 29 May 2009 13:17:30 +0200
Message-Id: <1243595850.23657.213.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 21:13 +1000, Paul Mackerras wrote:
> Ingo Molnar writes:
> 
> > looping in the remove-context retry loop.
> 
> Ah! We need to reload task inside the loop.  And possibly in other
> places.

Thing is, after your patch this is called after the unclone, so the
context should be stable, still we see this. But yeah that loop needs
some care.

I also noticed we have races on cpuctx->task_ctx, I was looking at
removing it alltogether in favour of current->perf_counter_ctxp.


