Return-Path: <linux-kernel-owner+w=401wt.eu-S1764649AbZDBVYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764649AbZDBVYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbZDBVXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:23:53 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53309 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636AbZDBVXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:23:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18901.11489.765420.408337@cargo.ozlabs.ibm.com>
Date: Fri, 3 Apr 2009 08:23:45 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] RFC perf_counter: singleshot support
In-Reply-To: <20090402122616.GB24618@elte.hu>
References: <20090402091158.291810516@chello.nl>
	<20090402091319.257773792@chello.nl>
	<20090402105151.GB10828@elte.hu>
	<1238672893.8530.5909.camel@twins>
	<20090402122616.GB24618@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Sure. One sidenote - the precision of sw clocks has dropped a bit 
> lately:
> 
> aldebaran:~/linux/linux/Documentation/perf_counter> ./perfstat -e 
> 1:0 -e 1:0 -e 1:0 -e 1:0 -e 1:0 sleep 1
> 
>  Performance counter stats for 'sleep':
> 
>        0.762664  cpu clock ticks      (msecs)
>        0.761440  cpu clock ticks      (msecs)
>        0.760977  cpu clock ticks      (msecs)
>        0.760587  cpu clock ticks      (msecs)
>        0.760287  cpu clock ticks      (msecs)
> 
>  Wall-clock time elapsed:  1003.139373 msecs
> 
> See that slight but noticeable skew? This used to work fine and we 
> had the exact same value everywhere. Can we fix that while still 
> keeping the code nice?

I suggest basing the software clock on counter->ctx->time_now, and
make get_context_time use cpu_clock() always.  That way we will only
call cpu_clock() once even if we have multiple cpu clock counters, and
that will eliminate the skew as well as being more efficient.

Paul.
