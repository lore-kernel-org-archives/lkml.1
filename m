Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZDOHhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZDOHhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 03:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZDOHhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 03:37:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53931 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbZDOHhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 03:37:36 -0400
Date: Wed, 15 Apr 2009 09:37:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: TRACE_BRANCH_PROFILING breaks gcc warnings
Message-ID: <20090415073720.GC18192@elte.hu>
References: <1239748090.4205.26.camel@johannes.local> <1239748293.21121.60.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239748293.21121.60.camel@localhost.localdomain>
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


* Steven Rostedt <srostedt@redhat.com> wrote:

> 
> On Wed, 2009-04-15 at 00:28 +0200, Johannes Berg wrote:
> > With TRACE_BRANCH_PROFILING enabled you get "dummy may be used
> > uninitialised" with code like the following (and gcc 4.3.3):
> > 
> > void *dummy, *c;
> > 
> > if (a && (dummy = b()))
> > 	c = dummy;
> > 
> > Therefore, allyesconfig has become useless for looking at warnings.

There's an easy solution for that problem btw: you just have to 
disable the branch tracer after allyesconfig. [ Or fix the compiler. 
Or both ;-) ]

I'm also curious, how often do you do allyesconfig builds? I've 
never seen you report one before. Have you started doing them 
recently? How much time does it take on your system?

> > :(
> 
> This has been mentioned before, and I've asked about sending a 
> patch that would prevent TRACE_BRANCH_PROFILING from being 
> selected with an allyesconfig.
> 
> It is easy to do. I could make it a selection and not a boolean 
> and it will not select it as default, even for allyes/modconfig
> 
> Thoughts?

That's a good idea - please send a patch.

	Ingo
