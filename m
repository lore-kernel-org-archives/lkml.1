Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbYGWJDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbYGWJDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 05:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYGWJDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 05:03:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37152 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbYGWJDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 05:03:32 -0400
Date: Wed, 23 Jul 2008 11:03:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, ak@linux.intel.com, tiwai@suse.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-next@vger.kernel.org
Subject: Re: [PATCH 72/79] sysdev: Pass the attribute to the low level
	sysdev show/store function
Message-ID: <20080723090310.GA13534@elte.hu>
References: <20080722051805.GA17373@suse.de> <1216703983-21448-72-git-send-email-gregkh@suse.de> <20080722134045.7f09ff29.akpm@linux-foundation.org> <20080722204939.GA3028@suse.de> <20080722140301.2a334f8c.akpm@linux-foundation.org> <20080722211919.GA5669@suse.de> <20080723130435.7a79f7e4.sfr@canb.auug.org.au> <20080723042218.GA6784@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723042218.GA6784@suse.de>
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


* Greg KH <gregkh@suse.de> wrote:

> On Wed, Jul 23, 2008 at 01:04:35PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > On Tue, 22 Jul 2008 14:19:19 -0700 Greg KH <gregkh@suse.de> wrote:
[...]
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > > This wrecks use-sysdev_class-in-schedc.patch (below), which I 
> > > > merged a week ago and will now drop.
> > > >
> > > > Why did this patch from Andi just turn up in linux-next now, 
> > > > halfway through the merge window?  It has a commit date of July 
> > > > 1 yet it has never before been sighted in linux-next.
[...]
> > >
> > > Andi any thoughts?
> > 
> > The patch
> > (sysdev-pass-the-attribute-to-the-low-level-sysdev-show-store-function.patch)
> > has existed in the driver-core part of linux-next since July 4, but the
> > kernel/sched.c part only got added yesterday.
> 
> That came from the updated version that Andi sent me to fix the 
> sparc64 build problems the original version had.
> 
> Stephen, thanks for diging this out.

ok, lemme do a bit of merge window flaming here, in defense of Andrew.

This commit history:

  commit 4a0b2b4dbe1335b8b9886ba3dc85a145d5d938ed
  Author:     Andi Kleen <andi@firstfloor.org>
  AuthorDate: Tue Jul 1 18:48:41 2008 +0200
  Commit:     Greg Kroah-Hartman <gregkh@suse.de>
  CommitDate: Mon Jul 21 21:55:02 2008 -0700

    sysdev: Pass the attribute to the low level sysdev show/store function

  [...]

    I converted all users in tree to the new show/store prototype. It's 
    a single huge patch to avoid unbisectable sections.

    Runtime tested: x86-32, x86-64
    Compiled only: ia64, powerpc
    Not compile tested/only grep converted: sh, arm, avr32

covers a relatively trivial patch that we'd normally not notice, but it 
is ... a ... misrepresentation of the true situation on several levels:

1) The changelog. The updated patch Andi sent did not declare the other
   incremental changes (to sched.c) it also included freshly.

2) The date. This patch did not originate on Jul 1 - if Andi sent a 
   material update yesterday it should say Jul 21, not Jul 1.

3) The justification. Huge atomic patches are fine and can indeed be 
   much simpler than a gradual switchover, _iff_ they are done 
   perfectly. If there's any doubt then they are by far not the only 
   option to pursue - we've done finegrained API changeovers for years.

... which all we still wouldnt worry much about (the whole change is 
relatively trivial), if it had been done more carefully without wrecking 
Andrew's workflow in the middle of the merge window.

If every upstream pull - no matter how trivial - caused such work flow 
problems for Andrew (who is sitting at the _end_ of all linux-next stuff 
so is particularly hard hit by last-minute updates - especially if they 
are not append-only) then Andrew would never be able to get his stuff 
from -mm into -git.

If Andi cannot be bothered to do a proper finegrained workflow _or_ at 
least make it damned sure that he does not mess up other people's work 
via one huge patch modified on the last day (instead of at least sending 
an incremental patch for the last delta) then he should not be doing 
such complex changes.

Grmbl!

	Ingo
