Return-Path: <linux-kernel-owner+w=401wt.eu-S1751388AbZLKQP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbZLKQP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932799AbZLKQPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:15:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54745 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbZLKQPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:15:52 -0500
Date: Fri, 11 Dec 2009 17:15:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Lin Ming <ming.m.lin@intel.com>, Xiaotian Feng <dfeng@redhat.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [PATCH -V2] acpi: don't cond_resched if irq is disabled
Message-ID: <20091211161549.GA15760@elf.ucw.cz>
References: <20091210100907.GA2446@ucw.cz>
 <1260446205-16868-1-git-send-email-dfeng@redhat.com>
 <4B20E7B2.1010208@suse.de>
 <1260510373.10543.17.camel@minggr.sh.intel.com>
 <4B223185.80202@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B223185.80202@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-12-11 14:48:21, Alexey Starikovskiy wrote:
> Lin Ming ??????????:
> > On Thu, 2009-12-10 at 20:21 +0800, Alexey Starikovskiy wrote:
> >> Hi Xiaotian,
> >>
> >> I think, this is another round of "armor vs. bullet" race... It will hold until
> >> might_sleep() logic changes again.
> >>
> >> Please consider using preemptible() -- IMHO this is the check we should perform 
> >> in our case of voluntary preemption.
> > 
> > preemptible() may not work here because it always returns 0 for
> > non-preemptible kernel.
> Right, and it means that this machine does not care about low latency that much.
> The reason we introduced the preemption point in the first place, was unacceptable latency
> due to very long AML methods on some machines. We don't need this preemption point for normal
> operation, this is exactly what voluntary preemption does -- allows those in hurry to pass by.
> If there are none, fine.
> > 
> > #ifdef CONFIG_PREEMPT
> > # define preemptible()  (preempt_count() == 0 && !irqs_disabled())
> > # define IRQ_EXIT_OFFSET (HARDIRQ_OFFSET-1)
> > #else
> > # define preemptible()  0
> > # define IRQ_EXIT_OFFSET HARDIRQ_OFFSET
> > #endif

Well, normally we want low latency even for !CONFIG_PREEMPT kernels.

Actually, explicit preemption points are NOPs for CONFIG_PREEMPT
kernels, right?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
