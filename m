Return-Path: <linux-kernel-owner+w=401wt.eu-S1758346AbZHQXA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346AbZHQXA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbZHQXA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:00:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40436 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758329AbZHQXAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:00:55 -0400
Date: Tue, 18 Aug 2009 01:00:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, akpm@linux-foundation.org,
       nhorman@tuxdriver.com, rostedt@goodmis.org
Subject: Re: [PATCH -next] trace_skb: fix build when CONFIG_NET is not
	enabled
Message-ID: <20090817230032.GA16222@elte.hu>
References: <4A89BF90.5070202@oracle.com> <20090817215808.GB15016@elte.hu> <20090817.153326.69833512.davem@davemloft.net> <20090817224727.GA13795@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817224727.GA13795@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Mon, 17 Aug 2009 23:58:08 +0200
> > 
> > >> --- linux-next-20090817.orig/kernel/trace/Kconfig
> > >> +++ linux-next-20090817/kernel/trace/Kconfig
> > >> @@ -236,6 +236,7 @@ config BOOT_TRACER
> > >>  
> > >>  config SKB_SOURCES_TRACER
> > >>  	bool "Trace skb source information"
> > >> +	depends on NET
> > >>  	select GENERIC_TRACER
> > >>  	help
> > >>  	   This tracer helps developers/sysadmins correlate skb allocation and
> > > 
> > > Hm, there's nothing like this in the tracing tree.
> > > 
> > > Could we please move kernel/trace/* commits to the tracing tree, so 
> > > that it gets adequate testing and review, etc?
> > 
> > This one (like previous networking tracing changes Neil has made) 
> > touched a decent amount of networking code, and thus we 
> > integrated it into net-next-2.6
> 
> the three skb-sources-tracer patches i saw submitted were:
> 
>  include/trace/events/skb.h |   20 ++++++++++++++++++++
>  net/core/datagram.c        |    3 +++
>  2 files changed, 23 insertions(+)
> 
>  kernel/traceKconfig |   10 ++++++++++
> 
>  kernel/trace/Makefile            |    1
>  kernel/trace/trace.h             |   19 ++++++
>  kernel/trace/trace_skb_sources.c |  154 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> 
> only touched the networking code for 3 lines in 
> net/core/datagram.c.
> 
> Think about it: how would you react if i added a new file to 
> net/core/ and modified net/Kconfig, and then broke the build? 
> You'd quite likely insist on it being done via net-next-2.6, 
> right? You'd also likely be upset about that kind of change, 
> wouldnt you?
> 
> Also, has the review feedback from the tracing folks been 
> addressed? Please separate these patches out and lets do this 
> properly, this approach is not acceptable.

btw., this isnt just a question of patch logistics - these patches 
look unreviewed to me. Why is a new ftrace plugin needed? Why arent 
they defined in a TRACE_EVENT() form? That way they'd be generally 
usable together with other tracepoints, and would likely be enabled 
in most distros. That way they could also be added via other trees, 
as TRACE_EVENT() is a generic facility.

We try to migrate ftrace plugins to TRACE_EVENT() tracepoints.

	Ingo
