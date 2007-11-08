Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbXKHAZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbXKHAZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbXKHAY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:24:58 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:47134 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756914AbXKHAY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:24:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAEvmMUdGN3BN/2dsb2JhbAAMkDw
Subject: Re: [PATCH] sched: avoid large irq-latencies in smp-balancing
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       pwil3058@bigpond.net.au, linux-kernel@vger.kernel.org
In-Reply-To: <20071107221007.GA31008@goodmis.org>
References: <1194434956.6289.111.camel@twins>
	 <1194437820.6289.114.camel@twins>
	 <20071107102725.64514fde.akpm@linux-foundation.org>
	 <20071107221007.GA31008@goodmis.org>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 19:24:46 -0500
Message-Id: <1194481486.6606.6.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-07 at 17:10 -0500, Steven Rostedt wrote:
> > 
> > It would be nice if sched_nr_migrate didn't exist, really.  It's hard to
> > imagine anyone wanting to tweak it, apart from developers.
> 
> I'm not so sure about that. It is a tunable for RT. That is we can tweak
> this value to be smaller if we don't like the latencies it gives us.
> 
> This is one of those things that sacrifices performance for latency.
> The higher the number, the better it can spread tasks around, but it
> also causes large latencies.
> 
> I've just included this patch into 2.6.23.1-rt11 and it brought down an
> unbounded latency to just 42us. (previously we got into the
> milliseconds!).
> 
> Perhaps when this feature matures, we can come to a good defined value
> that would be good for all. But until then, I recommend keeping this a
> tunable.


Why not use the latency-expectation infrastructure?

Iterate under lock until (or before...) the system global latency is
respected.


- Eric

