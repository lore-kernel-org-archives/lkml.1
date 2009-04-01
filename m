Return-Path: <linux-kernel-owner+w=401wt.eu-S1764913AbZDAQPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764913AbZDAQPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbZDAQPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:15:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:43039 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbZDAQPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=elZySshotooiW2MxjPD56hNpxq1HnAwIg/GNE7AANAd4oZxQN6MmGV68q0Zr2CLvtc
         tR4mDvSAidCQo+EqWh5+VexBKww9Eo5/GJlzjqiCNh9NIInbiOaCeFGpPP+rypO9br/3
         vhbvJm74/drtags3MuX5YOgvYGCa8EzYJhUN8=
Date: Wed, 1 Apr 2009 20:16:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       xemul@openvz.org, yhlu.kernel@gmail.com
Subject: Re: [patch 4/6] x86: irqinit - merge native_init_IRQ
Message-ID: <20090401161609.GD15781@localhost>
References: <20090329201545.470255691@openvz.org> <20090329202208.155551990@openvz.org> <20090401145328.GB6196@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401145328.GB6196@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Apr 01, 2009 at 04:53:28PM +0200]
...
| > Index: linux-2.6.git/arch/x86/kernel/setup.c
| > ===================================================================
| > --- linux-2.6.git.orig/arch/x86/kernel/setup.c
| > +++ linux-2.6.git/arch/x86/kernel/setup.c
| > @@ -1087,3 +1087,11 @@ void __init x86_quirk_time_init(void)
| >  	setup_irq(0, &irq0);
| >  }
| >  #endif /* CONFIG_X86_32 */
| > +
| > +#ifdef CONFIG_X86_64
| > +void x86_quirk_pre_intr_init(void)
| > +{
| > +	init_ISA_irqs();
| > +}
| > +void x86_quirk_intr_init(void) { }
| > +#endif
| 
| Hm, wouldnt it be cleaner to add it as a new quirk function vector 
| in struct x86_quirks? See arch/x86/include/asm/setup.h.
| 
| 	Ingo
| 

I just remember -- I thought about that and since x86_quirk_pre_intr_init
described as external BUT implemented for x86-32 only I needed
to indroduce new x86-64 versions for this (and since I know
that there no need to do anything else except calling init_ISA_irqs
I desided to have separate wrapper for that).

And btw x86-32 already has init_ISA_irqs call and quirks
are used in x86-32 mode only so for 64bit it will be just
a not needed check. Which means - I could just use original
x86_quirk_pre_intr_init function which  will call all I need.

Or you meant something else?

        Cyrill
