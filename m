Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbZEHJdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbZEHJdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbZEHJdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:33:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50029 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbZEHJdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:33:08 -0400
Date: Fri, 8 May 2009 11:37:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Shaohua Li <shaohua.li@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86 MCE: shut up lockdep warning
Message-ID: <20090508093757.GY23223@one.firstfloor.org>
References: <1241754429.4444.12.camel@sli10-desk.sh.intel.com> <20090508064517.GX23223@one.firstfloor.org> <20090508091015.GA2038@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508091015.GA2038@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - it works around a lockdep warning
> 
>  - you did not realize the real bug while the warning was plain

Well I'm not sure you understood it either :)  Actually I'm pretty
sure you did not. It would have been good if you had awaited proper
review comments before commiting your patch.

I don't think here's really a real bug because cpu hotunplug is single threaded
anyways (cpu add remove lock) and we don't do multiple discoveries in parallel.

The reason the lock is there is only during bringup with multiple CPUs
doing this in parallel on initial bootup. But we can't race against cpu 
hotunplug there because there's not hotunplug before the system
is up with all configured CPUs.

So I think any way of shutting up lockdep is fine here and your
patch is overkill and disables interrupts unnecessarily. 

>  - plus the patch introduces a fragile (because complex)
>    work_on_cpu() call into the CPU hotplug path, which could have 
>    caused followup regressions.

That's a reasonable point,  but doesn't seem strong enough to
do full irq disabling. A better fix would be to find some other
way to shut off this lockdep warning for this case. Is there
such a way?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
