Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbXJ2UIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbXJ2UIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbXJ2UIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:08:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:35130 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbXJ2UIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:08:41 -0400
Subject: Re: [PATCH, RFC] hacks to allow -rt to run kernbench on POWER
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, tony@bakeyournoodle.com, paulus@samba.org,
       dino@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com, antonb@us.ibm.com,
       rostedt@goodmis.org
In-Reply-To: <20071029185044.GA23413@linux.vnet.ibm.com>
References: <20071029185044.GA23413@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 07:07:48 +1100
Message-Id: <1193688468.9928.30.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-29 at 11:50 -0700, Paul E. McKenney wrote:
> Hello!
> 
> A few random patches that permit POWER to pass kernbench on -rt.
> Many of these have more focus on expediency than care for correctness,
> so might best be thought of as workarounds than as complete solutions.
> There are still issues not addressed by this patch, including:
> 
> o	kmem_cache_alloc() from non-preemptible context during
> 	bootup (xics_startup() building the irq_radix_revmap()).
> 
> o	unmap_vmas() freeing pages with preemption disabled.
> 	Might be able to address this by linking the pages together,
> 	then freeing them en masse after preemption has been re-enabled,
> 	but there is likely a better approach.
> 
> Thoughts?

I see a lot of case where you add preempt_disable/enable around areas
that have the PTE lock held...

So in -rt, spin_lock doesn't disable preempt ? I'm a bit worried...
there are some strong requirements that anything within that lock is not
preempted, so zap_pte_ranges() is the obvious ones but all of them would
need to be addressed.

Ben.


