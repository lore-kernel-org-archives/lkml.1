Return-Path: <linux-kernel-owner+w=401wt.eu-S965387AbXBFTeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965387AbXBFTeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 14:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965389AbXBFTeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 14:34:04 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40301 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965387AbXBFTeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 14:34:01 -0500
Date: Tue, 6 Feb 2007 19:46:26 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, drzeus-wbsd@drzeus.cx,
       wbsd-devel@list.drzeus.cx
Subject: Re: [PATCH] kernel: shut up the IRQ mismatch messages (Re: wbsd:
 IRQ handler type mismatch)
Message-ID: <20070206194626.5a8f47ab@localhost.localdomain>
In-Reply-To: <20070206112949.1fc99299.akpm@linux-foundation.org>
References: <45C7F32B.1060402@shaw.ca>
	<20070206113023.3c845bb2@localhost.localdomain>
	<20070206112949.1fc99299.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Signed-off-by: Alan Cox <alan@redhat.com>
> > 
> > --- linux.vanilla-2.6.20-rc6-mm3/kernel/irq/manage.c	2007-01-31 14:20:43.000000000 +0000
> > +++ linux-2.6.20-rc6-mm3/kernel/irq/manage.c	2007-02-06 11:01:00.796928504 +0000
> > @@ -372,12 +372,14 @@
> >  	return 0;
> >  
> >  mismatch:
> > +#ifdef CONFIG_DEBUG_SHIRQ
> >  	if (!(new->flags & IRQF_PROBE_SHARED)) {
> >  		printk(KERN_ERR "IRQ handler type mismatch for IRQ %d\n", irq);
> >  		if (old_name)
> >  			printk(KERN_ERR "current handler: %s\n", old_name);
> >  		dump_stack();
> >  	}
> > +#endif	
> >  	spin_unlock_irqrestore(&desc->lock, flags);
> >  	return -EBUSY;
> >  }
> 
> hm, well, it's dependent upon dwmw2's
> generate-a-spurious-irq-at-request_irq-time patch.  Do we want to merge
> that?

CONFIG_DEBUG_SHIRQ seemed to be the right configuration option
irrespective of whether we merge Dave's spurious irq tester (which I
think is actually a good test tool)

Alan
