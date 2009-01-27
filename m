Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZA0DOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZA0DOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 22:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZA0DOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 22:14:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44260 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbZA0DOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 22:14:14 -0500
Date: Tue, 27 Jan 2009 03:07:27 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090127030727.GA15101@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Steven Rostedt <rostedt@goodmis.org>
References: <20090127001708.GA4815@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127001708.GA4815@nowhere>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 01:17:11AM +0100, Frederic Weisbecker wrote:
> For several reasons:
> _ Unneeded built drivers for my system that create workqueue(s) when they init
> _ Services which need their own workqueue, for several reasons, but who receive
>   very rare jobs (often never)

> I hadn't any problems until now with this patch but I think it needs more testing,
> like with cpu hotplug, and some renaming for its functions and structures...
> And I would like to receive some comments and feelings before continuing. So this
> is just an RFC :-)

Make sure this optimisation also works when the system's running low on memory
if workqueues are involved in "making forward progress".  Doubtless there
are other reasons for apparently-unused workqueues too.

How about reviewing each particular workqueue that you've identified to see if
it can be created later or even not at all, or destroyed while it's not being
used, or if some workqueues can be shared - rather than presuming that a change
like this would be safe globally?

Alasdair
-- 
agk@redhat.com
