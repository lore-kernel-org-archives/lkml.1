Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZGJJla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZGJJla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbZGJJlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:41:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:50482 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbZGJJlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:41:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=AgXkRhw+f2Vy+EF+GPhaKHhmWx+YC0arlOcHhoSI032T3oLNqd1eujUlule5W3kEZ
	LISeKEgd1uAOFnJxJD7jg==
Date: Fri, 10 Jul 2009 02:41:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, graydon@redhat.com, fche@redhat.com,
       cl@linux-foundation.org
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
 using mudflap
In-Reply-To: <20090710092921.GF14666@wotan.suse.de>
Message-ID: <alpine.DEB.2.00.0907100233560.14601@chino.kir.corp.google.com>
References: <1247156020.27671.40.camel@debian-nb> <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com> <20090710084745.GA26752@elte.hu> <1247215920.32044.3.camel@penberg-laptop> <20090710090351.GD14666@wotan.suse.de> <1247217263.771.8.camel@penberg-laptop>
 <20090710092921.GF14666@wotan.suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, Nick Piggin wrote:

> What I would like to see is we eventualy make the hard decision
> and cull 2 of them. If SLQB is not clearly better (or, if it is
> clearly worse) than the other allocators and it can't be improved,
> then it has failed my goals for it and I would prefer to remove it
> from the tree.
> 

The design of slqb, to your credit, appears more extendable than slub and 
addressing issues such as the netperf regression (which only manifests 
noticeably on my systems with >= 16 cpus) should be easier since they 
won't be antagonist to the allocator's inherent design.

The reason why I'd like to see slqb merged as a non-default alternative is 
because it exposes the allocator to more benchmarking coverage than would 
be possible in any other environment and attracts much more attention to 
development for those who don't pull Pekka's tree directly.
