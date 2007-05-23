Return-Path: <linux-kernel-owner+w=401wt.eu-S1765651AbXEWPBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765651AbXEWPBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbXEWPBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:01:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366AbXEWPBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:01:14 -0400
Date: Wed, 23 May 2007 10:40:59 -0400 (EDT)
From: Jason Baron <jbaron@redhat.com>
X-X-Sender: jbaron@dhcp83-20.boston.redhat.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] lockdep: lock contention tracking
In-Reply-To: <20070523095807.407148940@chello.nl>
Message-ID: <Pine.LNX.4.64.0705231035270.22023@dhcp83-20.boston.redhat.com>
References: <20070523072618.129001605@chello.nl> <20070523095807.407148940@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 23 May 2007, Peter Zijlstra wrote:

> Count lock contention events per lock class. Additionally track the first four
> callsites that resulted in the contention.
> 

I think that we need the total number of locking calls, not just the total 
number of *contended* locking calls, in order to make the data 
significant. Same for waittime. Yes, this pollutes the fastpath. In the 
contention case, its one extra addition, and for the waittime, its a call 
the sched_clock(). I don't think that's too much to pay for much more 
meaningful data.

thanks,

-Jason
