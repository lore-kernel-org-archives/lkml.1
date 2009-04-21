Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZDUWu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZDUWu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 18:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZDUWuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 18:50:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:52319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbZDUWuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 18:50:19 -0400
Date: Tue, 21 Apr 2009 22:49:51 +0000
From: Chris Wright <chrisw@sous-sol.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@linux.intel.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [patch] x64: fix FPU corruption with signals and
	preemption
Message-ID: <20090421224951.GD24073@hera.kernel.org>
References: <1239315874.27006.8026.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239315874.27006.8026.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 22:49:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha (suresh.b.siddha@intel.com) wrote:
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x64: fix FPU corruption with signals and preemption
> 
> Impact: fix FPU state corruption
> 
> In 64bit signal delivery path, clear_used_math() was happening before saving
> the current active FPU state on to the user stack for signal handling. Between
> clear_used_math() and the state store on to the user stack, potentially we
> can get a page fault for the user address and can block. Infact, while testing
> we were hitting the might_fault() in __clear_user() which can do a schedule().
> 
> At a later point in time, we will schedule back into this process and
> resume the save state (using "xsave/fxsave" instruction) which can lead
> to DNA fault. And as used_math was cleared before, we will reinit the FP state
> in the DNA fault and continue. This reinit will result in loosing the
> FPU state of the process.
> 
> Move clear_used_math() to a point after the FPU state has been stored
> onto the user stack.
> 
> This issue is present from a long time (even before the xsave changes
> and the x86 merge). But it can easily be exposed in 2.6.28.x and 2.6.29.x
> series because of the __clear_user() in this path, which has an explicit
> __cond_resched() leading to a context switch with CONFIG_PREEMPT_VOLUNTARY.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: stable@kernel.org			[2.6.28.x, 2.6.29.x]

This one get lost?

thanks,
-chris
