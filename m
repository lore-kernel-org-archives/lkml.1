Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab0BRSZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:25:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:50088 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab0BRSZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:25:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WNPHazep6ULhgENIbcp7No/Sw2IKZGZWCZ1NzefuVS9MNonbsn49qiDZ/qBugmoXxq
         1vPqJxzUeaGzDh61X1S0Gvi4fMkoSZxBtc+Yuz2c2mhREBZ104ja4LSPAR73ZuHn9X9G
         +QrBOE3NAXWQtHhcpFH5bX/GpETInYIGEgAi8=
Date: Thu, 18 Feb 2010 19:25:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH hw_breakpoint] percpu: add __percpu sparse annotations
	to hw_breakpoint
Message-ID: <20100218182515.GB5111@nowhere>
References: <4B7B4B7A.9050902@kernel.org> <20100217163944.GC5041@nowhere> <4B7C8E84.2030701@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7C8E84.2030701@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 09:49:08AM +0900, Tejun Heo wrote:
> Hello,
> 
> On 02/18/2010 01:39 AM, Frederic Weisbecker wrote:
> > On Wed, Feb 17, 2010 at 10:50:50AM +0900, Tejun Heo wrote:
> > Yeah, looks good, I'm queuing it.
> > Just few comments below, for nano-considerations.
> >>  	cpu_events = alloc_percpu(typeof(*cpu_events));
> >>  	if (!cpu_events)
> >> -		return ERR_PTR(-ENOMEM);
> >> +		return (void __percpu __force *)ERR_PTR(-ENOMEM);
> > 
> > Is this pattern common enough that we can think about a ERR_CPU_PTR ?
> 
> I thought about that but there aren't too many yet, so I just added
> the ugly castings.  It would be cool if sparse can be taught that
> ERR_PTR() returns universal pseudo pointer.



Yeah, it would be nice to just have a universal address space
that is compatible with all others. It's sad to see such
uglification to make a secondary tool happy.

 
> >>  	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler);
> >> -	if (IS_ERR(sample_hbp)) {
> >> -		ret = PTR_ERR(sample_hbp);
> >> +	if (IS_ERR((void __force *)sample_hbp)) {
> >> +		ret = PTR_ERR((void __force *)sample_hbp);
> > 
> > Same comments here, although I wouldn't like much a CPU_PTR_ERR or
> > IS_ERR_CPU.... CPP is just so poor in magic for that.
> > 
> > I must confess I miss a bit the old per_cpu prefix that guarded the implicit
> > separate namespace.
> 
> Yeap, I agree that the prefix had its advantages.  It's just that it
> can't scale to the new situation where static and dynamic percpu
> variables behave uniformly.


Well, I miss a bit of per cpu internals so I won't argue further :)

Thanks.

