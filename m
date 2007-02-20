Return-Path: <linux-kernel-owner+w=401wt.eu-S965664AbXBTAV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965664AbXBTAV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965591AbXBTAVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:21:51 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36188 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750953AbXBTAVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:21:46 -0500
Date: Tue, 20 Feb 2007 01:21:45 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] {rd,wr}msr_on_cpu SMP=n optimization
Message-ID: <20070220002145.GP13958@stusta.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org> <20070220000713.GP13958@stusta.de> <20070220001434.GG16332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220001434.GG16332@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 07:14:34PM -0500, Dave Jones wrote:
> On Tue, Feb 20, 2007 at 01:07:13AM +0100, Adrian Bunk wrote:
>...
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

This is the CONFIG_SMP=n case.

> 		Dave

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

