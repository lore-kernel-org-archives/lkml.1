Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbXCVWph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbXCVWph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXCVWph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:45:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:36687 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbXCVWpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:45:36 -0400
Date: Thu, 22 Mar 2007 23:45:34 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Fix irqpoll on IA64 (timer interrupt != 0)
Message-ID: <20070322224534.GA12791@sykes.suse.de>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>
References: <20070320150027.GA18143@strauss.suse.de> <20070322140922.a59bea5c.akpm@linux-foundation.org> <1174598601.10840.231.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174598601.10840.231.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

* Thomas Gleixner <tglx@linutronix.de> [2007-03-22 22:23]:
> 
> > Also, the code presently passes the magic IRQ number into the generic IRQ
> > code.  I wonder if we'd get a more pleasing result if we were to make the
> > generic IRQ code call _out_ to the architecture:
> 
> > Then, ia64 can implement arch_is_irqpoll_irq() and it can do whatever it
> > wants in there.
> > 
> > The __attribute__((weak)) thing adds a little bit of overhead, but I don't
> > think this is a fastpath?
> 
> Well, depends what you consider a fastpath. When noirqdebug == 0, it is
> called on every interrupt.

I think that function is only called if irqfixup == 2, because if the
first condition in the expression is wrong, the evaluation of the
expression is aborted in C.


Regards,
  Bernhard
