Return-Path: <linux-kernel-owner+w=401wt.eu-S1763708AbZCYSUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763708AbZCYSUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbZCYSUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:20:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47337 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252AbZCYSUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:20:34 -0400
Date: Wed, 25 Mar 2009 19:20:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Lutomirski <amluto@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Mark Gross <mgross@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu)
	enabled
Message-ID: <20090325182003.GC28366@elte.hu>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com> <20090324203259.GC26930@elte.hu> <1238003581.2085.53.camel@macbook.infradead.org> <20090325175908.GA25518@elte.hu> <1238004228.2085.56.camel@macbook.infradead.org> <20090325180720.GA28366@elte.hu> <1238004601.2085.57.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238004601.2085.57.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2009-03-25 at 19:07 +0100, Ingo Molnar wrote:
> > * David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > On Wed, 2009-03-25 at 18:59 +0100, Ingo Molnar wrote:
> > > > 
> > > > that's not easy - i use it right now :)
> > > > 
> > > > That's another reason why warnings and non-panic() behavior are 
> > > > better for developers too. Had it not crashed i could have sent you 
> > > > my dmesg and i would not have turned off DMAR in the BIOS.
> > > > 
> > > > Now it's turned off in my BIOS (first barrier) and i need to reboot 
> > > > the kernel (second barrier) and i need to hack up a kernel in a 
> > > > certain way to produce debug info (third barrier) - in the merge 
> > > > window (fourth barrier ;-).
> > > 
> > > Yeah, trusting BIOS monkeys for this was always going to be a bad 
> > > plan. We should have just known how to set/read the damn hardware 
> > > BARs -- the most likely explanation for this is that your BIOS is 
> > > just lying to you about where it put the registers, I believe.
> > > 
> > > I'd like to put in a basic sanity check when we first ioremap the 
> > > (alleged) DMAR registers. Hopefully, the output I asked for will 
> > > confirm that there's a simple way to do that...
> > 
> > Could you please fix the panic() and add the debug output you'd 
> > like to see? That would give me a kernel to run straight away. 
> > Without me having to think much about what i should run and 
> > when.
> 
> That's distinctly non-trivial. I need to bail out early.

yeah, DMA can start rather early, and we also need early resource 
reservations, right? Or is there some other issue that makes it 
difficult in addition to that?

	Ingo
