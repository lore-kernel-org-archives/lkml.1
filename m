Return-Path: <linux-kernel-owner+w=401wt.eu-S933267AbXDFWrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbXDFWrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933286AbXDFWrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:47:04 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36455 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933267AbXDFWrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:47:03 -0400
Date: Fri, 6 Apr 2007 15:46:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
In-Reply-To: <Pine.LNX.4.64.0704061528190.8738@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0704061542180.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
 <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
 <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com>
 <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru>
 <Pine.LNX.4.64.0704061119090.8738@alien.or.mcafeemobile.com>
 <m1wt0p5o1y.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704061214450.8738@alien.or.mcafeemobile.com>
 <20070406191945.GA18255@elte.hu> <Pine.LNX.4.64.0704061427130.8738@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0704061449231.6730@woody.linux-foundation.org>
 <Pine.LNX.4.64.0704061528190.8738@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 6 Apr 2007, Davide Libenzi wrote:

> On Fri, 6 Apr 2007, Linus Torvalds wrote:
> > 
> > I don't really see the point. It's not even *true*. A "process" includes 
> > more than the shared signal-handling - it would include files and fs etc 
> > too.
> > 
> > So it's actually *more* correct to call it the shared signal state than it 
> > would be to call it "process" state.
> 
> But "signal" has *nothing* to do with what the structure store nowadays, 
> really. It's a pool of "things" that are not Linux task specific.

You're ignoring reality. It has more to do with signals than with 
processes. Look at *all* the fields in the top half of the structure, up 
to (and including) the "tty" field. They're *all* about signal semantics 
in one form or another (whether it's directly about shared signal 
behaviour, or indirectly about *sources* of signals like process control 
or timers).

And renaming it really has no upsides, even *if* you had a point, which 
you don't.

			Linus
