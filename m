Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbYEYTaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbYEYTaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbYEYTaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:30:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45401 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602AbYEYTaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:30:09 -0400
Date: Sun, 25 May 2008 12:28:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: enable preemption in delay
Message-ID: <20080525122808.54f5026e@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0805252100120.3295@apollo.tec.linutronix.de>
References: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com>
	<20080525115305.79c12c8c@infradead.org>
	<alpine.LFD.1.10.0805252100120.3295@apollo.tec.linutronix.de>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008 21:01:32 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sun, 25 May 2008, Arjan van de Ven wrote:
> 
> > On Sat, 24 May 2008 23:11:20 -0400 (EDT)
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > In git commit 35d5d08a085c56f153458c3f5d8ce24123617faf, Andrew
> > > Morton placed preempt_disable around the entire delay due to
> > > TSC's not working nicely on SMP.  Unfortunately for those that
> > > care about latencies this is devastating! Especially when we have
> > > callers to mdelay(8).
> > 
> > we used to have a WARN_ON if mdelay was called while preemptable..
> > maybe we should put that back in?
> 
> We'd better have one which warns, when mdelay is called with
> preemption disabled.

argument for my variant was "should have used msleep instead"...

I don't disagree that mdelay() is harmful in general; at some point I
stuck a WARN_ON in mdelay when called from irq context...
