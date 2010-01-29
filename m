Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733Ab0A2Hjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0A2Hjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773Ab0A2Hjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:39:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47095 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab0A2Hjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:39:45 -0500
Date: Fri, 29 Jan 2010 08:39:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tom Tromey <tromey@redhat.com>, Kyle Moffett <kyle@moffetthome.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100129073907.GF14636@elte.hu>
References: <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
 <m33a1tnbd9.fsf@fleche.redhat.com>
 <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
 <m3636oh2rt.fsf@fleche.redhat.com>
 <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
 <1264575134.4283.1983.camel@laptop>
 <20100127085442.GA28422@elte.hu>
 <1264643539.5068.62.camel@localhost.localdomain>
 <20100128085502.GA7713@elte.hu>
 <1264726768.4933.50.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264726768.4933.50.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jim Keniston <jkenisto@us.ibm.com> wrote:

> > > As previously discussed, boosting would also get rid of the single-step 
> > > trap for most instructions.
> > 
> > Boosting is not in the uprobes patch-set you submitted. Even with it 
> > present it wont get rid of the initial INT3. So basically _best-case_ 
> > (with boosting) XOL-uprobes could roughly break even with a pure emulator 
> > approach ...
> > 
> > That's a big and fundamental difference.
> 
> To be fair, wrt uprobes, emulation and boosting are both in the same state: 
> pretty well understood, but not yet implemented.

So, to sum it up: utrace XOL, which is rather complex already, needs even more 
complexity (which is not yet implemented) than the much simpler common-case 
emulator approach i outlined, just to break even with the performance of the 
much simpler approach.

And you've been justifying the complexity of XOL with its performance 
advantages.

See why i'm unimpressed by that argument?

[ Note, i'm not dismissing it entirely, the complexity of XOL _might_ be fine
  in the future if it brings us real advantages: for example if it avoids
  _ALL_ kernel entries.

  That can be done too, by using the jump-probe technique in user-space. (the
  closest anyone came to proposing this was Avi with the user-space INT3 hack
  - but we can do better than that via the jprobes technique.) At that point
  the advantage of having a pure user-space callback technique combined with
  the advantages of having near full instruction coverage might tip the
  balance. There are other complexities to handle in that case though, like 
  buffering and more. ]

But right now we are nowhere near that stage, and i dont see the path towards 
that either. So i'd much rather see something simpler and get on with these 
IMHO unimportant performance details to the IMO much more important high level 
interface and high level tooling details.

When we merged kprobes ~10 years ago we made the (rather bad) mistake of 
merging a raw, opaque facility and leaving 'the rest' up to some other entity. 
IBM kprobes hackers vanished the day the original kprobes code went upstream 
and the high level entity never truly materialized in-kernel, for nearly a 
decade!

With uprobes we should learn from that painful lesson and bring in the high 
level users of uprobes via 'perf probe' (or any other real user) straight 
away.

Complexity is easy to increase when usage is increasing, it's near impossible 
to reduce when usage is not there. (and it's rather hard to reduce even with 
increasing usage - especially of aspects of the complexity leak out to 
user-space ABIs - which danger XOL has written all over it.)

So the request is simple to sum up: please reduce complexity of the initial 
submission and increase all around utility.

Thanks,

	Ingo
