Return-Path: <linux-kernel-owner+w=401wt.eu-S934279AbXHYLH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279AbXHYLH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 07:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933207AbXHYLHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 07:07:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764295AbXHYLHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 07:07:47 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH RT 3/3 - take two ] fix get_monotonic_cycles for latency tracer
References: <1187978236.2941.19.camel@localhost.localdomain>
	<1187982149.4574.1.camel@localhost.localdomain>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sat, 25 Aug 2007 07:06:54 -0400
In-Reply-To: <1187982149.4574.1.camel@localhost.localdomain> (Steven Rostedt's message of "Fri, 24 Aug 2007 15:02:29 -0400")
Message-ID: <y0modgv50vl.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Steven Rostedt <rostedt@goodmis.org> writes:

> [...]
> +		 * [...] We don't need to grab
> +		 * any locks, we just keep trying until get all the
> +		 * calculations together in one state.
> +		 *
> +		 * In fact, we __cant__ grab any locks. This
> +		 * function is called from the latency_tracer which can
> +		 * be called anywhere. To grab any locks (including
> +		 * seq_locks) we risk putting ourselves into a deadlock.

Perhaps you could add a comment about why the loop, which appears
potentially infinite as written, avoids livelock.  (It looks rather
like a seqlock read loop.)

- FChE
