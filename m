Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZHMI3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZHMI3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZHMI3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:29:05 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:20232 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZHMI3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b+VbhVj0HzBafiWjfpfGbFpdnvRKyCmQa/zYGfx0aY/p2kg+OhEvF+IQpz5oHUcYY3
         L7HsC5HtZNt6XIV8KeXB0cCp7TLKC1VuqP6TAmeP8qTYWg1e9typ0ji0Vg3aoPKEryee
         S1sUrbbZS3BylmqKOF9pqIhe+IZWZ9ff9OK4g=
Date: Thu, 13 Aug 2009 10:29:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       stephane eranian <eranian@googlemail.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/2] perf_counter: Fix swcounter context invariance
Message-ID: <20090813082900.GB6001@nowhere>
References: <20090812153529.716542680@chello.nl> <1250149915.10001.66.camel@twins> <20090813080515.GA6001@nowhere> <1250151778.10001.67.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250151778.10001.67.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 10:22:58AM +0200, Peter Zijlstra wrote:
> On Thu, 2009-08-13 at 10:05 +0200, Frederic Weisbecker wrote:
> > On Thu, Aug 13, 2009 at 09:51:55AM +0200, Peter Zijlstra wrote:
> > > Not really related to this topic, but it needs posting anyway.
> > > 
> > > ---
> > > 
> > > Subject: perf_counter: Fix swcounter context invariance
> > > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Date: Fri Aug 07 13:29:13 CEST 2009
> > > 
> > > perf_swcounter_is_counting() uses a lock, which means we cannot use
> > > swcounters from NMI or when holding that particular lock, this is
> > > unintended.
> > > 
> > > The below removes the lock, this opens up race window, but not worse
> > > than the swcounters already experience due to RCU traversal of the
> > > context in perf_swcounter_ctx_event().
> > > 
> > > Cc: Paul Mackerras <paulus@samba.org>
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 
> > 
> > 
> > As a side effect, it's possible this also fixes the hard lockups
> > while opening a lockdep tracepoint counter.
> 
> It will -- not a side-effect at all, intended consequence :-)


Great then! Important fix for .31 :-)

