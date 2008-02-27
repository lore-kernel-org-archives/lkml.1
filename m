Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbYB0NH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbYB0NH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbYB0NHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:07:18 -0500
Received: from ns1.suse.de ([195.135.220.2]:37945 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbYB0NHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:07:17 -0500
Date: Wed, 27 Feb 2008 14:07:16 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc][patch] x86-64 new smp_call_function design
Message-ID: <20080227130716.GB1340@wotan.suse.de>
References: <20080227124217.GA1340@wotan.suse.de> <47C55FD2.8030809@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C55FD2.8030809@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 02:04:18PM +0100, Andi Kleen wrote:
> 
> > On a 2 socket, 8 core system, I see anywhere up to nearly 16x better
> > performance on a stress test. The common cases of call-all, and wait
> > are improved the least, however I think that if call-single and nowait
> > are turned into a high performance API, then new usages will pop up
> > (eg. I started this because I wanted to do "call single, nowait" calls
> > for migrating block IO completions back to submitting CPU; however I
> > am also interested in improving the "call all, wait" case for example
> > to improve vmalloc tlb flushing).
> 
> TLB flushing at least on x86-64 should be already well optimized on its
> own. I would be surprised if you could do much better.

*vmalloc* TLB flushing. 

void flush_tlb_all(void)
{
        on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
}

Of course we could use a new vector for it and speed it up a lot more,
but after my vmalloc improvements I think that would be a waste of a
vector at this point.

 
> > As far as I understand, calling a subset of online CPUs that is not all or
> > one, is used quite infrequently, so this might be OK.
> 
> With cpusets and isolation etc. it is the normal case.

Oh really? Coming from what callers?
