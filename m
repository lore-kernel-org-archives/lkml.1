Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZBCWJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZBCWJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbZBCWJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:09:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41536 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbZBCWJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:09:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Date: Tue, 3 Feb 2009 23:09:01 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain> <20090202234923.GA7499@elte.hu>
In-Reply-To: <20090202234923.GA7499@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032309.01983.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Ingo: how do we walk over all the interrupt descriptors in todays world? 
> > The whole sparse-vs-nonsparse makes things a bit more complex.
> 
> this:
> 
>         struct irq_desc *desc;
>         int irq;
> 
>         for_each_irq_desc(i, desc) {
> 	...
> 	}
> 
> should do the trick.

So, what do I do in the loop to disable irqs for all devices on the IOAPIC
level.  Would disable_irq(irq) be sufficient?

Also, how can I skip the timer interrupt (we don't want to disable that)?

Rafael
