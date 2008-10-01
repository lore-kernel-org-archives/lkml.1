Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbYJAIGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbYJAIGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbYJAIG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:06:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51853 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbYJAIGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:06:25 -0400
Date: Wed, 1 Oct 2008 10:06:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 -tip 3/4] Tracing/ftrace: Adapt mmiotrace to the new
	type of print_line
Message-ID: <20081001080619.GA27056@elte.hu>
References: <48E11E1E.7010001@gmail.com> <20080929221934.260306dd@daedalus.pq.iki.fi> <20080930085241.GB10374@elte.hu> <c62985530809300539o2842c14fk16708abaf69c4e2f@mail.gmail.com> <alpine.DEB.1.10.0809300844270.1984@gandalf.stny.rr.com> <c62985530809300625p6c178c0ew6b9619998c3d5011@mail.gmail.com> <20080930153912.GB22693@elte.hu> <48E25039.8080907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E25039.8080907@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Subject: [PATCH -tip] Tracing/ftrace: correct return value of trace_empty
> 
> Correct the value's type of trace_empty function
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 6a1c76b..da3789d 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1686,7 +1686,7 @@ static int trace_empty(struct trace_iterator *iter)
>  		if (!ring_buffer_iter_empty(iter->buffer_iter[cpu]))
>  			return 0;
>  	}
> -	return TRACE_TYPE_HANDLED;
> +	return 1;

applied the commit below to tip/tracing/ring-buffer, thanks Frederic! 
(had to do manual merging due to flux in that function due to the 
locking changes - please double-check that i got it right.)

btw., we still have the mmiotrace type casting buglet unfixed:

> > >   struct trace_entry *entry = iter->ent;
> > > - struct mmiotrace_map *m = &entry->field.mmiomap;
> > > + struct mmiotrace_map *m = (struct mmiotrace_map *)entry;

	Ingo

------------>
>From a2e221682b91ff83dc8a5e7fbb60a9d87a4e83f2 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 30 Sep 2008 18:13:45 +0200
Subject: [PATCH] tracing/ftrace: Adapt mmiotrace to the new type of print_line, fix

Correct the value's type of trace_empty function

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b542f88..c163406 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1750,7 +1750,7 @@ static int trace_empty(struct trace_iterator *iter)
 		}
 	}
 
-	return TRACE_TYPE_HANDLED;
+	return 1;
 }
 
 static enum print_line_t print_trace_line(struct trace_iterator *iter)
