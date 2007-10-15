Return-Path: <linux-kernel-owner+w=401wt.eu-S934065AbXJOUYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065AbXJOUYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbXJOUYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:24:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59906 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbXJOUY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:24:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: mgross@linux.intel.com
Subject: Re: 2.6.23-mm1
Date: Mon, 15 Oct 2007 22:40:02 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <200710122332.41944.rjw@sisk.pl> <20071015160914.GA18550@linux.intel.com>
In-Reply-To: <20071015160914.GA18550@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710152240.03543.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 15 October 2007 18:09, Mark Gross wrote:
> On Fri, Oct 12, 2007 at 11:32:40PM +0200, Rafael J. Wysocki wrote:
> > On Friday, 12 October 2007 06:31, Andrew Morton wrote:
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> > > 
> > > - I've been largely avoiding applying anything since rc8-mm2 in an attempt
> > >   to stabilise things for the 2.6.23 merge.
> > > 
> > >   But that didn't stop all the subsystem maintainers from going nuts, with
> > >   the usual accuracy.  We're up to a 37MB diff now, but it seems to be working
> > >   a bit better.
> > 
> > I get many traces similar to the one below from it (w/ hotfixes):
> > 
> > WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()
> 
> This is from : WARN_ON(irqs_disabled()) in the cmp_call_function_mask
> processor_idle.c is registering a acpi_processor_latency_notify 
> 
> my code changed the notifier call from blocking_notifier_call_chain to
> srcu_notifier_call_chain, because dynamic creation of notifier chains at
> runtime where easier with the srcu_notifier_call_chain than the
> blocking_notifier_call_chain.  
> 
> As dynamic creation of PM_QOS parameters are no longer needed I can
> change the notifiers back to match what was in lanency.c
> 
> However; looking at the call tree differences between
> blockin_notifier_call_chain and srcu_notifier_call_chain I cannot see a
> difference in irq enabling / disabling.  I'm not confident this will
> address this yet.

Well, you can send me a patch to check. :-)

> I'll change the PM_QOS params patch to use blocking notifiers and test
> on a 64bit boot and see what happens.  I've been needing to setup my
> x86_64 dev box for a while now anyway.

OK, thanks.

Greetings,
Rafael
