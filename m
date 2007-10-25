Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbXJYXNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbXJYXNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXJYXND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:13:03 -0400
Received: from waste.org ([66.93.16.53]:36082 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbXJYXNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:13:01 -0400
Date: Thu, 25 Oct 2007 18:12:38 -0500
From: Matt Mackall <mpm@selenic.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Jon Smirl <jonsmirl@yahoo.com>
Subject: Re: IRQ off latency of printk is very high
Message-ID: <20071025231237.GT19691@waste.org>
References: <4720F21F.9090404@am.sony.com> <20071025222804.GA13954@Krystal> <47211E2C.90301@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47211E2C.90301@am.sony.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 03:52:28PM -0700, Tim Bird wrote:
> Mathieu Desnoyers wrote:
> > It might help to read this thread I posted on LKML in January 2006
> > explaining the problem, which led to some discussion about the issue.
> > 
> > http://lkml.org/lkml/2006/6/3/48
> 
> This is very helpful.  Jon Smirl's answer seems to give the
> rationale for supporting printk output in interrupt context.
> I'm not sure, however, if extending the interrupt off period
> to cover the console output is required.  It didn't until
> Ingo changed it in 2.6.17.

Hmm, I see this at the beginning of the post-BK era (2.6.12-rc2):

	        spin_lock_irqsave(&logbuf_lock, flags);
		...
		spin_unlock(&logbuf_lock);
		call_console_drivers(_con_start, _log_end);
		local_irq_restore(flags);

-- 
Mathematics is the supreme nostalgia of our time.
