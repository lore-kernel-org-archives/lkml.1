Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbYIYRwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbYIYRwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYIYRw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:52:28 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:5433 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbYIYRw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:52:26 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Subject: Re: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Date: Thu, 25 Sep 2008 11:52:22 -0600
User-Agent: KMail/1.9.9
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Len Brown" <lenb@kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com> <200809250900.24736.bjorn.helgaas@hp.com> <86802c440809251007n71738552n88b8ebfc7ecd017f@mail.gmail.com>
In-Reply-To: <86802c440809251007n71738552n88b8ebfc7ecd017f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809251152.23021.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2008 11:07:17 am Yinghai Lu wrote:
> On Thu, Sep 25, 2008 at 8:00 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > On Thursday 25 September 2008 12:13:43 am Yinghai Lu wrote:
> >> v2: fix hpet compiling
> >>
> >> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >> ---
> >>  arch/x86/kernel/hpet.c    |    3 +++
> >>  arch/x86/kernel/io_apic.c |    7 +++++++
> >>  2 files changed, 10 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> >> index 422c577..686505a 100644
> >> --- a/arch/x86/kernel/hpet.c
> >> +++ b/arch/x86/kernel/hpet.c
> >> @@ -467,6 +467,9 @@ static int hpet_setup_irq(struct hpet_dev *dev)
> >>       irq_set_affinity(dev->irq, cpumask_of_cpu(dev->cpu));
> >>       enable_irq(dev->irq);
> >>
> >> +     printk(KERN_DEBUG "hpet: %s is using irq %#x aka %d for MSI\n",
> >> +                      dev->name, dev->irq, dev->irq);
> >> +
> >
> > Why do we want to print the irq as hex?  Do we do that anywhere else?
> > I think we should pick one format and stick with it, and I think
> > decimal is the logical choice because it's the most common.
> 
> when sparseirq is enabled, irq for msi will be bus_nr/dev/func + 12bits.
> so show it as hex is more straight. but we can not use hex in
> /proc/interrupts --ABI want decimal.
> 
> just try to print out...in log, so user could get some idea that who
> is using it...

I think it'd be better to just print the MSI IRQ number in decimal
using a dev_printk().  Then the connection is obvious and we don't
need to make everything ugly by having IRQs in both decimal and hex.

I know it's a nuisance to make hpet use dev_printk because it's
pretty muddled as far as getting a struct device.  But I'd rather
fix that than add confusion like this.

Bjorn
