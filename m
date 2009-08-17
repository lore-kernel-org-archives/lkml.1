Return-Path: <linux-kernel-owner+w=401wt.eu-S1751775AbZHQNKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbZHQNKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 09:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbZHQNKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 09:10:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47742 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbZHQNKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 09:10:46 -0400
Date: Mon, 17 Aug 2009 15:10:44 +0200
From: Nick Piggin <npiggin@suse.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [patch 4a/4] ipc: sem optimise simple operations
Message-ID: <20090817131044.GI9962@wotan.suse.de>
References: <20090815045237.GC19195@wotan.suse.de> <4A86899A.6050502@colorfullife.com> <20090815103820.GC8954@wotan.suse.de> <4A86ABF0.2070207@colorfullife.com> <20090815144908.GA30951@wotan.suse.de> <4A86E30E.8030208@colorfullife.com> <20090816103127.GB8644@wotan.suse.de> <4A87ED93.5060104@colorfullife.com> <20090817064446.GD9962@wotan.suse.de> <4A8954F8.7040602@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8954F8.7040602@colorfullife.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 03:02:48PM +0200, Manfred Spraul wrote:
> On 08/17/2009 08:44 AM, Nick Piggin wrote:
> >OK, well let's just get something in.
> >   
> Good, I would propose the that the following 7 patches should be merged:
> 
> http://lkml.org/lkml/2009/8/11/59
> http://lkml.org/lkml/2009/8/11/9
> http://lkml.org/lkml/2009/8/11/14
> http://lkml.org/lkml/2009/8/15/163
> http://lkml.org/lkml/2009/8/15/164
> http://lkml.org/lkml/2009/8/15/167
> http://lkml.org/lkml/2009/8/15/168
> 
> Nick: is that ok from your point of view?

Well I don't know if they need to be broken up so much... the complex
list one is just broken out of my patch, no? I don't think it really
is more reviewable if you just add it without doing anything to it...
but whatever.

 
> >That said, I'm not too unhappy with your version if you feel strongly
> >about it.
> I would prefer it:
> We simply don't know if a wait-for-zero list, only for single sop 
> operations, is a step in the right direction.
> 
> Postgres uses single sop operations with just +-1 on one semaphore.
> You wrote that your SAP workload also uses +-1.
> According to google codesearch, apache, mozilla, mpich all use +-1.
> 
> Thus: Who uses single sop, wait for zero?

Oracle. Arguably it is also better behaviour for fairness to wake in
FIFO order too in that case.

> I'm just afraid that we optimize for the wrong case.

My point is that there is very little downside, and it is actually
going via simpler code paths (and less icache). So I think it makes
sense, but anyway.

