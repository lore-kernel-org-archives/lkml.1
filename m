Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbYDNImj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbYDNImj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbYDNImT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:42:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253AbYDNImQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:42:16 -0400
Date: Mon, 14 Apr 2008 04:40:49 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       mingo <mingo@redhat.com>, tglx <tglx@linutronix.de>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 10 (arch/x86)
Message-ID: <20080414084048.GD23259@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au> <20080410150950.5913b16a.randy.dunlap@oracle.com> <20080411074631.GB6410@elte.hu> <20080411081901.f56f5180.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411081901.f56f5180.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 08:19:01AM -0700, Randy Dunlap wrote:
> On Fri, 11 Apr 2008 09:46:31 +0200 Ingo Molnar wrote:
> 
> > 
> > * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > Fix printk formats in x86/mm/ioremap.c:
> > > 
> > > next-20080410/arch/x86/mm/ioremap.c:137: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
> > > next-20080410/arch/x86/mm/ioremap.c:188: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
> > > next-20080410/arch/x86/mm/ioremap.c:188: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'
> > 
> > thanks, applied.
> > 
> > >  	if (!phys_addr_valid(phys_addr)) {
> > >  		printk(KERN_WARNING "ioremap: invalid physical address %llx\n",
> > > -		       phys_addr);
> > > +		       (unsigned long long)phys_addr);
> > 
> > is there really no way to solve this more cleanly than a forced cast?
> 
> I haven't seen any other decent solutions.  This is what we do
> all over the kernel.

You can define macros and use them in the format string.
In this case
		printk(KERN_WARNING "ioremap: invalid physical address %" PRIRESOURCESZ "\n",
		       phys_addr);
(see the PRI* macros in
http://www.opengroup.org/onlinepubs/009695399/basedefs/inttypes.h.html
and e.g. glibc inttypes.h to see how it is defined).  Other alternative is
custom format length modifiers, but unfortunately there is no easy way ATM
to teach GCC about them.

	Jakub
