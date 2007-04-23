Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbXDWU4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbXDWU4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbXDWU4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:56:36 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:28191 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbXDWU4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:56:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=grzMh1NjgE+J/Jnew9USj85H0vgFK1L+z/TXOerpZ4E3Uk1PLqh4mAjqVqGlqfmDIfPW6T+rAmopa0GqdycaNduCKKkuxUx3PKC9NvWFK4pubqJAtDvddWtUrMvsX1JDzaZAGHFBZEZFUsV+9IorOd9NYWL2G+yXPxpTudGW92c=
Message-ID: <f2b55d220704231356j7b1b039ew82e10a231eeb7749@mail.gmail.com>
Date: Mon, 23 Apr 2007 13:56:33 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [report] renicing X, cfs-v5 vs sd-0.46
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Juliusz Chroboczek" <jch@pps.jussieu.fr>,
       "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       "Bill Davidsen" <davidsen@tmr.com>, "Willy Tarreau" <w@1wt.eu>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>, "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, caglar@pardus.org.tr,
       "Gene Heskett" <gene.heskett@gmail.com>
In-Reply-To: <20070423194821.GA10286@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070420140457.GA14017@elte.hu>
	 <200704220155.20856.kernel@kolivas.org>
	 <20070421160008.GA28783@elte.hu>
	 <200704220959.34978.kernel@kolivas.org>
	 <87647oblx5.fsf@pps.jussieu.fr>
	 <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org>
	 <20070423024245.GA8378@elte.hu>
	 <alpine.LFD.0.98.0704230805510.9964@woody.linux-foundation.org>
	 <20070423194821.GA10286@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/07, Ingo Molnar <mingo@elte.hu> wrote:
> Basically this hack is bad on policy grounds because it is giving X an
> "legislated, unfair monopoly" on the system. It's the equivalent of a
> state-guaranteed monopoly in certain 'strategic industries'. It has some
> advantages but it is very much net harmful. Most of the time the
> "strategic importance" of any industry can be cleanly driven by the
> normal mechanics of supply and demand: anything important is recognized
> by 'people' as important via actual actions of giving it 'money'. (This
> approach also gives formerly-strategic industries the boot quickly, were
> they to become less strategic to people as things evolve.)

If you're going to drag free-market economics into it, why not
actually use the techniques of free-market economics?  Design a
bidding system in which agents (tasks) earn "money" by getting things
done, and can use that "money" to bid on "resources".  You will of
course need accurate cost accounting in order to decide which bids are
most "profitable" for the scheduler to accept, and accurate transfer
accounting to design price structures for contracts between agents in
which one agrees to accomplish work on behalf on another.  Actual
revenues come from doing the work that the consumer wants done and is
willing to pay for.  Etc., etc.  Has your horsepucky filter kicked in
yet?

If your system doesn't work this way -- perhaps because you think as I
do that scheduler design is principally an engineering problem, not an
economics problem -- then analogies from economics are probably worth
zip.  Yes, I wrote earlier about "economic dispatch" -- that's an
operations problem, a control theory problem, an _engineering_
problem, that happens to have a set of engineering goals and
constraints that take profitability into account.  I think you might
be able to design a better Linux scheduler anchored in the techniques
and literature of control theory, perhaps specifically with reference
to electric-utility economic dispatch, because the systems under
control and the goals of control are similar.

But there's a good reason not to treat X as special.  Namely, that it
_isn't_.  It may be the only program on many people's Linux desktops
with an opaque control structure -- a separate class of interactive
activities hidden inside an oversubscribed push-model pipeline stage
-- but it's hardly the only program designed this way.  Treat the X
server as a easily instrumented exemplar of a event-loop-centric
design whose thread structure doesn't distinguish between fast-twitch
and best-effort activity patterns.  I wrote earlier about what one
might do about this (attach urgency to to the work in the queue
instead of the worker being asked to do it).

Cheers,
- Michael
