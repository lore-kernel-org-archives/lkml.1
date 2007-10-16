Return-Path: <linux-kernel-owner+w=401wt.eu-S965335AbXJPT7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965335AbXJPT7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760524AbXJPT7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:59:18 -0400
Received: from mga05.intel.com ([192.55.52.89]:35043 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934911AbXJPT7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:59:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,284,1188802800"; 
   d="scan'208";a="347900043"
Date: Tue, 16 Oct 2007 12:58:34 -0700
From: Mark Gross <mgross@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.23-mm1
Message-ID: <20071016195834.GA23157@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <200710122332.41944.rjw@sisk.pl> <20071015160914.GA18550@linux.intel.com> <200710152240.03543.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710152240.03543.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 10:40:02PM +0200, Rafael J. Wysocki wrote:
> On Monday, 15 October 2007 18:09, Mark Gross wrote:
> > On Fri, Oct 12, 2007 at 11:32:40PM +0200, Rafael J. Wysocki wrote:
> > > On Friday, 12 October 2007 06:31, Andrew Morton wrote:
> > > > 
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> > > > 
> > > > - I've been largely avoiding applying anything since rc8-mm2 in an attempt
> > > >   to stabilise things for the 2.6.23 merge.
> > > > 
> > > >   But that didn't stop all the subsystem maintainers from going nuts, with
> > > >   the usual accuracy.  We're up to a 37MB diff now, but it seems to be working
> > > >   a bit better.
> > > 
> > > I get many traces similar to the one below from it (w/ hotfixes):
> > > 
> > > WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()
> > 
> > This is from : WARN_ON(irqs_disabled()) in the cmp_call_function_mask
> > processor_idle.c is registering a acpi_processor_latency_notify 
> > 
> > my code changed the notifier call from blocking_notifier_call_chain to
> > srcu_notifier_call_chain, because dynamic creation of notifier chains at
> > runtime where easier with the srcu_notifier_call_chain than the
> > blocking_notifier_call_chain.  
> > 
> > As dynamic creation of PM_QOS parameters are no longer needed I can
> > change the notifiers back to match what was in lanency.c
> > 
> > However; looking at the call tree differences between
> > blockin_notifier_call_chain and srcu_notifier_call_chain I cannot see a
> > difference in irq enabling / disabling.  I'm not confident this will
> > address this yet.
> 
> Well, you can send me a patch to check. :-)

I think I'll have to send you a patch that changes the notifiers but I
doubt it will fix it.  

After a bit of messing around I have the 2.6.23-mm1 running on my core-2
box  note: Ubuntu's make-kpkg on the mm1 tree resulted in a system that
wouldn't boot past the intrd.  Looks like the pivot root failed or
something.

Anyway, I'm not reproducing your experience, snd_pcm is loaded.  I don't
know none of the WARN's are not hitting on my box.

do you have some configuration information that could help me reproduce
the issue?

> 
> > I'll change the PM_QOS params patch to use blocking notifiers and test
> > on a 64bit boot and see what happens.  I've been needing to setup my
> > x86_64 dev box for a while now anyway.
> 
> OK, thanks.

well its booting but I'm not reproducing the trace messages.

I'll do the patch for you to test.

--mgross
