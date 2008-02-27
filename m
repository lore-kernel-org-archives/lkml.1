Return-Path: <linux-kernel-owner+w=401wt.eu-S1761881AbYB0WOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761881AbYB0WOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbYB0WOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:14:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:47310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757542AbYB0WOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:14:08 -0500
Date: Wed, 27 Feb 2008 23:14:07 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc][patch] x86-64 new smp_call_function design
Message-ID: <20080227221407.GA26067@wotan.suse.de>
References: <20080227124217.GA1340@wotan.suse.de> <20080227132713.GA13681@elte.hu> <20080227135041.GC1340@wotan.suse.de> <20080227150210.GA21610@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227150210.GA21610@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 04:02:10PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > > the two structures are quite similar in size and role - why not have 
> > > a type field and handle them largely together? I think we should try 
> > > to preserve a single queue and a single vector - that would remove a 
> > > number of ugly special-cases from the patch.
> > 
> > A single queue will kill one of the big fundamental scalability 
> > improvements of the call_single. That's the problem.
> 
> hm, indeed. Then how about the other way around: couldnt the normal 
> all-cpus SMP function call be implemented transparently via using 
> smp_call_single() calls?

That's possible, but it is slower and less scalable on my 8-way, and
I suspect it might become even slower than the generic code on larger
systems.

> The vector duplication is really ugly and feels 
> wrong.

Why?
