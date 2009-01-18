Return-Path: <linux-kernel-owner+w=401wt.eu-S934523AbZARRim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934523AbZARRim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 12:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765638AbZARRic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 12:38:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48107 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762473AbZARRic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 12:38:32 -0500
Date: Sun, 18 Jan 2009 18:38:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/17] x86-64: Use absolute displacements for per-cpu
	accesses.
Message-ID: <20090118173820.GA14356@elte.hu>
References: <1232115396-26367-6-git-send-email-brgerst@gmail.com> <1232115396-26367-7-git-send-email-brgerst@gmail.com> <1232115396-26367-8-git-send-email-brgerst@gmail.com> <1232115396-26367-9-git-send-email-brgerst@gmail.com> <1232115396-26367-10-git-send-email-brgerst@gmail.com> <1232115396-26367-11-git-send-email-brgerst@gmail.com> <1232115396-26367-12-git-send-email-brgerst@gmail.com> <4972AE71.2030506@kernel.org> <73c1f2160901172036m4d7bb4f8i50b6a5185a63e95@mail.gmail.com> <20090118164246.GA28423@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118164246.GA28423@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Brian Gerst <brgerst@gmail.com> wrote:
> 
> > On Sat, Jan 17, 2009 at 11:22 PM, Tejun Heo <tj@kernel.org> wrote:
> > 
> > > Hello, Brian.
> > >
> > > Brian Gerst wrote:
> > > > Accessing memory through %gs should not use rip-relative addressing.
> > > > Adding a P prefix for the argument tells gcc to not add (%rip) to
> > > > the memory references.
> > >
> > > Nice catch.  I dind't know about the P prefix thing.  It also is used
> > > in other places too.  Hmmm... I can't find anything about the P
> > > argument prefix in the gcc info page (4.3).  Any ideas where I can
> > > find some information about it?  It's a bit weird that it's not a
> > > constraint prefix but an argument one.
> > 
> > The only place I could confirm that it works is in the gcc source 
> > itself, and even there it's not well documented.
> 
> does %P support go back as far as gcc 3.2 (the earliest GCC we still 
> support)?

update: Brian pointed it out off-list that switch_to() already uses %P, so 
we already rely on it.

	Ingo
