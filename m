Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbZCJRHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbZCJRHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZCJRHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:07:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54298 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbZCJRHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:07:35 -0400
Date: Tue, 10 Mar 2009 18:07:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 06/11] Use virtual debug registers in process/thread
	handling code
Message-ID: <20090310170716.GC22897@elte.hu>
References: <20090310144933.GH3850@elte.hu> <Pine.LNX.4.44L0.0903101155000.3979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903101155000.3979-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> > Speaking of switch_to_thread_hw_breakpoint(), i dont like 
> > that function at all:
> > 
> > - why does it have to do a list of debug registers?
> 
> I'm not sure I understand the point of this question.  Are you 
> asking why the hw_breakpoint structures are stored on a list?  
> Because there can be an arbitrarily large number of them.

But that does not make much sense. There's just 4 hardware 
registers. There's no sane way to overcommit them hence we 
_should not_.

> > - why does it worry about IPIs arriving when context-switches on 
> >   x86 are always done with interrupts disabled?
> 
> The routine gets invoked at times other than during a context 
> switch.  However you may be right that these times are all 
> mutually exclusive.  If so then a good deal of complication 
> can be removed.

Yes.

> > - also, what do the ->installed() and ->uninstalled() callbacks 
> >   do - nothing uses it!
> 
> What do you mean?  They do what any callback does.  And of 
> course nothing uses them -- the code hasn't been merged yet!

No need to get testy - i'm the maintainer and you are trying to 
get stuff into two subsystems i maintain. I ask such questions 
when i see something added that has no immediate purpose.

If a later patch needs a particular facility then submit it 
together with that use. It's not that hard to add callbacks - 
but right now it just distracts from the immediate purpose of 
these patches.

And please dont try to get stuff merged if you are not willing 
to answer simple questions like that in a constructive way.

	Ingo
