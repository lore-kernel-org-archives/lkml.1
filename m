Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbZLQKvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbZLQKvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 05:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbZLQKvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 05:51:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44631 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbZLQKvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 05:51:14 -0500
Date: Thu, 17 Dec 2009 11:51:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/2] perf lock: Fix output of tracing lock events
Message-ID: <20091217105103.GA26010@elte.hu>
References: <1260934105-4472-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1260934105-4472-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1261041885.27920.110.camel@laptop>
 <20091217100922.GA23778@elte.hu>
 <1261045574.27920.179.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261045574.27920.179.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-12-17 at 11:09 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > >  	TP_STRUCT__entry(
> > > > +		__field(struct lockdep_map *, lockdep_addr)
> > > >  		__field(unsigned int, flags)
> > > >  		__string(name, lock->name)
> > > >  	),
> > > 
> > > I feel a bit awkward explicitly leaking kernel pointers like that. All this 
> > > is accessible by root only (for now) so its not too harmfull, but sitll.
> > 
> > What would you suggest as a 'natural lock class key'? The name? It might not 
> > be unique enough.
> > 
> > Other kernel objects like tasks, cpus, inodes, pages all have some natural key 
> > that isnt a kernel pointer - but locks are a bit special.
> 
> Well, yeah, that's the problem, and we use the pointer for exactly this 
> purpose inside the kernel too, its just that its a blatant data leak when we 
> expose it to userspace like that.
> 
> On the other hand, adding some ID generation just so we can expose it seems 
> silly too.
> 
> Why do we need to have instance resolution?

Does the tool make use of it to classify stats?

	Ingo
