Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYJ0P3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYJ0P3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbYJ0P3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:29:42 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37735 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751539AbYJ0P3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:29:41 -0400
Date: Mon, 27 Oct 2008 10:29:40 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] SGI RTC: add RTC system interrupt
Message-ID: <20081027152940.GA14567@sgi.com>
References: <20081023163041.GA14574@sgi.com> <20081023163223.GA14815@sgi.com> <20081023163414.GB14815@sgi.com> <20081024031127.GA25165@sgi.com> <20081027140829.GD5704@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027140829.GD5704@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 03:08:29PM +0100, Ingo Molnar wrote:
> 
> * Dimitri Sivanich <sivanich@sgi.com> wrote:
> 
> > +void uv_rtc_timer_interrupt(struct pt_regs *regs)
> > +{
> > +	struct pt_regs *old_regs = set_irq_regs(regs);
> > +
> > +	ack_APIC_irq();
> > +
> > +	exit_idle();
> > +
> > +	irq_enter();
> > +
> > +	if (uv_rtc_interrupt_extension)
> > +		uv_rtc_interrupt_extension();
> > +
> > +	irq_exit();
> > +
> > +	set_irq_regs(old_regs);
> > +}
> 
> hm, the exit_idle() looks weird - why is it done? If we get an IRQ 
> then the CPU will exit idle state anyway.

Ingo,

I'm not quite sure what you mean here.  Are you referring to an explicit call to exit_idle() that is done somewhere else (such as do_IRQ())?
