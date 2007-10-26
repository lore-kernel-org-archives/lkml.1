Return-Path: <linux-kernel-owner+w=401wt.eu-S1763462AbXJZPtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763462AbXJZPtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbXJZPte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:49:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011AbXJZPtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:49:33 -0400
Date: Fri, 26 Oct 2007 11:49:09 -0400
From: Rik van Riel <riel@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Knoblauch <spamtrap@knobisoft.de>,
       linux-kernel@vger.kernel.org, Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc1: First impressions
Message-ID: <20071026114909.5a6a5b4e@bree.surriel.com>
In-Reply-To: <1193412540.27652.9.camel@twins>
References: <796505.25770.qm@web32612.mail.mud.yahoo.com>
	<20071026152221.GA26619@elte.hu>
	<1193412540.27652.9.camel@twins>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 17:29:00 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > wow, really nice results! Peter does know how to make stuff fast :)
> > Now lets pick up some of Peter's other, previously discarded
> > patches as well :-)
> > 
> > Such as the rewritten reclaim (clockpro) patches:
> > 
> >   http://programming.kicks-ass.net/kernel-patches/page-replace/
> 
> I think riel is taking over that stuff with his split vm and policies
> per type.

I am.  Taking every single reference to a page into account simply
won't scale to systems with 1TB of RAM.  This is why I am working
on implementing:

http://linux-mm.org/PageReplacementDesign

At the moment I only have the basic "plumbing" of the split VM
working and am fixing some bugs in that.  Expect a patch series
with that soon, so you guys can review that code and tell me
where to beat it into shape some more :)

After that I will work on the policy bits, where we can really
get performance benefits.  The patch series should be mergeable
in smaller increments, so we can take things slowly if desired.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
