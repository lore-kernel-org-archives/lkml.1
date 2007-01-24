Return-Path: <linux-kernel-owner+w=401wt.eu-S965453AbXAXAfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965453AbXAXAfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 19:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965454AbXAXAfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 19:35:19 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44422 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965453AbXAXAfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 19:35:18 -0500
Date: Tue, 23 Jan 2007 16:32:59 -0800
From: Andrew Morton <akpm@osdl.org>
To: dipankar@in.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [mm PATCH 4/6] RCU: preemptible RCU
Message-Id: <20070123163259.0d1d5ffc.akpm@osdl.org>
In-Reply-To: <20070115192858.GE32238@in.ibm.com>
References: <20070115191909.GA32238@in.ibm.com>
	<20070115192858.GE32238@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jan 2007 00:58:58 +0530
Dipankar Sarma <dipankar@in.ibm.com> wrote:

> This patch implements a new version of RCU which allows its read-side
> critical sections to be preempted.

Why is it selectable if CONFIG_PREEMPT=n?

> It uses a set of counter pairs
> to keep track of the read-side critical sections and flips them
> when all tasks exit read-side critical section. The details
> of this implementation can be found in this paper -
> 
> http://www.rdrop.com/users/paulmck/RCU/OLSrtRCU.2006.08.11a.pdf
> 
> This patch was developed as a part of the -rt kernel
> development and meant to provide better latencies when
> read-side critical sections of RCU don't disable preemption.

Does it succeed in that attempt?  Thus far you've given no reason for
merging this code..

This is a pile of tricky new core kernel code for us to test, maintain,
understand, debug, etc.  It needs to provide a substantial benefit.  Does
it?

> As a consequence of keeping track of RCU readers, the readers
> have a slight overhead (optimizations in the paper).
> This implementation co-exists with the "classic" RCU
> implementations and can be switched to at compiler.

That's yet another question we need to ask people when their kernel dies,
and yet another deviation between the kernels which we all test, causing
more dilution of testing efforts.  It would be much better if we could
remove classic RCU.  You say this would incur extra cost, but the magnitude
of that cost is not clear.  Please help us make that decision.


