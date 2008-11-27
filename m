Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYK0Ayr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYK0Ayr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 19:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYK0Ayh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 19:54:37 -0500
Received: from www.tglx.de ([62.245.132.106]:49254 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYK0Ayg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 19:54:36 -0500
Date: Thu, 27 Nov 2008 01:54:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <johnstul@us.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Enforce valid shift values in clocksource_register()
In-Reply-To: <1227746358.18967.41.camel@jstultz-laptop>
Message-ID: <alpine.LFD.2.00.0811270150090.3325@localhost.localdomain>
References: <1227743196.18967.36.camel@jstultz-laptop>  <alpine.LFD.2.00.0811270105270.3325@localhost.localdomain> <1227746358.18967.41.camel@jstultz-laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, John Stultz wrote:
> On Thu, 2008-11-27 at 01:08 +0100, Thomas Gleixner wrote:
> > On Wed, 26 Nov 2008, John Stultz wrote:
> > > +	if (c->shift >= 32) {
> > > +		printk(KERN_WARNING "===============================\n");
> > > +		printk(KERN_WARNING "WARNING: Cannot register %s clocksource\n",
> > > +					c->name);
> > > +		printk(KERN_WARNING "The shift value must be less then 32\n");
> > > +		printk(KERN_WARNING "===============================\n");
> > > +		return -EINVAL;
> > 
> > Just setting the shift value to 31 along with a WARN_ON() should be
> > enough. We don't need to kill the clocksource in that case, as this
> > can be nasty when it happens in the early boot code where we dont have
> > any output.
> 
> Well, we can't tweak the shift value without changing the mult. And that
> seemed a bit overreaching (but might be safe). I'll give it a shot.
> 
> Also early boot we should have the jiffies clocksource around, so unless
> I'm forgetting something, I don't think it has early boot concerns.

Fair enough. I forgot that we do a late handover from jiffies to the
real clocksource. Still a WARN_ON is more prominent and more useful
for developers to get to the root cause. Setting the shift to 31 will
result in wrong timer values but not brick the box. So espcially for
code, which calculates the values this might be worthwhile.

Thanks,

	tglx
