Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbZLKRea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbZLKRea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 12:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZLKReZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 12:34:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36234 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbZLKReY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 12:34:24 -0500
Date: Fri, 11 Dec 2009 18:34:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alexey Starikovskiy <aystarik@gmail.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Lin Ming <ming.m.lin@intel.com>, Xiaotian Feng <dfeng@redhat.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [PATCH -V2] acpi: don't cond_resched if irq is disabled
Message-ID: <20091211173424.GC15760@elf.ucw.cz>
References: <20091210100907.GA2446@ucw.cz>
 <1260446205-16868-1-git-send-email-dfeng@redhat.com>
 <4B20E7B2.1010208@suse.de>
 <1260510373.10543.17.camel@minggr.sh.intel.com>
 <4B223185.80202@suse.de>
 <20091211161549.GA15760@elf.ucw.cz>
 <4B227275.5010201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B227275.5010201@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> If there are none, fine.
> >>     
> >>> #ifdef CONFIG_PREEMPT
> >>> # define preemptible()  (preempt_count() == 0 && !irqs_disabled())
> >>> # define IRQ_EXIT_OFFSET (HARDIRQ_OFFSET-1)
> >>> #else
> >>> # define preemptible()  0
> >>> # define IRQ_EXIT_OFFSET HARDIRQ_OFFSET
> >>> #endif
> >>>       
> >
> > Well, normally we want low latency even for !CONFIG_PREEMPT kernels.
> >
> > Actually, explicit preemption points are NOPs for CONFIG_PREEMPT
> > kernels, right?

> Right. Do you have code?

I'd prefer to spend my time with patches to areas that actually do
take cleanup patches.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
