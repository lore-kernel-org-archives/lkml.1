Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbZKYT5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbZKYT5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 14:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759626AbZKYT5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 14:57:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759622AbZKYT5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 14:57:33 -0500
Date: Wed, 25 Nov 2009 11:56:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Luming Yu <luming.yu@gmail.com>
Subject: Re: [PATCH 1/2] hrtimer: correct a few numbers in comments and
 printk outputs
Message-Id: <20091125115601.3741fcc7.akpm@linux-foundation.org>
In-Reply-To: <20091124101403.GA25364@pengutronix.de>
References: <1258745020-28060-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<20091123152516.729e1407.akpm@linux-foundation.org>
	<20091124101403.GA25364@pengutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 11:14:03 +0100
Uwe Kleine-K__nig  <u.kleine-koenig@pengutronix.de> wrote:

> Hello Andrew,
> 
> On Mon, Nov 23, 2009 at 03:25:16PM -0800, Andrew Morton wrote:
> > On Fri, 20 Nov 2009 20:23:39 +0100
> > Uwe Kleine-K__nig  <u.kleine-koenig@pengutronix.de> wrote:
> > 
> > > @@ -52,7 +52,7 @@ int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
> > >  			printk(KERN_WARNING
> > >  			       "CE: %s increasing min_delta_ns to %lu nsec\n",
> > >  			       dev->name ? dev->name : "?",
> > > -			       dev->min_delta_ns << 1);
> > > +			       dev->min_delta_ns);
> > >  
> > >  			i = 0;
> > >  		}
> > 
> > This one's already in linux-next:
> > 
> > @@ -50,9 +50,9 @@ int tick_dev_program_event(struct clock_
> >  				dev->min_delta_ns += dev->min_delta_ns >> 1;
> >  
> >  			printk(KERN_WARNING
> > -			       "CE: %s increasing min_delta_ns to %lu nsec\n",
> > +			       "CE: %s increasing min_delta_ns to %llu nsec\n",
> >  			       dev->name ? dev->name : "?",
> > -			       dev->min_delta_ns << 1);
> > +			       (unsigned long long) dev->min_delta_ns << 1);
> '<< 1' is wrong here, too.
> 

What's wrong with it?  That leftshift appears to be to compensate for
the rightshift a few lines above.

That change was unobvious and unchangelogged, so here we are again.
