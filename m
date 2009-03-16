Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZCPEoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZCPEoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 00:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbZCPEoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 00:44:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:36643 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbZCPEoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 00:44:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,370,1233561600"; 
   d="scan'208";a="120550422"
Date: Mon, 16 Mar 2009 12:43:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Brown, Len" <len.brown@intel.com>,
       "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: Re: [PATCH] ACPI: pass correct parameter to
	acpi_processor_ffh_cstate_probe_cpu()
Message-ID: <20090316044337.GD7903@localhost>
References: <20090312074524.GA15992@localhost> <alpine.LFD.2.00.0903152257260.30317@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903152257260.30317@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 10:59:19AM +0800, Len Brown wrote:
> On Thu, 12 Mar 2009, Wu Fengguang wrote:
> 
> > This fixes a NULL pointer dereference bug introduced by 6e911954cac.
> 
> What tree is this patch on top of?

It's for 2.6.29-rc7-next-20090311. Already fixed in other trees?

Thanks,
Fengguang

> thanks,
> -Len Brown
> Intel Open Source Technology Center
> 
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> > diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
> > index 6626e8c..b866b87 100644
> > --- a/arch/x86/kernel/acpi/cstate.c
> > +++ b/arch/x86/kernel/acpi/cstate.c
> > @@ -137,7 +137,7 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
> >  	/* Run acpi_processor_ffh_cstate_probe_cpu() on the target CPU */
> >  
> >  	retval = smp_call_function_single(cpu,
> > -				acpi_processor_ffh_cstate_probe_cpu, cx, 1);
> > +				acpi_processor_ffh_cstate_probe_cpu, &cxcc, 1);
> >  	if (retval == 0) {
> >  		retval = cxcc.retval;
> >  		if (retval == 0) {
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
