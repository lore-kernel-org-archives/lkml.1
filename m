Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZBIXwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZBIXwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZBIXwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:52:41 -0500
Received: from relay3.sgi.com ([192.48.171.31]:45598 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752925AbZBIXwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:52:40 -0500
Date: Mon, 9 Feb 2009 17:52:33 -0600
From: Russ Anderson <rja@sgi.com>
To: Alex Chiang <achiang@hp.com>, tony.luck@intel.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, stable@kernel.org,
       linux-ia64@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Cc: rja@sgi.com
Subject: Re: [PATCH v2 1/2] Revert "[IA64] prevent ia64 from invoking irq handlers on offline CPUs"
Message-ID: <20090209235233.GA6235@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20090209181338.GD19064@ldl.fc.hp.com> <20090209181616.GE19064@ldl.fc.hp.com> <20090209211743.GA3939@ldl.fc.hp.com> <20090209233324.GE3939@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209233324.GE3939@ldl.fc.hp.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 04:33:24PM -0700, Alex Chiang wrote:
> 
> I'm a little closer to understanding why the original revert
> survives my test though.
> 
> It seems that during ia64_process_pending_intr(), we will skip
> TLB flushes, and IPI reschedules.
> 
> Vectors lower than IA64_TIMER_VECTOR are masked (because we raise
> the TPR), meaning we won't see CMC/CPE interrupts or perfmon
> interrupts.
> 
> This leaves only IPIs and MCA above IA64_TIMER_VECTOR. The kernel
> doesn't actually send many IPIs to itself, so in practice, we
> almost never see those.  If we receive an MCA interrupt, well, we
> have more problems to worry about than taking a CPU offline (and
> whatever implications it may have on RCU). So I'm not concerned
> there.

Keep in mind there are recoverable MCAs on ia64.  It should
be a rare condition to have an MCA surface while taking a CPU
offline, but it could happen.

My main point is to make sure people do not assume that an MCA means
the system is going down.  

> The upshot is that in practice, we pretty much ever only need to
> handle the timer interrupt.

Thanks.
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
