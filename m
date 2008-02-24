Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbYBXQaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbYBXQaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYBXQap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:30:45 -0500
Received: from mga03.intel.com ([143.182.124.21]:65128 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbYBXQao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:30:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,397,1199692800"; 
   d="scan'208";a="382932333"
Date: Sun, 24 Feb 2008 08:29:32 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Roger While <simrw@sim-basis.de>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 1/2] x86,fpu: split FPU state from task struct
Message-ID: <20080224162932.GB27194@linux-os.sc.intel.com>
References: <6.1.1.1.2.20080224082113.01e51e50@192.168.6.12>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6.1.1.1.2.20080224082113.01e51e50@192.168.6.12>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 08:27:30AM +0100, Roger While wrote:
> 
> On Sat, Feb 23, 2008 at 06:34:38PM -0800, Suresh Siddha wrote:
> > Split the FPU save area from the task struct. This allows easy migration
> > of FPU context, and it's generally cleaner. It also allows the following
> > two optimizations:
> >
> > 1) only allocate when the application actually uses FPU, so in the first
> > lazy FPU trap. This could save memory for non-fpu using apps. Next patch
> > does this lazy allocation.
> >
> > 2) allocate the right size for the actual cpu rather than 512 bytes 
> always.
> > Patches enabling xsave/xrstor support (coming shortly) will take advantage
> > of this.
> 
> >  	if (next_p->fpu_counter>5)
> > -		prefetch(&next->i387.fxsave);
> > +		prefetch(FXSAVE(next_p));
> 
> Shouldn't that be  prefetch(FXSAVE(next));  ?

No. 'next_p' which is the task_struct is what FXSAVE macro takes.

thanks,
suresh
