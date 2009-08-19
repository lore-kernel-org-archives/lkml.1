Return-Path: <linux-kernel-owner+w=401wt.eu-S1751880AbZHSHuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbZHSHuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZHSHue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:50:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbZHSHue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:50:34 -0400
Date: Wed, 19 Aug 2009 09:50:34 +0200
From: Nick Piggin <npiggin@suse.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: Rendezvous all the cpu's for MTRR/PAT init
Message-ID: <20090819075034.GD30325@wotan.suse.de>
References: <1250641835.2744.56.camel@sbs-t61.sc.intel.com> <20090818180107.29d3f39b.akpm@linux-foundation.org> <1250662857.2615.42.camel@sbs-t61>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250662857.2615.42.camel@sbs-t61>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 11:20:57PM -0700, Suresh B wrote:
> To make it clean I can move the smp_store_cpu_info() call before
> local_irq_disable() in smp_callin(). But that needs more changes (for
> xen etc). So thinking more, I think it is safe to do smp_call_function()
> with interrupts disabled as the caller is currently not in the
> cpu_online_mask.
> 
> i.e., no one else sends smp_call_function interrupt to this AP who is
> doing smp_call_function() with interrupts disabled and as such there
> won't be any deadlocks typically associated with calling
> smp_call_function() with interrupts disabled. Copied Nick to confirm or
> correct my understanding.
> 
> New patch appended removes this irq enable/disable sequence around
> mtrr_ap_init() and add's a cpu_online() check in smp_call_function
> warn-on's.

Yes this seems like a fine idea to me. Maybe also add a
WARN_ON(cpu_online) in the interrupt-side as well just to
make it clear.

If you split the patch out with its own changelog and give
a comment for the special case, then you can add an
Acked-by: Nick Piggin <npiggin@suse.de>

Although until you get acks from all arch maintainers, the
functionality would have to only be used on a per-arch basis
but that's probably OK as it's a pretty tricky thing for
generic code to be doing :)


