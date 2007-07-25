Return-Path: <linux-kernel-owner+w=401wt.eu-S932443AbXGYAjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbXGYAjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 20:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760347AbXGYAjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 20:39:40 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:48021 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759317AbXGYAjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 20:39:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FJ5Y3CX7dgAA60EpoVFzbw15WMOgCIZIBxdQl3KfsU34wAMjQWsVZ+vzAEUMtzR3BIbTiiExQZLyQxwDc8qwHRpHl/z+k6qnZv2Rs0TI8qZBgQDOXoobOR7K3L+rm4dXPyY6DIMUvw0Yuvh4CwjaNyHOea+p8dI0baZG1AjEqZY=  ;
X-YMail-OSG: c6oUS8sVM1mDihvnXJrPhUxxMJMJv9TH79TUu2KVhBuMDT1BSzBW23APEVOqW5ETnoOCdiczCA--
From: David Brownell <david-b@pacbell.net>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [patch 2.6.23-rc1] dma_free_coherent() needs irqs enabled (sigh)
Date: Tue, 24 Jul 2007 17:35:55 -0700
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
References: <200707241429.05615.david-b@pacbell.net> <200707241608.12198.david-b@pacbell.net> <20070724231157.GA30861@flint.arm.linux.org.uk>
In-Reply-To: <20070724231157.GA30861@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707241735.55427.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2007, Russell King wrote:
> > > 
> > > I think you got the year wrong:
> > > 
> > > 5edf71ae (Russell King      2005-11-25 15:52:51 +0000 364)      WARN_ON(irqs_disabled());
> > > 
> > > which is due to this commit:
> > > 
> > > [ARM] Do not call flush_tlb_kernel_range() with IRQs disabled.
> > 
> > This little "to do" list item has been sitting in my mailbox way
> > too long then.  Certainly since it was fair to say "last year"!  ;)
> 
> Are you intentionally not reading what I said?

Hardly.  Go back and read what *I* wrote!

It just took a while to notice that behavioral change, since
I don't normally run the relevant regression tests using lockdep.
It was sometime in the first half of 2006, ergo "since it was
fair to say 'last year'".

A bunch of piecemeal workarounds followed; and recently they were
all replaced with a more fundamental fix.  This doc patch was the
tail end of the process of recovering from that change ... and the
warnings are there to help other folk from seeing the same issue
in other contexts.

- Dave


