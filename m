Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab0BEW4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 17:56:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:42115 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344Ab0BEW4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:56:12 -0500
Date: Fri, 5 Feb 2010 14:55:35 -0800
From: Brandon Philips <bphilips@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: keep chip_data in create_irq_nr and destroy_irq
Message-ID: <20100205225535.GF4930@jenkins.home.ifup.org>
References: <20100203033109.GA17985@jenkins.home.ifup.org>
 <4B694DEF.70301@kernel.org>
 <20100203174216.GB17985@jenkins.home.ifup.org>
 <4B6BDAC0.3090900@kernel.org>
 <20100205210926.GE4930@jenkins.home.ifup.org>
 <4B6C9F69.4040605@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6C9F69.4040605@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:44 Fri 05 Feb 2010, Yinghai Lu wrote:
> On 02/05/2010 01:09 PM, Brandon Philips wrote:
> > @@ -77,7 +90,8 @@ void dynamic_irq_cleanup(unsigned int ir
> >  	}
> >  	desc->msi_desc = NULL;
> >  	desc->handler_data = NULL;
> > -	desc->chip_data = NULL;
> > +	if (!keep_chip_data)
> > +		desc->chip_data = NULL;
> >  	desc->handle_irq = handle_bad_irq;
> >  	desc->chip = &no_irq_chip;
> >  	desc->name = NULL;
> > @@ -85,6 +99,26 @@ void dynamic_irq_cleanup(unsigned int ir
> >  	raw_spin_unlock_irqrestore(&desc->lock, flags);
> >  }
> >  
> > +/**
> > + *	dynamic_irq_cleanup - cleanup a dynamically allocated irq
> > + *	@irq:	irq number to initialize
> > + */
> > +void dynamic_irq_cleanup(unsigned int irq)
> > +{
> > +	dynamic_irq_init_x(irq, false);
> 
> should be dynamic_irq_cleanup_x here.
> 
> > +}
> > +
> > +/**
> > + *	dynamic_irq_cleanup_keep_chip_data - cleanup a dynamically allocated irq
> > + *	@irq:	irq number to initialize
> > + *
> > + * 	does not set irq_to_desc(irq)->chip_data to NULL
> > + */
> > +void dynamic_irq_cleanup_keep_chip_data(unsigned int irq)
> > +{
> > +	dynamic_irq_init_x(irq, true);
> 
> should be dynamic_irq_cleanup_x

Oops, right. I will fix this up along with the externs as hpa
suggested and send again.

What are your thoughts on locking? Does it look OK as is?

Thanks,

	Brandon
