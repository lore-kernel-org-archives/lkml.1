Return-Path: <linux-kernel-owner+w=401wt.eu-S964804AbXBTNol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804AbXBTNol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 08:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964808AbXBTNol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 08:44:41 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:9860 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964804AbXBTNok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 08:44:40 -0500
Date: Tue, 20 Feb 2007 16:50:44 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: Dave Jones <davej@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] {rd,wr}msr_on_cpu SMP=n optimization
Message-ID: <20070220135044.GA11164@localhost.sw.ru>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org> <20070220000713.GP13958@stusta.de> <20070220001434.GG16332@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220001434.GG16332@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 07:14:34PM -0500, Dave Jones wrote:
> On Tue, Feb 20, 2007 at 01:07:13AM +0100, Adrian Bunk wrote:
>  > On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>  > >...
>  > > Changes since 2.6.20-rc6-mm3:
>  > >...
>  > > +rdmsr_on_cpu-wrmsr_on_cpu.patch
>  > >...
>  > >  x86 updates
>  > >...
>  >
>  > Let's save a few bytes in the CONFIG_SMP=n case.
>  >
>  > Signed-off-by: Adrian Bunk <bunk@stusta.de>
>  >
>  > ---
>  >
>  > BTW: currently -ENOUSERS
>
> There was a follow-on patch that converted p4-clockmod to use it for one.

And patch for powernow-k8 in preparations.

>  > +#ifdef CONFIG_SMP
>  >  void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
>  >  void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
>  > +#else  /*  CONFIG_SMP  */
>  > +static inline void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
>  > +{
>  > +	rdmsr(msr_no, *l, *h);
>  > +}
>  > +static inline void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
>  > +{
>  > +	wrmsr(msr_no, l, h);
>  > +}
>  > +#endif  /*  CONFIG_SMP  */
>
> BUG_ON(cpu!=smp_processor_id()) maybe?

This make sense. Fell free to add it.

