Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbZJFN0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbZJFN0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbZJFN0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:26:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbZJFN0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:26:30 -0400
Subject: Re: [RFC][PATCH 0/9] perf trace: support for general-purpose
 scripting
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       hch@infradead.org
In-Reply-To: <20091006090954.GA19325@elte.hu>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
	 <20091006090954.GA19325@elte.hu>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 15:25:54 +0200
Message-Id: <1254835554.21044.278.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 11:09 +0200, Ingo Molnar wrote:
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > Known problems/shortcomings:
> > 
> > Probably the biggest problem right now is the sorting hack I added as 
> > the last patch.  It's just meant as a temporary thing, but is there 
> > because tracing scripts in general want to see events in the order 
> > they happened i.e. timestamp order. [...]
> 
> Btw., have you seen the -M/--multiplex option to perf record? It 
> multiplexes all events into a single buffer - making them all ordered. 
> (The events are in causal ordering in this case even if there's some TSC 
> asynchronity)

It also wrecks large machines.. I've been thinking about limiting the
number of CPUs you can redirect into a single output stream using the
output_fd thing, but then the inherited stuff makes that very hard.

And we also need a solution for the inhertited counters, the best would
be the per-cpu inherited things, where we use both cpu and pid, instead
of either.

In short, -M is nice, but it also has significant down sides, esp. with
machines getting more and more cores.

