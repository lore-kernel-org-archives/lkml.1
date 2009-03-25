Return-Path: <linux-kernel-owner+w=401wt.eu-S1763556AbZCYSKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763556AbZCYSKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbZCYSK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:10:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:56891 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbZCYSKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:10:25 -0400
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu)
 enabled
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Lutomirski <amluto@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Mark Gross <mgross@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090325180720.GA28366@elte.hu>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com>
	 <20090324203259.GC26930@elte.hu>
	 <1238003581.2085.53.camel@macbook.infradead.org>
	 <20090325175908.GA25518@elte.hu>
	 <1238004228.2085.56.camel@macbook.infradead.org>
	 <20090325180720.GA28366@elte.hu>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 18:10:01 +0000
Message-Id: <1238004601.2085.57.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 19:07 +0100, Ingo Molnar wrote:
> * David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Wed, 2009-03-25 at 18:59 +0100, Ingo Molnar wrote:
> > > 
> > > that's not easy - i use it right now :)
> > > 
> > > That's another reason why warnings and non-panic() behavior are 
> > > better for developers too. Had it not crashed i could have sent you 
> > > my dmesg and i would not have turned off DMAR in the BIOS.
> > > 
> > > Now it's turned off in my BIOS (first barrier) and i need to reboot 
> > > the kernel (second barrier) and i need to hack up a kernel in a 
> > > certain way to produce debug info (third barrier) - in the merge 
> > > window (fourth barrier ;-).
> > 
> > Yeah, trusting BIOS monkeys for this was always going to be a bad 
> > plan. We should have just known how to set/read the damn hardware 
> > BARs -- the most likely explanation for this is that your BIOS is 
> > just lying to you about where it put the registers, I believe.
> > 
> > I'd like to put in a basic sanity check when we first ioremap the 
> > (alleged) DMAR registers. Hopefully, the output I asked for will 
> > confirm that there's a simple way to do that...
> 
> Could you please fix the panic() and add the debug output you'd like 
> to see? That would give me a kernel to run straight away. Without me 
> having to think much about what i should run and when.

That's distinctly non-trivial. I need to bail out early.

> (unless you really need this pr_debug info to proceed)
> 
> But it will be some time really. The laptop has 8 days uptime and is 
> not set up to run custom kernels at all.

Anyone else got a similar machine?

-- 
dwmw2

