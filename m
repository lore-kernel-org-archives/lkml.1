Return-Path: <linux-kernel-owner+w=401wt.eu-S1762245AbXK2KZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762245AbXK2KZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbXK2KZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:25:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55621 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024AbXK2KZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:25:44 -0500
Date: Thu, 29 Nov 2007 10:25:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Remy Bohmer <linux@bohmer.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, Daniel Walker <dwalker@mvista.com>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling can/will stall forever
Message-ID: <20071129102506.GB22793@flint.arm.linux.org.uk>
References: <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com> <1196176294.13982.58.camel@localhost.localdomain> <1196177122.23808.7.camel@imap.mvista.com> <1196178834.23808.11.camel@imap.mvista.com> <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com> <20071128172509.GA30173@flint.arm.linux.org.uk> <Pine.LNX.4.58.0711281402210.3341@gandalf.stny.rr.com> <20071128200550.GA3494@flint.arm.linux.org.uk> <Pine.LNX.4.58.0711281510580.4247@gandalf.stny.rr.com> <3efb10970711290214v37d85a27k9a84876d9099d7c5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3efb10970711290214v37d85a27k9a84876d9099d7c5@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 11:14:30AM +0100, Remy Bohmer wrote:
> I do not think Russell is right here with assuming that the wrong
> interrupt handler type is used. Looking at the behaviour of the
> mainline kernel (non-RT), the implementation is quite different: On
> mainline the handle_simple_irq() in chip.c is not re-entrant, the
> masking is **only** done in case of errors, and therefor never
> unmasked again, of course.

The issue comes down to a very simple question:

  Are you using handle_simple_irq() with an interrupt which can be masked?

If the answer to that question is 'yes' then you're using the wrong handler.
If 'no' then it's the right handler and the mask/unmask methods associated
with the interrupt will be no-ops.

Therefore, if you have mask/unmask methods for a simple IRQ which actually
do something, clearly the first answer is the one which applies.  You're
using the wrong handler.  Use the level or edge handlers instead.
