Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZHTO2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZHTO2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 10:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbZHTO2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 10:28:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbZHTO2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:28:43 -0400
Subject: Re: [PATCH] libata: use single threaded work queue
From: James Bottomley <James.Bottomley@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jens Axboe <jens.axboe@oracle.com>, Mark Lord <liml@rtr.ca>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A8D4603.3060900@kernel.org>
References: <20090819112554.GY12579@kernel.dk> <4A8BE932.5090300@garzik.org>
	 <20090819120458.GZ12579@kernel.dk> <4A8BECC2.2060607@rtr.ca>
	 <20090819122320.GA12579@kernel.dk> <1250720545.4810.37.camel@pasglop>
	 <4A8D45DF.8010307@gmail.com>  <4A8D4603.3060900@kernel.org>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 08:28:30 -0600
Message-Id: <1250778510.5533.6.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 21:48 +0900, Tejun Heo wrote:
> Tejun Heo wrote:
> > Yes, it addresses different aspect of the concurrency problem.  Might
> > be more suitable for ATA workqueues but definitely more costly to
> > convert to.  Argh...
>             ^ compared to Jens's lazy workqueue.

So there are two issues here.  One is ATAs need for execution in user
context that won't block other execution ... I really think that if
there's an existing pattern for this in the kernel, we should use it
rather than inventing our own.

The other is the question of whether the workqueue concept itself is
flawed.  This business of some jobs blocking other jobs due to execution
order on the queue can be a nasty side effect and it can lead to
entangled deadlocks, but for some uses, the whole concept of queued jobs
following a set order is necessary.  It might be appropriate to think
about whether we want to convert the whole workqueue infrastructure to
something like slow_work instead and possibly think about ordering on
top of this.

James


