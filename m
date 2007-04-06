Return-Path: <linux-kernel-owner+w=401wt.eu-S933297AbXDFXAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297AbXDFXAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933313AbXDFXAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:00:00 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:53445 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297AbXDFW77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:59:59 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 6 Apr 2007 15:59:56 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
In-Reply-To: <Pine.LNX.4.64.0704061542180.6730@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704061555170.8738@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
 <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
 <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com>
 <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru>
 <Pine.LNX.4.64.0704061119090.8738@alien.or.mcafeemobile.com>
 <m1wt0p5o1y.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704061214450.8738@alien.or.mcafeemobile.com>
 <20070406191945.GA18255@elte.hu> <Pine.LNX.4.64.0704061427130.8738@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0704061449231.6730@woody.linux-foundation.org>
 <Pine.LNX.4.64.0704061528190.8738@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0704061542180.6730@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007, Linus Torvalds wrote:

> 
> 
> On Fri, 6 Apr 2007, Davide Libenzi wrote:
> 
> > On Fri, 6 Apr 2007, Linus Torvalds wrote:
> > > 
> > > I don't really see the point. It's not even *true*. A "process" includes 
> > > more than the shared signal-handling - it would include files and fs etc 
> > > too.
> > > 
> > > So it's actually *more* correct to call it the shared signal state than it 
> > > would be to call it "process" state.
> > 
> > But "signal" has *nothing* to do with what the structure store nowadays, 
> > really. It's a pool of "things" that are not Linux task specific.
> 
> You're ignoring reality. It has more to do with signals than with 
> processes. Look at *all* the fields in the top half of the structure, up 
> to (and including) the "tty" field. They're *all* about signal semantics 
> in one form or another (whether it's directly about shared signal 
> behaviour, or indirectly about *sources* of signals like process control 
> or timers).
> 
> And renaming it really has no upsides, even *if* you had a point, which 
> you don't.

OTOH, the other half of the fields has nothing to do with them (signals). 
Not only, the more time it passes, the more ppl (reason why I posted this 
comment in the beginning) sees the "struct signal_struct" has a boilerplate
where to store shared resources.
Chosing a name like "struct task_shared_ctx" fits it, because "signals" 
are *a* task_shared thing, whereas all the fields on the bottom of the 
"struct signal_struct" (on top of the ones that ppl will want to add 
everytime there's somethign to be shared between task structs) are *not* a 
"signal".



- Davide


