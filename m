Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbYHZTGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbYHZTGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758966AbYHZTGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:06:21 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33570 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758684AbYHZTGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:06:20 -0400
Message-ID: <48B4542A.1050004@sgi.com>
Date: Tue, 26 Aug 2008 12:06:18 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, torvalds@linux-foundation.org, Alan.Brunelle@hp.com,
       tglx@linutronix.de, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, rusty@rustcorp.com.au
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org>	<alpine.LFD.1.10.0808251401590.3363@nehalem.linux-foundation.org>	<20080826072220.GB31876@elte.hu> <20080826.004607.253712060.davem@davemloft.net>
In-Reply-To: <20080826.004607.253712060.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 26 Aug 2008 09:22:20 +0200
> 
>> And i guess the next generation of 4K CPUs support should just get away 
>> from cpumask_t-on-kernel-stack model altogether, as the current model is 
>> not maintainable. We tried the on-kernel-stack variant, and it really 
>> does not work reliably. We can fix this in v2.6.28.
> 
> I recently did some work on sparc64 to use cpumask pointers
> as much as possible.
> 
> The only case that didn't work was due to a limitation in
> arch interfaces for the new generic smp_call_function() code.
> It passes a cpumask_t instead of a pointer to one via
> arch_send_call_function_ipi().
> 
> But other than that, the whole sparc64 SMP stuff uses cpumask_t
> pointers only.
> 
> What it comes down to is that you have to do the "self cpu"
> and other tests in the cross-call dispatch routines themselves,
> instead of at the top-level working on cpumask_t objects.
> 
> Otherwise you have to modify cpumask_t objects and thus pluck
> them onto the stack where they take up silly amounts of space.

Yes, I had proposed either modifying, or supplementing a new
smp_call function to pass the cpumask_t as a pointer (similar
to set_cpus_allowed_ptr.)  But an ABI change such as this was
not well received at the time.

Thanks,
Mike
