Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbZDXHNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbZDXHNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZDXHNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:13:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60639 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbZDXHND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:13:03 -0400
Date: Fri, 24 Apr 2009 09:12:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/6] tracing: increase size of number of possible events
Message-ID: <20090424071224.GD24912@elte.hu>
References: <20090424043005.338878133@goodmis.org> <20090424043111.983189535@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424043111.983189535@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> With the new event tracing registration, we must increase the number
> of events that can be registered. Currently the type field is only
> one byte, which leaves us only 256 possible events.
> 
> Since we do not save the CPU number in the tracer anymore (it is determined
> by the per cpu ring buffer that is used) we have an extra byte to use.
> 
> This patch increases the size of type from 1 byte (256 events) to
> 2 bytes (65,536 events).
> 
> It also adds a WARN_ON_ONCE if we exceed that limit.
> 
> [ Impact: allow more than 255 events ]

> -	int			type;
> +	unsigned short		type;

Hm, the changelog is not valid anymore - as here we really cut it 
down from 4 billion to 64K, right?

	Ingo
