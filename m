Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZHBVJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZHBVJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbZHBVJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:09:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753624AbZHBVJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:09:16 -0400
Date: Sun, 2 Aug 2009 14:08:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: paulmck@linux.vnet.ibm.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/debug] debug lockups: Improve lockup detection
Message-Id: <20090802140809.7ec4bb6b.akpm@linux-foundation.org>
In-Reply-To: <20090802204150.GB3986@elte.hu>
References: <tip-c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc@git.kernel.org>
	<20090802114545.f1520c81.akpm@linux-foundation.org>
	<20090802192657.GA21882@elte.hu>
	<20090802123958.cbd497a0.akpm@linux-foundation.org>
	<20090802204150.GB3986@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Aug 2009 22:41:50 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sun, 2 Aug 2009 21:26:57 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > I think this just broke all non-x86 non-sparc SMP architectures.
> > > 
> > > Yeah - it 'broke' them in the sense of them not having a working 
> > > trigger_all_cpu_backtrace() implementation to begin with.
> > 
> > c'mon.  It broke them in the sense that sysrq-l went from "works" 
> > to "doesn't work".
> 
> You are right (i broke it with my patch) but the thing is, sysrq-l 
> almost useless currently: it uses schedule_work() which assumes a 
> mostly working system with full irqs and scheduling working fine. 
> Now, i dont need sysrq-l on mostly working systems.
> 
> So the 'breakage' is of something that was largely useless: and now 
> you put the onus of implementing it for _all_ architectures (which i 
> dont use) on me?

I never said that.

It's appropriate that those architectures be left with their existing
level of functionality/usefulness, as you're already discussing.

> > It's better to break the build or to emit warnings than to 
> > silently and secretly break their stuff.
> 
> But that warning will bounce the ball back to me, wont it? My patch 
> will be blamed for 'breaking' those architectures, right?

It's a very crude and somewhat rude way of communicating information to
other architecture maintainers.

A better way would be to send them an email explaining the problem and
outlining some solutions, no?
