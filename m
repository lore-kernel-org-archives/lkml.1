Return-Path: <linux-kernel-owner+w=401wt.eu-S1760419AbXHQHpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419AbXHQHpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbXHQHpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:45:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:30940 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbXHQHo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=onoiotXQZitF9kELkrxmGCD60gqkVRC0sSWU3izNNZ0ePU+nTY+nq+N4r/yI124IH9WGJRcdqOCQTxr3Q4Z6n1uMFGQMlz8T2An4sh7unOF7NxqRyhGmMgyjNpD1VbqaEDMu1sdqJHlQf4N6yUhaNQsQmpUhBgzbypCFUofyIYM=
Message-ID: <f40fb4250708170044q9a259c3wb50186880d6b7f51@mail.gmail.com>
Date: Fri, 17 Aug 2007 11:44:57 +0400
From: GolovaSteek <golovasteek@gmail.com>
To: "Michal Schmidt" <xschmi00@stud.feec.vutbr.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: nanosleep() accuracy
In-Reply-To: <46C54787.1010909@stud.feec.vutbr.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f40fb4250708161552ub87bf8ve8168eec1b3955e7@mail.gmail.com>
	 <46C54787.1010909@stud.feec.vutbr.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/17, Michal Schmidt <xschmi00@stud.feec.vutbr.cz>:
> GolovaSteek skrev:
> > Hello!
> > I need use sleep with accurat timing.
> > I use 2.6.21 with rt-prempt patch.
> > with enabled rt_preempt, dyn_ticks, and local_apic
> > But
> >
> > req.tv_nsec = 300000;
> > req.tv_sec = 0;
> > nanosleep(&req,NULL)
> >
> > make pause around 310-330 microseconds.
>
> How do you measure this?
> If you want to have something done every 300 microseconds, you must not
> sleep for 300 microseconds in each iteration, because you'd accumulate
> errors. Use a periodic timer or use the current time to compute how long
> to sleep in each iteration. Take a look how cyclictest does it.

no. I just want my programm go to sleep sometimes and wake up in correct time.

> > I tried to understend how work nanosleep(), but it not depends from
> > jiffies and from smp_apic_timer_interrupt.
> >
> > When can accuracy be lost?
> > And how are process waked up?
> >
> >
> > GolovaSteek
>
> Don't forget the process will always have non-zero wakeup latency. It
> takes some time to process an interrupt, wakeup the process and schedule
> it to run on the CPU. 10-30 microseconds is not unreasonable.

But 20000 operations can be done in 10 microseconds?
and why is there that inconstancy? Why sametimes 10 and sometimes 30?
In which points of implementation it happens?

GolovaSteek
