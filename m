Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbZDHJWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbZDHJWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbZDHJWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:22:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60460 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbZDHJWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:22:38 -0400
Date: Wed, 8 Apr 2009 11:22:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH] tracing/filters: use ring_buffer_discard_commit() in
	filter_check_discard()
Message-ID: <20090408092224.GD12283@elte.hu>
References: <1239083415.7220.45.camel@tropicana> <20090407130854.GA17992@elte.hu> <1239178441.10295.34.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239178441.10295.34.camel@tropicana>
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


* Tom Zanussi <tzanussi@gmail.com> wrote:

> As for the other errors, it's the CONFIG_EVENT_TRACER not being 
> turned on again.  I think the tracing config patch below would be 
> a better solution than the one I previously posted...

Agreed, this is a very nice patch, i have applied it. I'll check 
whether this solves all the build problems.

This fits nicely into the 'tracing plugin life cycle' and basically 
this is what we want to see happen for ftrace plugins: they first 
start as standalone experiments. Once they prove to be useful and 
other tracer plugins desire its capabilities too, they become part 
of the tracing infrastructure, not part of a standalone plugin.

This gives some leeway in allowing people to do plugins even if 
plugin utility is not immediately obvious, and we can then observe 
its use and let features/capabilities percolate down into the core 
code.

There's also plugin functionality that works best when left 
standalone - they are specifically shaped for one very particular 
development activity: for example mmiotrace to debug drivers.

It's a bit like how Firefox developers manage their plugin space, 
and this concept seems to have worked well in a number of cases in 
the tracing tree too.

	Ingo
