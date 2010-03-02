Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab0CBIbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 03:31:52 -0500
Received: from www.tglx.de ([62.245.132.106]:51985 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab0CBIbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 03:31:51 -0500
Date: Tue, 2 Mar 2010 09:31:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Ian Campbell <ijc@hellion.org.uk>, Yinghai Lu <yinghai@kernel.org>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [tip:x86/irq] x86: apic: Fix mismerge, add arch_probe_nr_irqs()
 again
In-Reply-To: <m1iq9fvh40.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1003020930240.4245@localhost.localdomain>
References: <20100207210250.GB8256@jenkins.home.ifup.org> <tip-f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4@git.kernel.org> <4B881097.1050505@kernel.org> <1267442545.11737.20718.camel@zakaz.uk.xensource.com> <m1d3zn7uwl.fsf@fess.ebiederm.org>
 <1267479860.2785.843.camel@localhost.localdomain> <m1iq9fvh40.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Mar 2010, Eric W. Biederman wrote:
> Ian Campbell <ijc@hellion.org.uk> writes:
> > On Mon, 2010-03-01 at 10:34 -0800, Eric W. Biederman wrote:
> It is going to take a bit but our next big step for the irq methods
> is to make them all take struct irq_desc pointers instead of unsigned
> int irq, so we don't have to repeat the lookups.

That should hit 2.6.35.
 
> >> - Xen has an array irq_info[NR_IRQS] one of the last static arrays
> >>   sized at NR_IRQs in the entire kernel.
> >
> > Hopefully the same info as is in that array could (and indeed should) be
> > instead stored in irq_desc->chip_data. Would you object to
> > arch_init_copy_chip_data and arch_free_chip_data becoming function
> > pointers within the struct irq_chip?
> 
> No objections.  Now that I see those methods it looks like they always
> should have been in irq_chip.

Agreed.

Thanks,

	tglx
