Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZCKVub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZCKVub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZCKVuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:50:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55091 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZCKVuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:50:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume (rev. 5)
Date: Wed, 11 Mar 2009 22:50:09 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <200902221837.49396.rjw@sisk.pl> <200903112215.02445.rjw@sisk.pl> <alpine.LFD.2.00.0903112234530.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903112234530.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903112250.10572.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Thomas Gleixner wrote:
> On Wed, 11 Mar 2009, Rafael J. Wysocki wrote:
> > On Wednesday 11 March 2009, Thomas Gleixner wrote:
> > > > +			desc->status |= IRQ_SUSPENDED;
> > > 
> > >   This flag needs to be checked in __enable_irq().
> > 
> > [I overlooked this comment, sorry.]
> > 
> > Why does it?
> 
> To catch abuse and callers of enable_irq() when this flag is set.

Hmm.  This means you'd like to make enable_irq() fail if called with
IRQ_SUSPENDED set, correct?

What if someone calls irq_disable() and then irq_enable() between
suspend_device_irqs() and resume_device_irqs()?  That would be pointless, but
surely not a bug?  Should irq_disable() also fail if IRQ_SUSPENDED is set?

Or should __enable_irq() only fail with IRQ_SUSPENDED set for desc->depth == 1?

Rafael
