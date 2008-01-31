Return-Path: <linux-kernel-owner+w=401wt.eu-S933921AbYAaQog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921AbYAaQog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932769AbYAaQoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:44:15 -0500
Received: from ns2.suse.de ([195.135.220.15]:43415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172AbYAaQoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:44:14 -0500
Date: Thu, 31 Jan 2008 17:44:12 +0100
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, huang ying <huang.ying.caritas@gmail.com>,
       "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: add executable mapping support to ioremap
Message-ID: <20080131164412.GF25989@bingen.suse.de>
References: <1201764967.12950.25.camel@caritas-dev.intel.com> <alpine.LFD.1.00.0801311324270.9204@apollo.tec.linutronix.de> <851fc09e0801310522s2d690c3ejef661e5ce6847f73@mail.gmail.com> <alpine.LFD.1.00.0801311720280.9204@apollo.tec.linutronix.de> <20080131163022.GD25989@bingen.suse.de> <alpine.LFD.1.00.0801311732420.9204@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801311732420.9204@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 05:37:05PM +0100, Thomas Gleixner wrote:
> On Thu, 31 Jan 2008, Andi Kleen wrote:
> 
> > > There is nothing to fix. It works on virtual addresses. 
> > > 
> > > The __pa() in change_page_attr_addr() is only used to check for the
> > > high alias mapping of the kernel, but the call to change_page_attr
> > > uses the virtual address.
> > 
> > But __pa() doesn't work for ioremap ...
> 
> If it does not, then __pa() needs to be fixed, nothing else.

No if, it doesn't.

Changing that seems like a slippery rope. Would you want to make it work for
user space addresses then too? It would certainly become
much more heavyweight because it requires much more checks
and then a page table lookup.

For a fairly uncommon case.

I always thought the cheap direct va<->pa conversions to be one of the basic
design principles of the Linux VM. It's surprising you want to throw
that overboard that quickly. 

Better check at least with Linus first, it's a fairly fundamental change.

To be honest IMHO the simplest way to fix this problem would be to just put the 
pgprot_t argument back into __ioremap().  Then you wouldn't have all
these problems.

-Andi

