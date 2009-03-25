Return-Path: <linux-kernel-owner+w=401wt.eu-S1763472AbZCYSAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763472AbZCYSAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbZCYR7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:59:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37099 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbZCYR7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:59:48 -0400
Date: Wed, 25 Mar 2009 18:59:08 +0100
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
Message-ID: <20090325175908.GA25518@elte.hu>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com> <20090324203259.GC26930@elte.hu> <1238003581.2085.53.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238003581.2085.53.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2009-03-24 at 21:32 +0100, Ingo Molnar wrote:
> > (Cc:s added)
> > 
> > * Andrew Lutomirski <amluto@gmail.com> wrote:
> > 
> > > On vanilla 2.6.29 (on Ubuntu 8.10), on a Lenovo x200s, my system 
> > > is completely hosed on resume.  It appears that even hard disk IO 
> > > didn't work (trying to do *anything* including getting a dmesg 
> > > trace just spewed sda io errors to the console).  Hence no trace.  
> > > I did an alt-sysrq-b and the screen went blank and the machine 
> > > just started beeping at me.
> > > 
> > > Resume works much better with intel_iommu=off.  (I remember seeing 
> > > a patch go by that purported to fix resume with IOMMU enabled, but 
> > > it didn't work for me.)
> > > 
> > > I'd be happy to try to make a better bug report if anyone has any 
> > > bright ideas.
> > 
> > i have a Lenovo T500 that does not even boot with with DMAR enabled 
> > in the BIOS (it's default-off), i get this panic in early bootup:
> > 
> >     DMAR hardware is malfunctioning
> 
> Can you show me the output of the pr_debug() statement at 
> dmar.c:543 (in alloc_iommu()?

that's not easy - i use it right now :)

That's another reason why warnings and non-panic() behavior are 
better for developers too. Had it not crashed i could have sent you 
my dmesg and i would not have turned off DMAR in the BIOS.

Now it's turned off in my BIOS (first barrier) and i need to reboot 
the kernel (second barrier) and i need to hack up a kernel in a 
certain way to produce debug info (third barrier) - in the merge 
window (fourth barrier ;-).

	Ingo
