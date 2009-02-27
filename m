Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZB0Ipq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZB0Ipq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZB0Ipg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:45:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963AbZB0Ipf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:45:35 -0500
Date: Fri, 27 Feb 2009 00:45:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] vsprintf: unify the format decoding layer for its
 3 users
Message-Id: <20090227004513.f53ed532.akpm@linux-foundation.org>
In-Reply-To: <20090227083212.GE3609@elte.hu>
References: <20090226174303.GC29439@elte.hu>
	<20090226174547.GC5889@nowhere>
	<20090226175225.GA4527@elte.hu>
	<20090226183415.GE5889@nowhere>
	<20090226185208.GA6658@nowhere>
	<20090226185635.GA12895@elte.hu>
	<20090227061936.GA5318@nowhere>
	<20090226224656.5785de9e.akpm@linux-foundation.org>
	<20090227071212.GC5318@nowhere>
	<20090226233950.0cfcf883.akpm@linux-foundation.org>
	<20090227083212.GE3609@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 09:32:12 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> 
> a printf variant that outputs not into a string buffer but into 
> a binary-values buffer.

Oh, OK.

Of course, parsing a printf string (using our
nobody-bothered-optimising-it parser) isn't particularly efficient
either.

Is there a case here for adding a new way of describing how to
serialise the incoming data?  Perhaps with a new and simpler control
string or perhaps even

	struct ftrace_thing ft;

	init_ftrace_thing(&ft, "%d %l %s");
	add_ftrace_thing_int(&ft, some_int);
	add_ftrace_thing_long(&ft, some_long);
	add_ftrace_thing_string(&ft, some_string);
	emit_ftrace_thing(&ft);

or some similar thing.
