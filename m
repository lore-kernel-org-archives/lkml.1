Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZHYKUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZHYKUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 06:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZHYKU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 06:20:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56005 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbZHYKU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 06:20:28 -0400
Date: Tue, 25 Aug 2009 12:20:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] x86: Fix cpu_coregroup_mask to return correct
	cpumask on multi-node processors
Message-ID: <20090825102023.GB26801@elte.hu>
References: <20090820131243.GO29327@alberich.amd.com> <20090820134604.GD29327@alberich.amd.com> <1251128176.7538.301.camel@twins> <20090825093101.GJ20811@alberich.amd.com> <1251194143.7538.1128.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251194143.7538.1128.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-08-25 at 11:31 +0200, Andreas Herrmann wrote:
> > On Mon, Aug 24, 2009 at 05:36:16PM +0200, Peter Zijlstra wrote:
> > > On Thu, 2009-08-20 at 15:46 +0200, Andreas Herrmann wrote:
> > > > The correct mask that describes core-siblings of an processor
> > > > is topology_core_cpumask. See topology adapation patches, especially
> > > > http://marc.info/?l=linux-kernel&m=124964999608179
> > > 
> > > 
> > > argh, violence, murder kill.. this is the worst possible hack and you're
> > > extending it :/
> > 
> > So this is the third code area
> > (besides sched_*_power_savings sysfs interface, and the __cpu_power fiddling)
> > that is crap, mess, a hack.
> > 
> > Didn't know that I'd enter such a minefield when touching this code. ;-(
> 
> Yeah, you're lucky that way ;-) Its been creaking for a while, and I've
> been making noises to the IBM people (who so far have been the main
> source of power saving patches) to clean this up, but now you trod onto
> all of it at once..
> 
> > What would be your perferred solution for the
> > core_cpumask/llc_shared_map stuff?  Another domain level to get rid of
> > this function?
> 
> Right, I'd like to see everything exposed as domain levels.
> 
>  numa-cluster
>  numa
>  socket
>  in-socket-numa
>  multi-core
>  shared-cache
>  core
>  threads
> 
> We currently have a fixed order of these things, but I think we 
> should simply provide helpers for building the sd tree and let the 
> arch code do that instead of exporting all these masks in a fixed 
> order.
> 
> Once we get the arch domain tree, we do degenerate stuff to cull 
> all the trivial domains and fold SD flags.

Btw., to move this into the realm of possibility for .32, we can 
start this by adding the framework and then crudely cutting off 
these wrongly layered connections to the architecture code and doing 
a clean core.

We might regress but the fixes to those will be isolated and forward 
looking.

	Ingo
