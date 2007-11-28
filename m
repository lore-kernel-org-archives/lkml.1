Return-Path: <linux-kernel-owner+w=401wt.eu-S932116AbXK1VTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbXK1VTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761544AbXK1VSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:18:00 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:56254 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758947AbXK1VR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:17:58 -0500
Date: Wed, 28 Nov 2007 16:13:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Remy Bohmer <linux@bohmer.net>, RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling can/will
 stall forever
In-Reply-To: <1196282672.27964.32.camel@imap.mvista.com>
Message-ID: <Pine.LNX.4.58.0711281608490.26365@gandalf.stny.rr.com>
References: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com> 
 <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com> 
 <1196176294.13982.58.camel@localhost.localdomain>  <1196177122.23808.7.camel@imap.mvista.com>
  <1196178834.23808.11.camel@imap.mvista.com> 
 <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com> 
 <20071128172509.GA30173@flint.arm.linux.org.uk> 
 <Pine.LNX.4.58.0711281402210.3341@gandalf.stny.rr.com> 
 <20071128200550.GA3494@flint.arm.linux.org.uk> 
 <Pine.LNX.4.58.0711281510580.4247@gandalf.stny.rr.com>
 <1196282672.27964.32.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Nov 2007, Daniel Walker wrote:

>
> Ignoring the ARM side of things for a sec, handle_simple_irq() will
> mask() the interrupt in the special case that an interrupt is already in
> the processes of being handled.. handle_simple_irq() also unmasks when
> it finishes handling an interrupt (something real time adds for some
> reason) ..
>
> In terms of threading the irq everything is the same except there is no
> unmask() call when the thread finishes ..
>

OK, to be honest, I never fully understood the concept of this
"simple_irq". I figured it was because of the ARM architecture.

Your arguments seem reasonable and you are probably correct. But I didn't
write this code, nor do I understand it, and before I go ahead and change
it, I'll wait to hear input from Thomas. Hopefully, he'll be back soon.

Perhaps my confusion about the simple_irq part is from the bug you are
trying to fix. I've been confused by why it was different ;-)

-- Steve

