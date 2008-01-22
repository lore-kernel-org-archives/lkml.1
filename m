Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbYAVNNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbYAVNNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 08:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYAVNNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 08:13:08 -0500
Received: from www.tglx.de ([62.245.132.106]:41737 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbYAVNNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 08:13:06 -0500
Date: Tue, 22 Jan 2008 14:12:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr patch
 series v3)
In-Reply-To: <200801211813.45102.ak@suse.de>
Message-ID: <alpine.LFD.1.00.0801221119180.3199@apollo.tec.linutronix.de>
References: <200801161114.239449000@suse.de> <200801181819.58675.ak@suse.de> <20080121164052.GA11364@elte.hu> <200801211813.45102.ak@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2008, Andi Kleen wrote:
> > It's a first shot so it might not yet be perfect - although so far it 
> > looks good in testing on 4-5 testsystems here, on mixed 64-bit and 
> > 32-bit boxes. Doing it this way was a pretty straightforward process, it 
> > took less than an hour - and the end result feels much better in terms 
> > of maintainability.
> 
> You still kept Venki's redundant 32bit reference count change for 32bit.
> The code handled that already by doing reserved bits check.

Hmm. Which patch are you referring to ? There is no patch from Venki
in x86.git which touches the pageattr code.

> IMHO it would have been cleaner to also do that for the 64bit version
> instead of abusing the reference counting for this (like my
> "CPA Handle 4K split pages at boot on 64bit" patch did). 

I don't understand what you mean. The "CPA Handle 4K split pages at
boot on 64bit" patch is in x86.git:

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commit;h=360b371f73b96c400c6a8fc19ea334d083c65c92

Please clarify.

> > I left the clflush feature bits out for now - fixes and cleanups go 
> > first. We first need to see whether this is robust enough before making 
> > other changes to c_p_a(). There's enough on the arch/x86 plate for 
> > v2.6.25 already - we can try the clflush optimizations in v2.6.26. 
> > (since there's no high-freq in-kernel user of the c_p_a() API at the 
> > moment, there's no pressing need for this either.)
> 
> Ok I'll redo it. Thank you for your support.
> 
> Probably in larger chunks now though -- with your somewhat
> random patching applying methology larger small grained series are just too 
> painful for me.

Please keep them fine-grained and keep fixes separate and prior to
features.

> First priority will be gbpages on top of it.

First priority is getting CPA and PAT consolidated before we put new
functionality on top of it. This implies a possible unification of the
32 and 64 bit code as well. There is no real good reason to have
different implementations for those.

> I would appreciate if you could either prevent or warn against further
> wide scale changes on these files before .26 then -- otherwise I'll have
> again play catch up with a relatively large patchkit.

FYI, the consolidation of CPA and PAT is changing that code, so flux
is expected.

Thanks,
	tglx
