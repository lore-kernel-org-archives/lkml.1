Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbXJHPIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbXJHPIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 11:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbXJHPIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 11:08:06 -0400
Received: from www.tglx.de ([62.245.132.106]:59768 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbXJHPIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 11:08:05 -0400
Date: Mon, 8 Oct 2007 17:07:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh <jaswinderlinuxrt@gmail.com>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.23-rc9-rt2
In-Reply-To: <1985e0f60710080734y4897a8e1ke253b6d4273146ec@mail.gmail.com>
Message-ID: <alpine.LFD.0.9999.0710081644230.25146@localhost.localdomain>
References: <1191536413.5210.19.camel@localhost.localdomain>  <1985e0f60710070635l7016bad1t9c4d4cb1a966534f@mail.gmail.com>  <Pine.LNX.4.58.0710080951270.4846@gandalf.stny.rr.com> <1985e0f60710080734y4897a8e1ke253b6d4273146ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2007, Jaswinder Singh wrote:
> On 10/8/07, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Not sure what you mean by this, since interrupt handlers are run as
> > threads and are fully preemptible.
> >
> I think by nested or reentrant interrupt handling technique you can
> further reduce latencies.
> what you think.

Interrupt handlers in vanilla Linux and preempt-rt are never reentrant. 
There is no advantage of allowing interrupt handler reentrancy, quite the 
contrary it makes the code more complex.

The interrupt handlers in preempt-rt are running in threads. One thread 
per interrupt, so depending on the thread priority the handlers a handler 
of one interrupt can preempt the running handler of another interrupt.

> Can we can get guaranteed realtime throughput by using these realtime patch.

Realtime is not about throughput. It's about determinism.

	tglx
