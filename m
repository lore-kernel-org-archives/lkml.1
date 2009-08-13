Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbZHMIXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbZHMIXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZHMIXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:23:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43682 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZHMIXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:23:35 -0400
Subject: Re: [PATCH 4/2] perf_counter: Fix swcounter context invariance
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       stephane eranian <eranian@googlemail.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090813080515.GA6001@nowhere>
References: <20090812153529.716542680@chello.nl>
	 <1250149915.10001.66.camel@twins>  <20090813080515.GA6001@nowhere>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Aug 2009 10:22:58 +0200
Message-Id: <1250151778.10001.67.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 10:05 +0200, Frederic Weisbecker wrote:
> On Thu, Aug 13, 2009 at 09:51:55AM +0200, Peter Zijlstra wrote:
> > Not really related to this topic, but it needs posting anyway.
> > 
> > ---
> > 
> > Subject: perf_counter: Fix swcounter context invariance
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Fri Aug 07 13:29:13 CEST 2009
> > 
> > perf_swcounter_is_counting() uses a lock, which means we cannot use
> > swcounters from NMI or when holding that particular lock, this is
> > unintended.
> > 
> > The below removes the lock, this opens up race window, but not worse
> > than the swcounters already experience due to RCU traversal of the
> > context in perf_swcounter_ctx_event().
> > 
> > Cc: Paul Mackerras <paulus@samba.org>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> 
> 
> As a side effect, it's possible this also fixes the hard lockups
> while opening a lockdep tracepoint counter.

It will -- not a side-effect at all, intended consequence :-)
