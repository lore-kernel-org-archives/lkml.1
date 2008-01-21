Return-Path: <linux-kernel-owner+w=401wt.eu-S1752047AbYAURN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbYAURN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 12:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYAURNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 12:13:51 -0500
Received: from mx1.suse.de ([195.135.220.2]:59927 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbYAURNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 12:13:50 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr patch series v3)
Date: Mon, 21 Jan 2008 18:13:44 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jbeulich@novell.com,
       venkatesh.pallipadi@intel.com, "H. Peter Anvin" <hpa@zytor.com>
References: <200801161114.239449000@suse.de> <200801181819.58675.ak@suse.de> <20080121164052.GA11364@elte.hu>
In-Reply-To: <20080121164052.GA11364@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801211813.45102.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It's a first shot so it might not yet be perfect - although so far it 
> looks good in testing on 4-5 testsystems here, on mixed 64-bit and 
> 32-bit boxes. Doing it this way was a pretty straightforward process, it 
> took less than an hour - and the end result feels much better in terms 
> of maintainability.

You still kept Venki's redundant 32bit reference count change for 32bit.
The code handled that already by doing reserved bits check.

IMHO it would have been cleaner to also do that for the 64bit version
instead of abusing the reference counting for this (like my
"CPA Handle 4K split pages at boot on 64bit" patch did). 

> I left the clflush feature bits out for now - fixes and cleanups go 
> first. We first need to see whether this is robust enough before making 
> other changes to c_p_a(). There's enough on the arch/x86 plate for 
> v2.6.25 already - we can try the clflush optimizations in v2.6.26. 
> (since there's no high-freq in-kernel user of the c_p_a() API at the 
> moment, there's no pressing need for this either.)

Ok I'll redo it. Thank you for your support.

Probably in larger chunks now though -- with your somewhat
random patching applying methology larger small grained series are just too 
painful for me.

First priority will be gbpages on top of it.

I would appreciate if you could either prevent or warn against further
wide scale changes on these files before .26 then -- otherwise I'll have
again play catch up with a relatively large patchkit.

> Anyway, could you check today's x86.git and see whether any of those 
> fixes have some implicit dependency on other changes i left out of this 
> splitup? That's the main high-level risk i can see for now. (besides the 
> large number of changes to this fragile API)

They seem to be all independent from a quick look.

> Also, CPA_DEBUG still produces warnings all around the place - as it did 
> with your series.

Yes I'll do a patch later. I had wanted to fix it over the weekend, but
was fighting instead with all the other problems that were in git-x86 
at that time.

-Andi

