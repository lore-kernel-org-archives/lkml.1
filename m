Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYLDEcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYLDEcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 23:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYLDEcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 23:32:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41293 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYLDEcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 23:32:22 -0500
Date: Wed, 3 Dec 2008 23:32:20 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, fweisbec@gmail.com, peterz@infradead.org,
       arjan@infradead.org, dave@linux.vnet.ibm.com, containers@lists.osdl.org,
       sukadev@linux.vnet.ibm.com, serue@us.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH 3/3] ftrace: trace single pid for function graph tracer
In-Reply-To: <m1hc5kvabf.fsf@frodo.ebiederm.org>
Message-ID: <alpine.DEB.1.10.0812032330500.5240@gandalf.stny.rr.com>
References: <20081203203656.776893226@goodmis.org> <20081203203829.362295724@goodmis.org> <20081203124915.2eb9e7cd.akpm@linux-foundation.org> <alpine.DEB.1.10.0812031551360.29045@gandalf.stny.rr.com> <m1y6yw25mq.fsf@frodo.ebiederm.org>
 <alpine.DEB.1.10.0812032125340.28153@gandalf.stny.rr.com> <m1hc5kvabf.fsf@frodo.ebiederm.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Dec 2008, Eric W. Biederman wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > On Wed, 3 Dec 2008, Eric W. Biederman wrote:
> >
> >> Steven Rostedt <rostedt@goodmis.org> writes:
> >> 
> >> The way patch 2 uses pids is just stupid.  It has nothing to do with
> >> pids aren't unique.  You do a full walk of the process list instead
> >> of using the hash table.
> >
> > The way patch 2 uses the pids is stupid, it was just the easiest way to 
> > implement it correctly ;-)  I work with, do it stupid but correct first, 
> > then optimize.
> 
> Which is a reasonable and very unix approach.  As long as I don't need to
> do more than advise about what to do.

No prob. I already wrote the patch and I'm just about ready to post.

> 
> >> It makes me think that task->pid really should go away because with it
> >> there people don't bother to look and see how things normally work.
> >
> > This is far from a fast path, and I can easily fix it. The hard work was 
> > the rest of the patch not this part. I even did it stupid knowing that I 
> > would be rewriting it to handle namespaces. I stated that this needed to 
> > be fixed in the patch itself.
> >
> > One thing I never got an answer for, using the namespace pid path, can I 
> > still select the idle task to trace, i.e. pid == 0.
> 
> Sorry I didn't see this question.  As I recall we have a special pid that
> is not hashed that is used by the idle task.  
> 
> So it should be possible but it would need to be a special case.  Although
> please note we have one idle task per cpu.

Yep, I'm almost finish with this patch. It is a special case.

> 
> Is the idle task doing anything interesting enough to warrant tracing?
> We don't report the idle tasks in proc or in any of our other user space
> interfaces.

Yes, because we can see what wakes things up from idle. That is, if we 
trace the idle task, we can trace the interrupts that happen while the CPU 
is idle.

Thanks,

-- Steve

