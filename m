Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbXJXJBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbXJXJBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbXJXJB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:01:28 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48520 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbXJXJB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:01:27 -0400
Date: Wed, 24 Oct 2007 14:31:28 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: h-shimamoto@ct.jp.nec.com
Cc: hbabu@us.ibm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org,
       Fernando Luis Vazquez Cao <fernando@intellilink.co.jp>
Subject: Re: [PATCH 2/3] x86: add safe_smp_processor_id for x86_64
Message-ID: <20071024090128.GA4809@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <47195763.1090803@ct.jp.nec.com> <47195876.7080208@ct.jp.nec.com> <20071024063141.GB4622@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024063141.GB4622@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 12:01:41PM +0530, Vivek Goyal wrote:
> On Fri, Oct 19, 2007 at 06:23:02PM -0700, Hiroshi Shimamoto wrote:
> > From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> > 
> > Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> > ---
> >  include/asm-x86/smp_64.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
> > index 6f0e027..ab612b0 100644
> > --- a/include/asm-x86/smp_64.h
> > +++ b/include/asm-x86/smp_64.h
> > @@ -76,6 +76,8 @@ extern unsigned __cpuinitdata disabled_cpus;
> > 
> >  #endif /* CONFIG_SMP */
> > 
> > +#define safe_smp_processor_id()		smp_processor_id()
> > +
> 
> Can you please implement a patch for safe_smp_processor_id() instead of
> using smp_processor_id(). safe_smp_processor_id() was introduced to make
> sure that we are not dependent on the stack of threads after kernel has
> crashed instead read the apic id and convert it to cpu id with other
> data structures. This helped in stack overflow case.
> 
> Hardcoding it to smp_processor_id() will give the false impression.
> 

Just now Aneesh pointed that x86_64 using pda for retrieving processor id
and not kernel stack.

I think it is fine then.

Thanks
Vivek
