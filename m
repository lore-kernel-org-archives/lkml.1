Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZCKVzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZCKVzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZCKVzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:55:37 -0400
Received: from www.tglx.de ([62.245.132.106]:49817 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900AbZCKVzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:55:36 -0400
Date: Wed, 11 Mar 2009 22:53:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume
 (rev. 5)
In-Reply-To: <200903112250.10572.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0903112251150.29264@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200903112215.02445.rjw@sisk.pl> <alpine.LFD.2.00.0903112234530.29264@localhost.localdomain> <200903112250.10572.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009, Rafael J. Wysocki wrote:

> On Wednesday 11 March 2009, Thomas Gleixner wrote:
> > On Wed, 11 Mar 2009, Rafael J. Wysocki wrote:
> > > On Wednesday 11 March 2009, Thomas Gleixner wrote:
> > > > > +			desc->status |= IRQ_SUSPENDED;
> > > > 
> > > >   This flag needs to be checked in __enable_irq().
> > > 
> > > [I overlooked this comment, sorry.]
> > > 
> > > Why does it?
> > 
> > To catch abuse and callers of enable_irq() when this flag is set.
> 
> Hmm.  This means you'd like to make enable_irq() fail if called with
> IRQ_SUSPENDED set, correct?
> 
> What if someone calls irq_disable() and then irq_enable() between
> suspend_device_irqs() and resume_device_irqs()?  That would be pointless, but
> surely not a bug?  Should irq_disable() also fail if IRQ_SUSPENDED is set?

I'm not worried about nested ones.

> Or should __enable_irq() only fail with IRQ_SUSPENDED set for desc->depth == 1?

At least it needs a WARN_ON() in that case. A very prominent one.

Thanks,

	tglx
