Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbZAFQ2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbZAFQ2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZAFQ2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:28:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45996 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZAFQ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:28:12 -0500
Date: Tue, 6 Jan 2009 11:28:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
In-Reply-To: <alpine.LFD.2.00.0901060808260.3057@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0901061125340.10871@gandalf.stny.rr.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>
 <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu> <alpine.LFD.2.00.0901060750410.3057@localhost.localdomain> <alpine.LFD.2.00.0901060808260.3057@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 6 Jan 2009, Linus Torvalds wrote:
> Btw, I hate the name of the helper function for that. "task_is_current()"? 
> "current" means something totally different in the linux kernel: it means 
> that the task is _this_ task.
> 
> So the only sensible implementation of "task_is_current(task)" is to just 
> make it return "task == current", but that's obviously not what the 
> function wants to do.
> 
> So it should be renamed. Something like "task_is_oncpu()" or whatever.
> 
> I realize that the scheduler internally has that whole "rq->curr" thing, 
> but that's an internal scheduler thing, and should not be confused with 
> the overall kernel model of "current".

I totally agree that we should change the name of that. I never thought 
about the confusion that it would cause to someone that is not working so 
heavy on the scheduler. Thanks for the perspective.

Sometimes us scheduler guys have our heads too much up the scheduler ass 
that all we see is scheduler crap ;-)

-- Steve

