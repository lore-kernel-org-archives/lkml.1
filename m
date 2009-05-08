Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbZEHMO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbZEHMO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZEHMOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:14:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:27530 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbZEHMOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:14:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,317,1239001200"; 
   d="scan'208";a="513736786"
Date: Fri, 8 May 2009 20:14:48 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86 MCE: shut up lockdep warning
Message-ID: <20090508121448.GA1807@sli10-desk.sh.intel.com>
References: <1241754429.4444.12.camel@sli10-desk.sh.intel.com> <20090508064517.GX23223@one.firstfloor.org> <20090508091015.GA2038@elte.hu> <20090508093757.GY23223@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508093757.GY23223@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 05:37:57PM +0800, Andi Kleen wrote:
> >  - it works around a lockdep warning
> > 
> >  - you did not realize the real bug while the warning was plain
> 
> Well I'm not sure you understood it either :)  Actually I'm pretty
> sure you did not. It would have been good if you had awaited proper
> review comments before commiting your patch.
> 
> I don't think here's really a real bug because cpu hotunplug is single threaded
> anyways (cpu add remove lock) and we don't do multiple discoveries in parallel.
> 
> The reason the lock is there is only during bringup with multiple CPUs
> doing this in parallel on initial bootup. But we can't race against cpu 
> hotunplug there because there's not hotunplug before the system
> is up with all configured CPUs.
> 
> So I think any way of shutting up lockdep is fine here and your
> patch is overkill and disables interrupts unnecessarily. 
yes, this isn't a real bug, but just a false warning from lockdep. It's
my fault I didn't point this out first.

> >  - plus the patch introduces a fragile (because complex)
> >    work_on_cpu() call into the CPU hotplug path, which could have 
> >    caused followup regressions.
> 
> That's a reasonable point,  but doesn't seem strong enough to
> do full irq disabling. A better fix would be to find some other
> way to shut off this lockdep warning for this case. Is there
> such a way?
I tried to assign a lockdep class to the mce lock, which is the usual
way to avoid lockdep warning, but it appears not working here.

Thanks,
Shaohua
