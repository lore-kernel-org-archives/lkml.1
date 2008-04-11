Return-Path: <linux-kernel-owner+w=401wt.eu-S1760631AbYDKPVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631AbYDKPVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759639AbYDKPVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:21:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19700 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbYDKPVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:21:09 -0400
Date: Fri, 11 Apr 2008 08:19:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, mingo <mingo@redhat.com>,
       tglx <tglx@linutronix.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 10 (arch/x86)
Message-Id: <20080411081901.f56f5180.randy.dunlap@oracle.com>
In-Reply-To: <20080411074631.GB6410@elte.hu>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au>
	<20080410150950.5913b16a.randy.dunlap@oracle.com>
	<20080411074631.GB6410@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 09:46:31 +0200 Ingo Molnar wrote:

> 
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > Fix printk formats in x86/mm/ioremap.c:
> > 
> > next-20080410/arch/x86/mm/ioremap.c:137: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
> > next-20080410/arch/x86/mm/ioremap.c:188: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
> > next-20080410/arch/x86/mm/ioremap.c:188: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'
> 
> thanks, applied.
> 
> >  	if (!phys_addr_valid(phys_addr)) {
> >  		printk(KERN_WARNING "ioremap: invalid physical address %llx\n",
> > -		       phys_addr);
> > +		       (unsigned long long)phys_addr);
> 
> is there really no way to solve this more cleanly than a forced cast?

I haven't seen any other decent solutions.  This is what we do
all over the kernel.

> It
> is a totally uninteresting warning that we pass in a narrower type to 
> printk(). It cannot ever cause any bugs or problems. Why does gcc warn 
> about it?

No idea about that part.

---
~Randy
