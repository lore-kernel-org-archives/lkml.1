Return-Path: <linux-kernel-owner+w=401wt.eu-S965632AbXBTARo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965632AbXBTARo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965627AbXBTARl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:17:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965613AbXBTARV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:17:21 -0500
Date: Mon, 19 Feb 2007 19:14:34 -0500
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] {rd,wr}msr_on_cpu SMP=n optimization
Message-ID: <20070220001434.GG16332@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexey Dobriyan <adobriyan@openvz.org>,
	linux-kernel@vger.kernel.org
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org> <20070220000713.GP13958@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220000713.GP13958@stusta.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 01:07:13AM +0100, Adrian Bunk wrote:
 > On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
 > >...
 > > Changes since 2.6.20-rc6-mm3:
 > >...
 > > +rdmsr_on_cpu-wrmsr_on_cpu.patch
 > >...
 > >  x86 updates
 > >...
 > 
 > Let's save a few bytes in the CONFIG_SMP=n case.
 > 
 > Signed-off-by: Adrian Bunk <bunk@stusta.de>
 > 
 > ---
 > 
 > BTW: currently -ENOUSERS

There was a follow-on patch that converted p4-clockmod to use it for one.

 > +#ifdef CONFIG_SMP
 >  void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 >  void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 > +#else  /*  CONFIG_SMP  */
 > +static inline void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
 > +{
 > +	rdmsr(msr_no, *l, *h);
 > +}
 > +static inline void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 > +{
 > +	wrmsr(msr_no, l, h);
 > +}
 > +#endif  /*  CONFIG_SMP  */

BUG_ON(cpu!=smp_processor_id()) maybe?

		Dave

-- 
http://www.codemonkey.org.uk
