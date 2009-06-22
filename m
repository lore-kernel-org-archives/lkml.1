Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbZFVLst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbZFVLst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbZFVLsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:48:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54368 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZFVLsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:48:40 -0400
Date: Mon, 22 Jun 2009 13:48:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: v2 of comments on Performance Counters for Linux (PCL)
Message-ID: <20090622114820.GA24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


hi Stephane,

Thanks for the extensive feedback! Your numerous comments cover 
twenty sub-topics, so we've tabulated the summary of Peter's and my 
replies, to give a quick overview:

-------------------------------------------------------------------------
     Topic/question you raised               # Our (current) reply
-------------------------------------------------------------------------
  I/ General API comments
......
  1/ System calls - ioctl                    # agree, willfix
  2/ Grouping                                # agree, questions asked
  3/ Multiplexing and system-wide            # agree, disagree on severity
  4/ Controlling group multiplexing          # agree, disagree on relevance
  5/ Mmaped count                            # disagree
  6/ Group scheduling                        # agree, disagree on severity
  7/ Group validity checking                 # questions answered
  8/ Generalized cache events                # disagree
  9/ Group reading                           # already possible - extend on need
 10/ Event buffer minimal useful size        # questions answered
 11/ Missing definitions for generic events  # reply question asked

 II/ X86 comments
......
  1/ Fixed counters on Intel                 # agree, willfix
  2/ Event knowledge missing                 # disagree

III/ Requests
......
  1/ Sampling period randomization           # support possible, outlined

 IV/ Open questions
......
  1/ Support for model-specific uncore PMU   # support possible, outlined
  2/ Features impacting all counters         # support possible, outlined
  3/ AMD IBS                                 # support possible, outlined
  4/ Intel PEBS                              # support possible, outlined
  5/ Intel Last Branch Record (LBR)          # support possible, outlined
-------------------------------------------------------------------------

( We'll send the individual replies in separate mails to keep mail
  size manageable. )

At the outset, it appears that there's two major themes to your 
questions (with a few other topics as well which i dont mention 
here):

 - Expressing/handling constraints with certain PMU features
 - Supporting various non-counter PMU features

In general we'd like to observe that our primary design goal is to 
offer a coherent, comprehensive and still simple to use performance 
measurement and profiling framework for Linux. We also provide an 
integrated tool in tools/perf/ to give a complete solution.

Many of the perfcounters features use no PMU at all, and in fact 
it's entirely possible to use most 'perf' features and get a 
meaningful analysis/profile of the system without any PMU.

In other words, we consider the PMU to be the means as to enhance 
perfcounters, not the end goal. A PMU will make a good difference to 
quality and precision, but we do not let the sanity of our 
interfaces be dictated by PMU feature quirkiness.

We cherry-pick the PMU features that look most useful, and expose 
them via rich performance measurement abstractions. It does not mean 
that we strive for immediately exposing _all_ PMU features and drown 
users in lots of conflicting hw facilities (different on each 
platform) as quickly as possible.

Having said that, we do think that pretty much any sane PMU feature
_can_ be supported via perfcounters (and most insane ones as well)
and that the limit is 'do we want to', not 'can we'.

Even heavily constrained PMUs can be supported: PowerPC, which is a
CPU family with heavily constrained PMU variants is widely supported
by perfcounters here and today.

	Ingo, Peter
