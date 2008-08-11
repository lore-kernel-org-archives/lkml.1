Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbYHKEet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbYHKEet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 00:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbYHKEel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 00:34:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:56174 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYHKEel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 00:34:41 -0400
Date: Sun, 10 Aug 2008 21:34:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       npiggin@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com
Subject: Re: [PATCH] stack and rcu interaction bug in
 smp_call_function_mask()
Message-ID: <20080810213421.70f61034@infradead.org>
In-Reply-To: <489FBF6A.40402@goop.org>
References: <20080808193753.GA21964@linux-os.sc.intel.com>
	<200808101624.15112.nickpiggin@yahoo.com.au>
	<489FBF6A.40402@goop.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008 21:26:18 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Nick Piggin wrote:
> > Nice debugging work.
> >
> > I'd suggest something like the attached (untested) patch as the
> > simple fix for now.
> >
> > I expect the benefits from the less synchronized,
> > multiple-in-flight-data global queue will still outweigh the costs
> > of dynamic allocations. But if worst comes to worst then we just go
> > back to a globally synchronous one-at-a-time implementation, but
> > that would be pretty sad! 
> 
> What if we went the other way and strictly used queue-per-cpu?  It
> means multicast would require multiple enqueueing operations, which
> is a bit heavy, but it does make dequeuing and lifetime management
> very simple...

as long as send-to-all is still one apic operation.. otherwise it gets
*really* expensive....
(just think about waking all cpus up out of their C-states.. one by one
getting the full exit latency sequentially)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
