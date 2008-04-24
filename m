Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbYDXKy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbYDXKy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 06:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYDXKyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 06:54:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58613 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbYDXKyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 06:54:04 -0400
Message-ID: <481066C1.1030805@garzik.org>
Date: Thu, 24 Apr 2008 06:53:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [git patch] free_irq() fixes
References: <20080422221733.GA16260@havoc.gtf.org>	<alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org>	<480E6DE5.6010103@garzik.org>	<alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org>	<480E796E.4070001@garzik.org>	<alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org>	<20080423000529.GG28933@cs181133002.pp.htv.fi>	<alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org>	<480F3ECC.1090809@keyaccess.nl> <480FEC1B.6040102@garzik.org>	<alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org> <m1od7zkd2s.fsf@frodo.ebiederm.org>
In-Reply-To: <m1od7zkd2s.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I haven't looked at what Jeff's patches in particular so I can not
> comment there.  I do remember looking at the drivers in question and
> yes there were indeed bugs with the handful of drivers that used
> the irq parameter.  So fixing and cleaning up those drivers so they
> use the same idioms as the rest of the kernel should be a maintenance
> win.  Even if we do keep the irq parameter to the interrupt handler.
> 
> I can comment on where there seems to be a real need for change.
> The hard coded NR_IRQS parameter and the arrays of size NR_IRQS are a
> kernel scaling bottle neck.  They prevents us from building one kernel
> that works well on a large ranges of machines sizes.  Having a single
> array prevents us from allocating the irq structures with NUMA
> affinity which slows down irq processing.  Having a small number for
> NR_IRQS to keep the table compact keeps the irq number from being
> readable/useful in the case of MSI and occasionally in the case of
> IO_APICs.


Honestly, one thing I was thinking was perhaps a change from

	irqreturn_t foo_handler(int irq, void *dev_id)
to
	irqreturn_t foo_handler(struct irq_info *ii, void *dev_id)

which would IMO make the first parameter useful again, by enabling 
passing of information like MSI message info, or more flexible 
platform-specific irq info that a platform driver may want.  Or direct 
access to irq_desc or irq_chip info.

	Jeff



