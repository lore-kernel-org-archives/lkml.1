Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZCKWDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZCKWDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbZCKWCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:02:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55161 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722AbZCKWCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:02:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume (rev. 5)
Date: Wed, 11 Mar 2009 23:01:50 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <200902221837.49396.rjw@sisk.pl> <200903112159.21166.rjw@sisk.pl> <alpine.LFD.2.00.0903112238280.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903112238280.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903112301.51594.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Thomas Gleixner wrote:
> On Wed, 11 Mar 2009, Rafael J. Wysocki wrote:
> > On Wednesday 11 March 2009, Thomas Gleixner wrote:
> > > > +EXPORT_SYMBOL_GPL(suspend_device_irqs);
> > > 
> > >   I'm not too enthusiastic about this open coded implementation of
> > >   disable_irq() with slightly different semantics.
> > 
> > The difference in semantics is important IMO, otherwise I woulndn't have
> > done that.  In particular, IMO, the condition should be under the spinlock IMO
> > and I'd rather not synchronize all interrupts we don't really disable here.
> 
> I don't say that the difference is not relevant. But the code is
> almost the same and disable_irq() could have the sync_irq optimization
> as well.

Agreed.

> > >   Can we please move the fiddling with desc->* into
> > >   kernel/irq/manage.c and share the code there ?
> > 
> > Can you please discuss that with Ingo?  I moved that from manage.c at his
> > request.
> 
> Hmrpf. Will do. I just want to avoid that we have scattered functions
> which deal with the guts of the irq code all over the place.

I understand your concern, I'd prefer to avoid that too.

> I'm fine with your loop in irq/pm.c, but the actual handling of the irq
> internals should remain in manage.c.

Well, perhaps we can add a parameter to disable_irq_nosync() telling it not
to disable the interrupt if it's a timer one?  Something like

void disable_irq_nosync(unsigned int irq, bool skip_timer) etc.?

Also, it could return a value meaning whether or not the interrupt has been
actually disabled.

> I'll have a closer look how to solve this.

Thanks!

Best,
Rafael
