Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbXEaJSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbXEaJSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbXEaJRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:17:54 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:35734 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755489AbXEaJRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:17:53 -0400
Subject: Re: [PATCH 5/6] lockstat: human readability tweaks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Matthew Helsley <matthltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <1180553945.4738.13.camel@localhost.localdomain>
References: <20070530124903.882133089@chello.nl>
	 <20070530125336.322824180@chello.nl>
	 <1180553945.4738.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 31 May 2007 11:17:43 +0200
Message-Id: <1180603063.7348.102.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 12:39 -0700, Matthew Helsley wrote:
> On Wed, 2007-05-30 at 14:49 +0200, Peter Zijlstra wrote:
> > plain text document attachment (lockstat-output.patch)
> > Present all this fancy new lock statistics information:
> > 
> > *warning, _wide_ output ahead*
> > 
> > (output edited for purpose of brevity)
> > 
> >  # cat /proc/lock_stat
> > lock_stat version 0.1
> > -----------------------------------------------------------------------------------------------------------------------------------------------------------------
> >                               class name    contentions   waittime-min   waittime-max waittime-total   acquisitions   holdtime-min   holdtime-max holdtime-total
> > -----------------------------------------------------------------------------------------------------------------------------------------------------------------
> 
> <snip>
> 
> > 'contentions' and 'acquisitions' are the number of such events measured (since 
> > the last reset). The waittime- and holdtime- (min, max, total) numbers are 
> > presented in microseconds.
> 
> I think it would make sense to actually mention the time scale in the
> output header someplace. Then a tool written to analyze this file will
> have a way of determining the time scale without using error-prone
> heuristics (like "kernel version foo uses microseconds while kernel foo
> + 100 uses nanoseconds").

I did think of putting [us] after each time related column description,
but that would widen the output even more (not sure it matters that
much, its very wide already anyway).

However, the current format is microseconds with 2 decimals, so that is
basically a 10 nanosecond granularity. I do not think the extra digit is
worth much hassle (and it could be added as a 3rd decimal digit without
breaking the current format).

Also, there is a version string at the top, which should be changed
every time the output format changes.

