Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968131Ab0B0JxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:53:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49856 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968104Ab0B0JxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:53:22 -0500
Date: Sat, 27 Feb 2010 10:53:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/irq] x86: apic: Fix mismerge, add arch_probe_nr_irqs()
 again
Message-ID: <20100227095313.GG31794@elte.hu>
References: <20100207210250.GB8256@jenkins.home.ifup.org>
 <tip-f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4@git.kernel.org>
 <4B881097.1050505@kernel.org>
 <20100227091043.GA31794@elte.hu>
 <m1wrxzqarz.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wrxzqarz.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> >
> >> 
> >> for x86, with radix tree based irq_to_desc(),
> >> removing arch_probe_nr_irqs is intentional. so we get more irq that could be used.
> >> 
> >> wonder if the udev for some of your test system have irq number limitation?
> >
> > was ancient udev: udev-095-17.fc6.
> 
> Something doesn't add up.  Nowhere in the udev source is there a
> single mention of irq.
> 
> gsi have fixed interrupt numbers so that would not change.
> 
> The dynamic irqs are allocated starting from the high gsi
> and working up.
> 
> The irq numbers that get allocated should not have changed,
> unless this was actually a bug fix in this configuration.
> 
> The other possibility is that somehow arch_probe_nr_irqs()
> was returning a number greater than NR_IRQS.
> 
> Ingo do you have any idea what NR_IRQS or nr_irqs were/are on
> that failing machine?

Sorry, not - and the merge window doesnt leave much time to revisit the 
problem right now.

But the failures were very real and 100% caused by this: they resulted in 
non-existent /dev/sda* nodes and resulting fsck failure by rc.

Thanks,

	Ingo
