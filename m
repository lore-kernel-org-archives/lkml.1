Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbYEYTdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbYEYTdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758462AbYEYTdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:33:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59012 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722AbYEYTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:32:59 -0400
Date: Sun, 25 May 2008 15:32:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arjan van de Ven <arjan@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: enable preemption in delay
In-Reply-To: <20080525115305.79c12c8c@infradead.org>
Message-ID: <Pine.LNX.4.58.0805251530520.25580@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com>
 <20080525115305.79c12c8c@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 25 May 2008, Arjan van de Ven wrote:

> On Sat, 24 May 2008 23:11:20 -0400 (EDT)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > In git commit 35d5d08a085c56f153458c3f5d8ce24123617faf, Andrew Morton
> > placed preempt_disable around the entire delay due to TSC's not
> > working nicely on SMP.  Unfortunately for those that care about
> > latencies this is devastating! Especially when we have callers to
> > mdelay(8).
>
> we used to have a WARN_ON if mdelay was called while preemptable..
> maybe we should put that back in?
>

That would be a good idea, but that wouldn't solve this issue. The issue
here is that the mdelay itself disables preemption. The caller had
preemption enabled.

The problem was caused by a quick fix by Andrew to handle out of sync
TSC's for a delay that used TSC's as a counter.

-- Steve

