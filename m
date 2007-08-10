Return-Path: <linux-kernel-owner+w=401wt.eu-S935203AbXHJNNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935203AbXHJNNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757647AbXHJNNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:13:09 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:61068 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731AbXHJNNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:13:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TX7HKBITZBYPb0u/6rHfzAnCZkD+Qv9woNU2dUMQSb4td1+1gF/Yv9JWrl2BIk8auCbIrsPnLHvGgb/US3A2njFMnMrsFSXttKGKsfqPLPtVRjbtlyFqT1utDBY56oh5dyOQYAtwQyLqKxJ21I9bIgULOJVy0mFDKNJ9tfOcWpc=
Message-ID: <a44ae5cd0708100613h1a40597cpb33e8972d0c894ed@mail.gmail.com>
Date: Fri, 10 Aug 2007 09:13:05 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc2-mm1 -- drivers/dma/ioat_dca.c:177: error: implicit declaration of function ___cpu_physical_id___
Cc: LKML <linux-kernel@vger.kernel.org>,
       "shannon.nelson@intel.com" <shannon.nelson@intel.com>,
       "Andi Kleen" <ak@suse.de>, "Luck, Tony" <tony.luck@intel.com>
In-Reply-To: <20070809115258.5372f76e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0708090718v5dc19572k69087f170f9ba857@mail.gmail.com>
	 <20070809115258.5372f76e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 9 Aug 2007 10:18:15 -0400
> "Miles Lane" <miles.lane@gmail.com> wrote:
>
> >   CC      drivers/dma/ioat_dca.o
> > drivers/dma/ioat_dca.c: In function 'ioat_dca_get_tag':
> > drivers/dma/ioat_dca.c:177: error: implicit declaration of function
> > 'cpu_physical_id'
>
> Looks like cpu_physical_id() doesn't get implemented if CONFIG_SMP=n.
>
> Either ioat needs to stop using cpu_physical_id() if SMP=n, or the
> supported architectures (i386, x86_64, ia64) should provide a non-SMP
> version of cpu_physical_id().  Preferably the latter, I'd say.
>
> Something like this, I suppose...
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
>
> i386, x86_64 and ia64 implement cpu_physical_id() if CONFIG_SMP=y.
>
> Provide a uniprocessor stub so that callers will dtrt.
>
> Cc: Andi Kleen <ak@suse.de>
> Cc: "Luck, Tony" <tony.luck@intel.com>
> Cc: Shannon Nelson <shannon.nelson@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/smp.h |    5 +++++
>  1 files changed, 5 insertions(+)
>
> diff -puN include/linux/smp.h~implement-cpu_physical_id-on-smp=n include/linux/smp.h
> --- a/include/linux/smp.h~implement-cpu_physical_id-on-smp=n
> +++ a/include/linux/smp.h
> @@ -108,6 +108,11 @@ static inline void smp_send_reschedule(i
>         0;                      \
>  })
>
> +static inline unsigned cpu_physical_id(unsigned cpu)
> +{
> +       return 0;
> +}
> +
>  #endif /* !SMP */
>
>  /*
> _

Worked for me.
Thanks,
      Miles
