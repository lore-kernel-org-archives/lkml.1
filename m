Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbYJ1SaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbYJ1SaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYJ1S36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:29:58 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37851 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751341AbYJ1S35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:29:57 -0400
Date: Tue, 28 Oct 2008 14:29:52 -0400
From: Theodore Tso <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC] trace: profile likely and unlikely annotations
Message-ID: <20081028182952.GB10862@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Mike Snitzer <snitzer@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com> <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com> <20081028001340.GB9797@mit.edu> <alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com> <20081028143720.GD8869@mit.edu> <alpine.DEB.1.10.0810281045040.29482@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810281045040.29482@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 10:49:16AM -0400, Steven Rostedt wrote:
> 
> OK, I'm fine with changing the terminology. v2 will do:
> 
>   s/hit/True/
>   s/missed/False/
> 
> Fine with you?

I'm OK with either that, or with Arjan's suggestion of "Correct" and
"Incorrect" --- although that would changing a line in the definition
of #define unlikely(x):

                    ftrace_likely_update(&______f, !______r);

Either "True" / "False" or "Correct" / "Incorrect" has the advantage
of being unambiguous.  "Correct" / "Incorrect" has the advantage that
people don't have to think about the fact that for
/proc/profile_unlikely, high numbers of "False" is a good thing, where
as for /proc/profile_likely, high numbers of "True" is a good thing.
With "Correct" / "Incorrect" it's easier to undersatnd that high
numbers of "Correct" is good.   

So I can see why Arjan suggested Correct/Incorrect, although I can
live with either.

							- Ted
