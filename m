Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbYBWLiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbYBWLiO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYBWLhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:37:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38036 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbYBWLhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:37:53 -0500
Date: Sat, 23 Feb 2008 12:37:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080223113724.GB31304@elte.hu>
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <20080223001130.d8922136.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223001130.d8922136.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > Sysprof needs a 200 line kernel module to do it's work, this module 
> > puts some simple profiling data into debugfs.
> > 
> > ...
> 
> Seems a poor idea to me.  Sure, oprofile is "hard to set up", but not 
> if your distributor already did it for you.

two things.

Firstly, this isnt an oprofile replacement, this is a pretty separate 
concept. Sysprof is more of a tracer than a profiler. (and we are 
currently working on merging it into ftrace)

Secondly, real developers who tune user-space code disagree with your 
characterisation of oprofile being easy to use. _Please_ just ask any 
developer around you who hasnt used oprofile before to try sysprof 
versus oprofile - without looking at any docs. Give him minimal context 
and two starting points: "opcontrol" and "sysprof" - nothing else. Give 
him a very simple test.c code:

  void test_fn(void)
  {
	for (;;)
		gettimeofday(0, 0);
  }

  int main(void)
  {
	test_fn();
  }

and ask him to try oprofile and then to try sysprof as a comparison - to 
and figure in which app and which function the overhead is.

then measure the time it takes to solve this task via the two tools and 
ask the developer's first impression about the two tools.

> On Wed, 20 Feb 2008 10:10:22 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > thanks, looks good to me - applied.
> 
> This is pretty distressing, frankly.  The threshold for getting code into
> Linux should be much higher than this.
> 
> I do not have the time to review everything which goes into all the git
> trees.  Better review, please.

that was for x86.git#testing, it's not even in x86.git#mm.

It's 200 lines of pretty well isolated code for something that is 
already much more usable to me than 10 years of oprofile. Really, i'd 
much rather take 200 lines of poor kernel code written by a userspace 
developer for stuff that _already works better_, than to have ~2000 
lines of oprofile code and an unusable (to me) user-space tool written 
by kernel developers.

	Ingo
