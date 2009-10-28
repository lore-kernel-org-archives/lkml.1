Return-Path: <linux-kernel-owner+w=401wt.eu-S932594AbZJ1H0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbZJ1H0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932342AbZJ1H0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:26:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33450 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbZJ1H0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:26:45 -0400
Date: Wed, 28 Oct 2009 08:26:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Luck, Tony" <tony.luck@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
Message-ID: <20091028072626.GB6353@elte.hu>
References: <20091023134115.GD27097@elte.hu> <alpine.LFD.2.00.0910231424440.21460@xanadu.home> <20091023191631.GA1879@elte.hu> <1256326512.26028.34.camel@gandalf.stny.rr.com> <20091023205400.GA8356@elte.hu> <20091024080326.GA7461@mit.edu> <57C9024A16AD2D4C97DC78E552063EA3E33D0A53@orsmsx505.amr.corp.intel.com> <20091026052118.GB13941@mit.edu> <4AE5E415.801@s5r6.in-berlin.de> <20091027180718.GC7915@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027180718.GC7915@mit.edu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@mit.edu> wrote:

> On Mon, Oct 26, 2009 at 07:01:57PM +0100, Stefan Richter wrote:
> > > Suppose I update the 40th patch of a 50th patch series to add check
> > > for kmalloc() returning NULL that had been inadvertently left out, or
> > > some other error checking is added.  Or suppose I add a new tracepoint
> > > definition to a 50 patch series.
> > 
> > ...are bad examples in the context of linux-next, IMO.  A missing
> > allocation failure check or a missing tracepoint don't break
> > bisectability.  So why discard this history?  (It was already published
> > in a release preview.)
> 
> There are multiple issues for rewinding patches.  One is to avoid 
> breaking bisectability.  Other is to keep related changes in 
> functionality in a single place.  2-3 years for now, does anyone 
> really care about retaining development history?  In the human memory, 
> one of the most important parts of long-term memory formation is 
> *forgetting*; that is, editing down everything that happened down to 
> the most cogent and importants bits of history.  This is what is 
> disrupted when people don't get enough sleep.

Fact is that the overwhelming majority of git-rebase uses i've seen were 
not done for ack-adding purposes.

They were used to prettify up a tree shortly before it's pushed 
upstream, and as a happy side-effect to whitewash out the more 
embarrassing bits of the history via backmerges. It presents a rosy 
picture about problem-free development and a perfectly going, fluid 
workflow with perfect foresight, good testing and few mistakes.

A real git tree will contain fixes for brown paperbag bugs, it will 
contain reverts, it will contain the occasional messy changelog. It is 
also, because it's more real life, far more trustable to pull from. The 
thing is, nothing improves a workflow more than public embarrassment - 
but rebasing takes away much of that public embarrassment factor.

Also, i dont buy the bisectability argument either. I bisect all the 
time. The number of bisections i've done on the kernel in the past two 
years are in the hundreds. Still i dont see any actual, frequent 
bisectability problems. (and if i see them i do raise it on lkml)

How come i dont see frequent bisection problems, despite the majority of 
trees and commits (well in excess of 50%) being maintained in 
append-only mode? By your argument i should be seeing an increasing 
amount of bisection problems. In fact i see the opposite: if i see some 
bad bisection bug it is often _due_ to a rebase - a patch was reordered 
without real testing being injected into the new tree, breaking hundreds 
(sometimes thousands) of commits.

So to sum it up - i am sure that there are people who can run nice trees 
responsibly, using just about _any_ source code management tool, be that 
Quilt or stgit. Heck i think Andrew could maintain -mm by scribbling 
patches on tree bark and sending them to Linus via swarms of pigeons. 
But the fundamental fact remains, from all the workflows i tried (and i 
ran 1000+ patches quilt trees just a few years ago), Git append-only 
workflows are the most gradual, most resilient, most scalable, most 
symmetric and hence most trustable source of changes to me.

So it's no wonder Linus mandates all big Git trees to use an append-only 
workflow.

	Ingo
