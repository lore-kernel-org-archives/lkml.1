Return-Path: <linux-kernel-owner+w=401wt.eu-S1767885AbXCJRJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767885AbXCJRJK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 12:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767887AbXCJRJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 12:09:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767885AbXCJRJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 12:09:09 -0500
Date: Sat, 10 Mar 2007 18:08:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nathan Lynch <ntl@pobox.com>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <20070310170819.GA26772@elte.hu>
References: <20070309193925.B60891B8028@attica.americas.sgi.com> <20070310091942.GC18250@elte.hu> <20070310155149.GA18478@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310155149.GA18478@localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nathan Lynch <ntl@pobox.com> wrote:

> > > +	/* try to stay on the same cpuset */
> > > +	if (dest_cpu == NR_CPUS) {
> > > +		p->cpus_allowed = cpuset_cpus_allowed(p);
> > > +		dest_cpu = any_online_cpu(p->cpus_allowed);
> > > +	}
> > 
> > what's the practical effect of this - when moving the last CPU offline 
> > from a node you got jobs migrated to really alien nodes? Thus i think we 
> > should queue this up for v2.6.21 too, correct? It's a NOP on systems 
> > that do not set up cpusets, so it's low-risk.
> 
> See my earlier reply to this patch.  Calling cpuset_cpus_allowed 
> (which takes a mutex) here is a bug, since move_task_off_dead_cpu must 
> be called with interrupts disabled.

ouch. i only checked the !CONFIG_CPUSET case :-/ It's a really bad idea 
to have any locking there indeed. The name itself suggests some atomic 
action.

	Ingo
