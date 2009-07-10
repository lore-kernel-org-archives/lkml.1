Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZGJJFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZGJJFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbZGJJFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:05:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46642 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbZGJJFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:05:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=hj5CLbOYJkGh+PBo3NW6rd6WxN5Ye7o/D7xcTvzPOzHbiP9vHA9a79xcwRa3w48OT
	N0yMFr1oZOA2GTJ7g9drQ==
Date: Fri, 10 Jul 2009 02:04:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-kernel@vger.kernel.org, vegard.nossum@gmail.com,
       graydon@redhat.com, fche@redhat.com, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
 using mudflap
In-Reply-To: <20090710084745.GA26752@elte.hu>
Message-ID: <alpine.DEB.2.00.0907100158090.13880@chino.kir.corp.google.com>
References: <1247156020.27671.40.camel@debian-nb> <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com> <20090710084745.GA26752@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, Ingo Molnar wrote:

> > SLAB is (slowly) going away so you might want to port this to SLUB 
> > as well so we can merge both.
> 
> and SLQB which will replace both? :-/
> 

I'm not sure what the status of slqb is, although I would have expected it 
to have been pushed for inclusion in 2.6.31 as a slab allocator 
alternative.  Nick, any forecast for inclusion?

SLUB has a pretty noticeable performance degradation on benchmarks such as 
netperf TCP_RR with high numbers of threads (see my post about it: 
http://marc.info/?l=linux-kernel&m=123839191416472).  CONFIG_SLAB is the 
optimal configuration for workloads that share similiar slab thrashing 
patterns (which my patchset dealt with in an indirect way and yet still 
didn't match slab's performance).  I haven't yet seen data that suggests 
anything other than CONFIG_SLAB has parity with such a benchmark.
