Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbXEQKGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbXEQKGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 06:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbXEQKGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 06:06:18 -0400
Received: from www.osadl.org ([213.239.205.134]:59972 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754305AbXEQKGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 06:06:18 -0400
Subject: Re: bug seen with dynticks from CONFIG_HARDIRQS_SW_RESEND
From: Thomas Gleixner <tglx@linutronix.de>
To: "Woodruff, Richard" <r-woodruff2@ti.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com>
References: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com>
Content-Type: text/plain
Date: Thu, 17 May 2007 12:10:59 +0200
Message-Id: <1179396659.3764.40.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 18:20 -0500, Woodruff, Richard wrote:
> The crashes were because the frame pointer per_cpu____irq_regs value was
> 0.  That code does a user_mode(get_irq_regs()).  Currently regs is set
> only upon real hardware entry on an irq.
> 
> The crash path shows resend_irqs() could be called with in a context
> where set_irq_regs() was not executed.  In one specific case this was
> from
> softirq->tasklet_action(resend_tasklet)->resend_irqs->handle_level_irq->
> handle_IRQ_event->...->profile_tick.
> 
> It seems anyone calling kernel/irq/manage.c:enable_irq() at the wrong
> time can trigger this crash.

which code is disabling / enabling the timer interrupt ?

	tglx


