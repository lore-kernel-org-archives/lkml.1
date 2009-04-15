Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbZDOVEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbZDOVEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZDOVEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:04:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37376 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbZDOVEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:04:30 -0400
Date: Wed, 15 Apr 2009 23:03:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090415210353.GA27368@elte.hu>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu> <20090415054417.GA5272@elte.hu> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <20090415162627.GA32254@elte.hu> <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415133255.b6a33bfe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415133255.b6a33bfe.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 15 Apr 2009 12:43:02 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Wed, 15 Apr 2009, H. Peter Anvin wrote:
> > > 
> > > "cleanup" is indeed the most common, as it is intended to signify a
> > > trivial but nonzero code change.  Whether or not it's *correct* is
> > > another matter.  "build fix" is valid and proper use: it tells that it
> > > fixes a compilation error, which succinctly communicates both the
> > > priority of the fix and how it needs to be validated.
> > 
> > Why would that be "proper use"?
> > 
> > Dammit, if the "build fix" is not obvious from the rest of the commit 
> > message, there's something wrong.
> > 
> > And if it _is_ obvious, then the mechanical "Impact:" thing is pointless.
> > 
> > In other words - in neither case does it actually help anything at all. 
> > It's only distracting noise.
> > 
> 
> I'm getting quite a few Impact:s now and I must say that the 
> Impact: line is always duplicative of the Subject:.  Except in a 
> few cases, and that's because the Subject: sucked.
> 
> But I leave the Impact: lines in there because I'm nice.

I looked at the current .30 cycle up to latest -git and i found only 
five commits out of 584 that had your signoff (most went upstream 
via you) which also had Impact lines:

| commit 3d26dcf7679c5cc6c9f3b95ffdb2152fba2b7fae
| Author: Andi Kleen <andi@firstfloor.org>
| Date:   Mon Apr 13 14:40:08 2009 -0700
|
|    kernel/sys.c: clean up sys_shutdown exit path
|    
|    Impact: cleanup, fix
|
| Clean up sys_shutdown() exit path.  Factor out common code.  Return
| correct error code instead of always 0 on failure.

Impact line exposes wrong patch structure: cleanup should never be 
mixed with fix.

Impact line is not duplicative of subject line - it correctly 
mentions that there are side-effects. (sys_shutdown() changes its 
return code)

The subject line is thus wrong.

| commit 0769c2981495c3d05429840d6fc7a1b5e26accaa
| Author: Andi Kleen <andi@firstfloor.org>
| Date:   Mon Apr 13 14:39:56 2009 -0700
|
|     asm-generic/siginfo.h: update NSIGTRAP definition
|    
|     Impact: (nearly) trivial

impact line somewhat atypical but correct - the patch is a cleanup 
but might affect user-space.

Impact line is not duplicative of subject line.

| commit 6b44003e5ca66a3fffeb5bc90f40ada2c4340896
| Author: Andrew Morton <akpm@linux-foundation.org>
| Date:   Thu Apr 9 09:50:37 2009 -0600
|
|     work_on_cpu(): rewrite it to create a kernel thread on demand
|    
|     Impact: circular locking bugfix

Impact line is correct.

You wrote a fix - Rusty was nice in keeping your subject line and 
enhanced the commit with a non-trivial impact line.

[ Btw., this commit also had an unintended impact: it caused a 10% 
  mysqld performance drop on certain systems. When this commit was 
  bisected to later on it was immediately obvious from the impact 
  line that this side-effect was not intended when the patch was
  written. ]

Impact line is not duplicative of subject line.

| commit acdd052a285a7b4cc7da4fa7d34ef9fd0a67b2f8
| Author: Hannes Eder <hannes@hanneseder.net>
| Date:   Tue Mar 31 15:23:50 2009 -0700
|
|     init/main.c: fix sparse warnings: context imbalance
|     
|     Impact: Attribute function 'init_post' with __releases(...).

Impact line is incorrect (describes action not effect).

Impact line is not duplicative of subject line.

| commit ee99c71c59f897436ec65debb99372b3146f9985
| Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
| Date:   Tue Mar 31 15:19:31 2009 -0700
|
|     mm: introduce for_each_populated_zone() macro
|    
|     Impact: cleanup

Impact line is correct and appropriate.

Impact line is not duplicative of subject line.

So, here are my conclusions:

- only 0.85% of the commits you were involved with in this cycle had 
  an impact line.

- out of 5 cases, 4 had correct impact lines, despite _you_ 
  admittedly not liking them and not caring about them. That's a 
  pretty good ratio IMO. Impact lines should be handled by the
  maintainer. You should not pass them through - just erase them
  please - just like you erase or change other parts of changelogs 
  you dont like.

- i one out of the 5 cases, you could have detected a slightly
  suboptimal patch structure just based on the (truthful) impact
  line. But you dont use the impact lines so you missed this detail.

- in one out of the 5 cases, the impact line was used later on 
  during bug analysis. _I_ remember having looked at that impact 
  line and saw that he performance regression was clearly not 
  anticipated. Could i have recovered that information in some other 
  way? Yes, i could have mailed you, or i could have made a guess 
  out of other context data. But the impact line told me for sure.

- i'm not sure on what you base your observation that the impact
  lines you get are "always duplicative of the Subject:.". It wasnt
  duplicative in any of the above cases.

So i'm puzzled really. This stuff is clearly useful to us every day, 
it shows up in only 0.85% of your commits (because you let them 
through - you could erase them) but clearly if both Linus and you 
are against it what can we do? :-(

	Ingo
