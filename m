Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbXKTKWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbXKTKWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbXKTKVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:21:53 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:46457 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbXKTKVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:21:52 -0500
Message-ID: <4742B41F.4000605@keyaccess.nl>
Date: Tue, 20 Nov 2007 11:17:03 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trenn@suse.de
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] PNP cleanups - Unify the pnp macros to access	resources
 in the pnp resource table
References: <1195552283.23700.166.camel@queen.suse.de>
In-Reply-To: <1195552283.23700.166.camel@queen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-11-07 10:51, Thomas Renninger wrote:

> Unify the pnp macros to access resources in the pnp resource table
> 
> port, mem, dma and irq resource macros are now all used in the same
> way. This is the basis (or makes it at least easier) for changing how
> the resources are allocated for memory optimizations.
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>

Acked-by: Rene Herman <rene.herman@gmail.com>

as identity transformation again.

Andrew Morton wrote:

> Normally when I get a big tree-wide patch like this I'll just drop the
> hunks which get rejects so that the patch doesn't screw up other people's
> trees if I merge first.
> 
> 
>> > 
>> > Index: linux-2.6.24-rc2/include/linux/pnp.h
>> > ===================================================================
>> > --- linux-2.6.24-rc2.orig/include/linux/pnp.h
>> > +++ linux-2.6.24-rc2/include/linux/pnp.h
>> > @@ -55,7 +55,6 @@ struct pnp_dev;
>> >  	 (pnp_mem_end((dev),(bar)) -		\
>> >  	  pnp_mem_start((dev),(bar)) + 1))
>> >  
>> > -#define pnp_irq(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
>> >  #define pnp_irq_start(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
>> >  #define pnp_irq_end(dev,bar)	 ((dev)->res.irq_resource[(bar)].end)
>> >  #define pnp_irq_flags(dev,bar)	 ((dev)->res.irq_resource[(bar)].flags)
>> > @@ -63,7 +62,6 @@ struct pnp_dev;
>> >  	((pnp_irq_flags((dev),(bar)) & (IORESOURCE_IRQ | IORESOURCE_UNSET)) \
>> >  		== IORESOURCE_IRQ)
>> >  
>> > -#define pnp_dma(dev,bar)	 ((dev)->res.dma_resource[(bar)].start)
> 
> But if I do that, we'll get build breakage.
> 
> And we'll break any files which you missed in the conversion, or which
> people currently have queued in the subsystem trees, or which people are
> maintaining out-of-tree.
> 
> Hence I'd suggest that we retain the above as back-compatibility wrappers
> for a while.

And Shaohua Li wrote:

> patches are great. I have a minor comment. Keep pnp_irq and pnp_dma and
> define them as pnp_irq_start and pnp_dma_start. pnp_irq_start and
> pnp_dma_start is a little confusing from a pnp driver point of view.

Rene.

