Return-Path: <linux-kernel-owner+w=401wt.eu-S1764092AbYCDSCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764092AbYCDSCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbYCDSCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:02:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:26081 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487AbYCDSCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:02:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,444,1199692800"; 
   d="scan'208";a="214775402"
Date: Tue, 4 Mar 2008 09:59:10 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v3
Message-ID: <20080304175909.GE28006@linux-os.sc.intel.com>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080304102804.GA17681@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304102804.GA17681@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 11:28:04AM +0100, Ingo Molnar wrote:
> 
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > Split the FPU save area from the task struct. This allows easy 
> > migration of FPU context, and it's generally cleaner. It also allows 
> > the following two optimizations:
> 
> hm, i didnt get a reply from you to:
> 
>     http://lkml.org/lkml/2008/3/3/47
> 
> I'm uneasy to apply patches without knowing whether previous problems 
> are fixed. In the changelog there's a mention of:
> 
>   v3: Fixed the non-atomic calling sequence in atomic context.
> 
> is that the same bug?

Yes. Sorry for not pointing out explicitly. Essentially 32bit kernel with
CONFIG_PREEMPT is calling math_state_restore() with interrupts disabled.
Handled this by enabling/disabling the interrupts around the blocking call.
with small code changes ensuring that it is safe to enable/disable interrupts
at this point.

Do you want a v4 or separate patch for handling the kmem_cache_alloc() failure

thanks,
suresh
