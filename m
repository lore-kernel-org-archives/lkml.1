Return-Path: <linux-kernel-owner+w=401wt.eu-S933476AbYAaQ3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbYAaQ3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762701AbYAaQ2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:28:48 -0500
Received: from www.tglx.de ([62.245.132.106]:46788 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761598AbYAaQ2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:28:47 -0500
Date: Thu, 31 Jan 2008 17:28:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: huang ying <huang.ying.caritas@gmail.com>
cc: "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: add executable mapping support to ioremap
In-Reply-To: <851fc09e0801310522s2d690c3ejef661e5ce6847f73@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0801311720280.9204@apollo.tec.linutronix.de>
References: <1201764967.12950.25.camel@caritas-dev.intel.com>  <alpine.LFD.1.00.0801311324270.9204@apollo.tec.linutronix.de> <851fc09e0801310522s2d690c3ejef661e5ce6847f73@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, huang ying wrote:

> On Jan 31, 2008 9:00 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Thu, 31 Jan 2008, Huang, Ying wrote:
> >
> > > This patch makes ioremap() can be used to map pages as executable,
> > > this is needed by EFI support.
> >
> > > +extern void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
> > > +                            enum ioremap_mode mode,
> > > +                            enum ioremap_xmode xmode);
> > > +
> >
> > Why do you want to add a new API?
> >
> >     addr = ioremap(phys_addr, len);
> >     set_memory_x(addr);
> >
> > should do what you want already. I think Arjan was not very clear in
> > his reply yesterday.
> 
> In current implementation, change_page_attr() can be used to change
> identity map only.  At least I can find __pa() are used in
> change_page_attr_addr() to get physical address. So I think
> change_page_attr() should be fixed firstly.

There is nothing to fix. It works on virtual addresses. 

The __pa() in change_page_attr_addr() is only used to check for the
high alias mapping of the kernel, but the call to change_page_attr
uses the virtual address.

Thanks,

     tglx
