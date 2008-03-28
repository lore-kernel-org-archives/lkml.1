Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYC1Uqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYC1Uqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbYC1UqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:46:25 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36422 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbYC1UqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:46:24 -0400
Date: Fri, 28 Mar 2008 13:46:16 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
Message-ID: <20080328204616.GB6233@us.ibm.com>
References: <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org> <20080326203012.GB6249@us.ibm.com> <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org> <20080326205828.GA15225@jurassic.park.msu.ru> <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org> <20080326232922.GA15784@jurassic.park.msu.ru> <alpine.LFD.1.00.0803261638350.2775@woody.linux-foundation.org> <alpine.LFD.1.00.0803271004380.2775@woody.linux-foundation.org> <20080327221851.GA9675@jurassic.park.msu.ru> <20080328192402.GA6233@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328192402.GA6233@us.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 12:24:02PM -0700, Gary Hade wrote:
> On Fri, Mar 28, 2008 at 01:18:51AM +0300, Ivan Kokshaysky wrote:
> > On Thu, Mar 27, 2008 at 10:12:10AM -0700, Linus Torvalds wrote:
> > > Actually, before we go any further, there might be a less intrusive 
> > > alternative: add just a couple of flags to the resource flags field (we 
> > > still have something like 8 unused bits on 32-bit), and use those to 
> > > implement a generic "resource_alignment()" routine.
> > > 
> > > Two flags would do it:
> > > 
> > >  - IORESOURCE_SIZEALIGN: size indicates alignment (regular PCI device 
> > >    resources)
> > > 
> > >  - IORESOURCE_STARTALIGN: start field is alignment (PCI bus resources 
> > >    during probing)
> > 
> > Sounds good to me. So here we go (completely untested, just for review).
> 
> Ivan, After adding a resource_alignment() prototype to
                 < snip >
> Will now try on one of our servers that I am the most concerned
> about.

Just tried it on an IBM x3850.  No obvious problems or unexpected
messages spotted during/following boot or during/following hotplug
of PCI-X and PCIe cards.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
