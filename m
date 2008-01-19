Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbYASPni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbYASPni (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 10:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759164AbYASPn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 10:43:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54229 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655AbYASPn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 10:43:28 -0500
Date: Sat, 19 Jan 2008 16:46:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: ACPI early ioremap problems
Message-ID: <20080119154651.GA1626@one.firstfloor.org>
References: <20080119030843.GA2028@basil.nowhere.org> <20080119150328.GA32370@elte.hu> <20080119152649.GA1375@one.firstfloor.org> <20080119153055.GA12054@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119153055.GA12054@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 04:30:55PM +0100, Ingo Molnar wrote:
> > > that case it's a 64-bit early_ioremap() bug that we want to find 
> > > even if ACPI didnt use early_ioremap().
> > > 
> > > and this all runs before zap_low_mappings(), right?
> > 
> > No after. Since some time x86-64 does the equivalent of z_l_m() in 
> > head64(); this means before start_kernel and definitely before 
> > setup_arch which sets up ACPI.
> 
> that would mean early_ioremap() should switch to ioremap() after that 
> point. Could you try that, does it resolve the failure you are seeing? 

ioremap() does alloc_page and that won't work before 
paging_init(). Early ACPI scan is before paging_init() because
paging_init() needs node discovery at at least; which requires
some ACPI tables.

> Long-term we want to have a single, uniform ioremap() interface (on 
> 32-bit and 64-bit x86 as well) that can be used anytime, which just 
> switches to the right lowlevel method depending on how far we are into 
> the pagetable and memory subsystem bootstrap - instead of these more 
> fragile "can we now use early_ioremap() or should we already be using 
> ioremap()" usages.

I didn't think there were enough early/bt_ioremap() users for this
to be really worthwhile. The only code that does both I'm aware of
is the memory setup code.

-Andi

