Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbXFZMQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbXFZMQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 08:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXFZMQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 08:16:43 -0400
Received: from www.osadl.org ([213.239.205.134]:60452 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751906AbXFZMQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 08:16:42 -0400
Subject: Re: [patch -mm 10/28] highres: Improve debug output
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070625171404.4717ed48.akpm@linux-foundation.org>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
	 <20070623124030.575989896@inhelltoy.tec.linutronix.de>
	 <20070625171404.4717ed48.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 26 Jun 2007 14:16:39 +0200
Message-Id: <1182860199.11854.0.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 17:14 -0700, Andrew Morton wrote:
> On Sat, 23 Jun 2007 13:32:35 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> >  	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT) ||
> > -	    !tick_device_is_functional(dev))
> > +		    !tick_device_is_functional(dev)) {
> > +
> > +		printk(KERN_INFO "Clockevents: "
> > +		       "could not switch to one-shot mode:");
> > +		if (!dev) {
> > +			printk(" no tick device\n");
> > +		} else {
> > +			if (!tick_device_is_functional(dev))
> > +				printk(" %s is not functional.\n", dev->name);
> > +			else if (!(dev->features & CLOCK_EVT_FEAT_ONESHOT))
> > +				printk(" %s does not support one-shot mode.\n",
> > +				       dev->name);
> > +		}
> 
> There is a logic path through here where the printk doesn't get its \n
> termination?  And it will fail to print the reason for the failure, too.
> 
> Maybe that's a can't-happen, in which case the CLOCK_EVT_FEAT_ONESHOT test
> is superfluous?

Right, the "else if (...)" test is bogus. A simple "else" is sufficient.

	tglx


