Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYFMNIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYFMNIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 09:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758374AbYFMNIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 09:08:20 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:11243 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbYFMNIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 09:08:12 -0400
X-SourceIP: 80.56.237.116
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize non-migratable
	tasks over migratable ones"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>
References: <1213138710.26530.51.camel@earth>
	 <1213174382.31518.69.camel@twins>
	 <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 13 Jun 2008 15:08:04 +0200
Message-Id: <1213362484.16944.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-11 at 12:05 +0200, Dmitry Adamushko wrote:
> 2008/6/11 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> > On Wed, 2008-06-11 at 00:58 +0200, Dmitry Adamushko wrote:
> >> Hi Gregory,
> >>
> >>
> >> regarding this commit: 45c01e824991b2dd0a332e19efc4901acb31209f
> >>
> >>
> >> I think we can do it simpler. Please take a look at the patch below.
> >>
> >> Instead of having 2 separate arrays (which is + ~800 bytes on x86_32 and twice so on x86_64),
> >> let's add "exclusive" (the ones that are bound to this CPU) tasks to the head of the queue
> >> and "shared" ones -- to the end.
> >>
> >> In case of a few newly woken up "exclusive" tasks, they are 'stacked' (not queued as now), meaning that
> >> a task {i+1} is being placed in front of the previously woken up task {i}. But I don't think that
> >> this behavior may cause any realistic problems.
> >
> > Doesn't this violate POSIX ?
> >
> 
> If so, then the idea of "prioritize non-migratable tasks over
> migratable ones" violates it, not just an artefact of this particular
> implementation.
> 
> No matter which implementation is used, we have a situation when a
> woken-up single-CPU-bound task (let's call it 'p') can preempt a
> current task with effects as follows:
> 
> - 'current' is not guaranteed to get another CPU;
> 
> - there might have been other pending tasks (of equal prio) on this
> queue. As a result, 'p' starts running before them violating currently
> used (explicitly requested by POSIX?) round-robin behavior.

> We may just consider dropping this idea completely.
> (my 0.02$)

If we cannot guarantee POSIX compliant scheduling I think we should get
rid of this.

