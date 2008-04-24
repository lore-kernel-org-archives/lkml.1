Return-Path: <linux-kernel-owner+w=401wt.eu-S1761117AbYDXRb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761117AbYDXRb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760538AbYDXRbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:31:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:32820 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760380AbYDXRbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:31:07 -0400
Message-ID: <4810C3B5.3020605@garzik.org>
Date: Thu, 24 Apr 2008 13:30:29 -0400
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
References: <20080422221733.GA16260@havoc.gtf.org>	<alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org>	<480E6DE5.6010103@garzik.org>	<alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org>	<480E796E.4070001@garzik.org>	<alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org>	<20080423000529.GG28933@cs181133002.pp.htv.fi>	<alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org>	<480F3ECC.1090809@keyaccess.nl> <480FEC1B.6040102@garzik.org>	<alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org>	<m1od7zkd2s.fsf@frodo.ebiederm.org> <481066C1.1030805@garzik.org>	<alpine.LFD.1.10.0804240806500.2779@woody.linux-foundation.org>	<4810A9E6.1080201@garzik.org>	<alpine.LFD.1.10.0804240847230.2779@woody.linux-foundation.org> <m1r6cvgpw2.fsf@frodo.ebiederm.org>
In-Reply-To: <m1r6cvgpw2.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Even if we never export them to drivers we will need to implement
> in genirq functions like:
> 
> int __must_check irq_request(struct irq_desc *irq, irq_handler_t handler,
> 	 unsigned long irqflags, const char *devname, void *devid);
>         	
> int __must_check request_irq(unsigned int irq, irq_handler_t handler,
> 	unsigned long irqflags, const char *devname, void *devid)
> {
>         return irq_request(cookie_to_desc(irq), handler, irqflags, devname, devid);
> }
> 
> Or at the very least do the mapping from cookie to irq_desc at the
> start of all of the genirq functions.  One valid implementation of
> that cookie to desc will be the current array lookup.  But for x86
> we need something less limiting.
[...]
> And on x86 at least the hardware maps the MSI write into an interrupt.
> So there is not an opportunity to get any metdata/OOB data from the
> MSI message.  Instead we just potentially get a boatload more irq
> sources.  Which is one of the things making a static NR_IRQS painful.
> 
> To be safe we have to make NR_IRQS 10x+ or so bigger then people use
> today.  Just in case they decide to plug in some really irq hungry
> cards.


Just to be clear, irq_chip/irq_desc and metadata/OOB data are two very 
different beasts.  irq_chip/irq_desc is more a system attribute as Linus 
notes.  Also, it doesn't change very often.

metadata/OOB, on the other hand, is different -for each interrupt-, and 
is highly relevant to drivers.  Thus should be part of the driver API 
somehow.

	Jeff


