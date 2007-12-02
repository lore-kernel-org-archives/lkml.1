Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbXLBUfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbXLBUfx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbXLBUfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:35:43 -0500
Received: from lazybastard.de ([212.112.238.170]:49316 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbXLBUfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:35:43 -0500
Date: Sun, 2 Dec 2007 21:30:16 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, Mark Lord <lkml@rtr.ca>,
       Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071202203016.GC10657@lazybastard.org>
References: <20071201204747.GA6458@lazybastard.org> <20071201205456.GA8231@elte.hu> <20071201234112.GA7209@lazybastard.org> <20071202085607.GA28966@elte.hu> <20071202113143.GA9378@lazybastard.org> <20071202135711.GA20434@elte.hu> <20071202141117.GB9516@lazybastard.org> <20071202154746.GA27069@elte.hu> <20071202195501.GB10657@lazybastard.org> <20071202200722.GA12101@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071202200722.GA12101@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 December 2007 21:07:22 +0100, Ingo Molnar wrote:
> * Jörn Engel <joern@logfs.org> wrote:
> 
> > Result looked like a livelock and finally convinced me to abandon the 
> > latency tracer.  Sorry, but it appears to be the right tool for the 
> > wrong job.
> 
> hm, we routinely use it in -rt to capture "what on earth is happening" 
> incidents. The snippet below is a random snipped from a trace that i've 
> just captured, with mcount enabled. It seems to work fine here, with and 
> without mcount. (pit clocksource is almost never used, that's why you 
> had those early problems.)
> 
> oprofile helps if you can reliably reproduce the slowdown in a loop or 
> for a long amount of time, with lots of CPU utilization - and then it's 
> also lower overhead. The tracer can be used to capture rare or complex 
> events, and gives the full flow control and what is happening within the 
> kernel.

Such a trace would be useful indeed.  But so far the patch has only
given me grief and nothing remotely like useful output.  Maybe I should
simply use the complete -rt patch instead of debugging the broken-out
latency-tracer patch.

Jörn

-- 
Mundie uses a textbook tactic of manipulation: start with some
reasonable talk, and lead the audience to an unreasonable conclusion.
-- Bruce Perens
