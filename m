Return-Path: <linux-kernel-owner+w=401wt.eu-S932096Ab0AETcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab0AETcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308Ab0AETcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:32:50 -0500
Received: from mga05.intel.com ([192.55.52.89]:31743 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755183Ab0AETct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:32:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,505,1257148800"; 
   d="scan'208";a="528693766"
Date: Tue, 5 Jan 2010 20:34:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Felipe Balbi <felipe.balbi@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org
Subject: Re: mfd: twl4030-irq: irq_desc->lock converted to raw_spinlock_t
Message-ID: <20100105193418.GK4274@sortiz.org>
References: <1261998172-29760-1-git-send-email-felipe.balbi@nokia.com>
 <1261998172-29760-5-git-send-email-felipe.balbi@nokia.com>
 <20091228200145.GN3512@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091228200145.GN3512@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Mon, Dec 28, 2009 at 12:01:45PM -0800, Tony Lindgren wrote:
> * Felipe Balbi <felipe.balbi@nokia.com> [091228 03:04]:
> > commit 239007b8440abff689632f50cdf0f2b9e895b534 converted
> > the spinlock_t to raw_spinlock_t. Unfortunately twl4030-irq
> > was left aside on the conversion.
> > 
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: linux-omap@vger.kernel.org
> > Acked-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
> > 
> > ---
> > 
> > resending because it wasn't applied before
> 
> This should go via Samuel as it's MFD related.
Linus applied it to his tree directly.

Cheers,
Samuel.


> Acked-by: Tony Lindgren <tony@atomide.com>
> 
>  
> > 
> >  drivers/mfd/twl4030-irq.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
> > index 20d29ba..9df9a5a 100644
> > --- a/drivers/mfd/twl4030-irq.c
> > +++ b/drivers/mfd/twl4030-irq.c
> > @@ -568,12 +568,12 @@ static void twl4030_sih_do_edge(struct work_struct *work)
> >  
> >  		bytes[byte] &= ~(0x03 << off);
> >  
> > -		spin_lock_irq(&d->lock);
> > +		raw_spin_lock_irq(&d->lock);
> >  		if (d->status & IRQ_TYPE_EDGE_RISING)
> >  			bytes[byte] |= BIT(off + 1);
> >  		if (d->status & IRQ_TYPE_EDGE_FALLING)
> >  			bytes[byte] |= BIT(off + 0);
> > -		spin_unlock_irq(&d->lock);
> > +		raw_spin_unlock_irq(&d->lock);
> >  
> >  		edge_change &= ~BIT(i);
> >  	}

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
