Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYKRP7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYKRP7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbYKRP71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:59:27 -0500
Received: from flusers.ccur.com ([12.192.68.2]:29288 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753051AbYKRP70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:59:26 -0500
X-Greylist: delayed 3805 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Nov 2008 10:59:26 EST
Date: Tue, 18 Nov 2008 09:55:40 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Support always running TSC on Intel CPUs
Message-ID: <20081118145540.GA32082@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20081118001137.GA12350@linux-os.sc.intel.com> <20081118080952.GE17838@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118080952.GE17838@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 09:09:52AM +0100, Ingo Molnar wrote:
> 
> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> 
> > +	if (c->x86_power & (1 << 8)) {
> >  		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
> > +		set_cpu_cap(c, X86_FEATURE_NOSTOP_TSC);
> > +	}
> 
> hm, the naming is a bit confusing. We now have 3 variants:
> 
>   X86_FEATURE_TSC
>   X86_FEATURE_CONSTANT_TSC
>   X86_FEATURE_NOSTOP_TSC
> 
> NOSTOP_TSC is basically what CONSTANT_TSC should have been to begin 
> with ;-)
> 
> i'd suggest to rename it to this:
> 
>   X86_FEATURE_TSC
>   X86_FEATURE_CONSTANT_FREQ_TSC
>   X86_FEATURE_STABLE_TSC
> 
> ... with CONSTANT_FREQ_TSC not having any real role in the long run. 
> (it's similarly problematic to a completely unstable TSC)
> 
> does this sound ok?


To me, the new naming has the same head-scratching potential
as the old....

How about:

	X86_FEATURE_TSC
	X86_FEATURE_STABLE_TSC_OBSOLETE
	X86_FEATURE_STABLE_TSC

Joe
