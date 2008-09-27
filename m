Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbYI0Sxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbYI0Sxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYI0SxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:53:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39349 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbYI0SxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:53:20 -0400
Date: Sat, 27 Sep 2008 20:53:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Message-ID: <20080927185306.GA18619@elte.hu>
References: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com> <200809250900.24736.bjorn.helgaas@hp.com> <86802c440809251007n71738552n88b8ebfc7ecd017f@mail.gmail.com> <200809251152.23021.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809251152.23021.bjorn.helgaas@hp.com>
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


* Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Thursday 25 September 2008 11:07:17 am Yinghai Lu wrote:
> > On Thu, Sep 25, 2008 at 8:00 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > On Thursday 25 September 2008 12:13:43 am Yinghai Lu wrote:
> > >> v2: fix hpet compiling
> > >>
> > >> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> > >> ---
> > >>  arch/x86/kernel/hpet.c    |    3 +++
> > >>  arch/x86/kernel/io_apic.c |    7 +++++++
> > >>  2 files changed, 10 insertions(+), 0 deletions(-)
> > >>
> > >> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> > >> index 422c577..686505a 100644
> > >> --- a/arch/x86/kernel/hpet.c
> > >> +++ b/arch/x86/kernel/hpet.c
> > >> @@ -467,6 +467,9 @@ static int hpet_setup_irq(struct hpet_dev *dev)
> > >>       irq_set_affinity(dev->irq, cpumask_of_cpu(dev->cpu));
> > >>       enable_irq(dev->irq);
> > >>
> > >> +     printk(KERN_DEBUG "hpet: %s is using irq %#x aka %d for MSI\n",
> > >> +                      dev->name, dev->irq, dev->irq);
> > >> +
> > >
> > > Why do we want to print the irq as hex?  Do we do that anywhere else?
> > > I think we should pick one format and stick with it, and I think
> > > decimal is the logical choice because it's the most common.
> > 
> > when sparseirq is enabled, irq for msi will be bus_nr/dev/func + 12bits.
> > so show it as hex is more straight. but we can not use hex in
> > /proc/interrupts --ABI want decimal.
> > 
> > just try to print out...in log, so user could get some idea that who
> > is using it...
> 
> I think it'd be better to just print the MSI IRQ number in decimal
> using a dev_printk().  Then the connection is obvious and we don't
> need to make everything ugly by having IRQs in both decimal and hex.
> 
> I know it's a nuisance to make hpet use dev_printk because it's
> pretty muddled as far as getting a struct device.  But I'd rather
> fix that than add confusion like this.

incidentally, in tip/timers/hpet-percpu [ new feature tree: MSI HPETs 
with per-CPU clockevents ] we have grown a struct device in that place, 
so it was easy :)

	Ingo
