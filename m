Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbZEYAfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbZEYAfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 20:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZEYAe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 20:34:57 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:57488 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbZEYAe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 20:34:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18969.58137.356360.144339@cargo.ozlabs.ibm.com>
Date: Mon, 25 May 2009 10:15:21 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
 identical inherited contexts
In-Reply-To: <1243000016.6582.574.camel@laptop>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	<18966.10666.517218.332164@cargo.ozlabs.ibm.com>
	<1243000016.6582.574.camel@laptop>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Ingo just pointed out that there is nothing there to close the race with
> attaching a counter.
> 
> That is, you could end up attaching your counter to the wrong task.

Good point.  Doing the unclone in find_get_context would be a start,
but the locking could get tricky (in fact we don't have any way to
remove an inherited counter from a context, so we only have to worry
about counters being attached).  I'll work out a solution after I have
digested your recent batch of patches.

Paul.
