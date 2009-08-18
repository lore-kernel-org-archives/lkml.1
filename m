Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbZHRLQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbZHRLQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758795AbZHRLQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:16:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40817 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758738AbZHRLQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:16:51 -0400
Date: Tue, 18 Aug 2009 13:16:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/12] cleanup __build_sched_domains()
Message-ID: <20090818111644.GA23983@elte.hu>
References: <20090818104944.GA29515@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818104944.GA29515@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> Hi,
> 
> Following patches try to make __build_sched_domains() less ugly 
> and more readable. They shouldn't be harmful. Thus I think they 
> can be applied for .32.
> 
> Patches are against tip/master as of today.
> 
> FYI, I need those patches as a base for introducing a new domain 
> level for multi-node CPUs for which I intend to sent patches as 
> RFC asap.

Very nice cleanups!

Magny-Cours indeed will need one more sched-domains level, 
something like:

   [smt thread]
   core
   internal numa node
   cpu socket
   external numa node 

... which is certainly interesting, especially since the hierarchy 
possibly 'crosses', i.e. we might have the two internal numa nodes 
share a L2 or L3 cache, right?

I'd also not be surprised if the load-balancer needed some care to 
properly handle such a setup.

It's all welcome work in any case, and for .32.

	Ingo
