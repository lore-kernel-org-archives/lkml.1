Return-Path: <linux-kernel-owner+w=401wt.eu-S1759141AbXK0QBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141AbXK0QBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbXK0QBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:01:41 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:44120 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbXK0QBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:01:40 -0500
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling
	can/will stall forever
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Remy Bohmer <linux@bohmer.net>
In-Reply-To: <1196177122.23808.7.camel@imap.mvista.com>
References: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com>
	 <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com>
	 <1196176294.13982.58.camel@localhost.localdomain>
	 <1196177122.23808.7.camel@imap.mvista.com>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 07:53:54 -0800
Message-Id: <1196178834.23808.11.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-27 at 07:25 -0800, Daniel Walker wrote:
> On Tue, 2007-11-27 at 10:11 -0500, Steven Rostedt wrote:
> > Thomas,
> > 
> > Can you ACK or NACK this patch.  I know you play with a bunch of
> > hardware that this patch may affect.
> > 
> 
> My two cents, I think it's needed (or something like it).. It looks like
> handle_simple_irq normally expects a custom cascade type handler to
> unmask on return. When you switch to a threaded handler the cascade
> handler is gone and can't unmask..

I take this back .. The comment at the top of handle_simple_irq() is,

 *      Note: The caller is expected to handle the ack, clear, mask and
 *      unmask issues if necessary.


So we shouldn't need any flow control unless there is some other
factors.. 

Additionally, we have a patch in the real time tree called
"irq-mask-fix.patch" which adds an "unmask" to handle_simple_irq, but as
the note says we don't need flow control..

Daniel

