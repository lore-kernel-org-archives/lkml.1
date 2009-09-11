Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZIKOhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZIKOhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbZIKOhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:37:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:52189 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbZIKOhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:37:45 -0400
Subject: Re: [PATCH 2/3] tracing/profile: add ref count for registering
 profile events
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <1252679606.18996.681.camel@gandalf.stny.rr.com>
References: <20090911135452.866274568@goodmis.org>
	 <20090911135626.421489476@goodmis.org>  <1252677861.7126.32.camel@laptop>
	 <1252678183.7126.34.camel@laptop>
	 <1252679606.18996.681.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 16:37:29 +0200
Message-Id: <1252679849.7126.37.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 10:33 -0400, Steven Rostedt wrote:
> > Or we can go with Li's original patch, that was less ugly.
> 
> I can go back to Li's original patch, but the talk on that was
> "fragile". If you no longer feel that way, then I'll use his instead.
> 
> For now, I'll pull out this patch altogether, and resubmit the pull
> request without it. I'd like the other changes to not be held up by
> this.

Right, I still think its at the wrong level,. see below.

> > 
> > I still think tracepoints/markers should sort this out, because we now
> > have a sematic difference between the two wrt modules.
> 
> I originally tried to do it in the tracepoint logic, but that broke a
> lot of assumptions about tracepoints that Mathieu pointed out. This is
> not a normal use of tracepoints. It is expected that if you register a
> probe in a module, you will unregister it before exiting.
> 
> I can't remember all the details, but at the end, it seemed that the fix
> belonged at the ftrace level.

Right, Mathieu thinks its sane to be able to attach to
tracepoints/markers before they exist, so you can put them in module
init code. I disagree.

ftrace doesn't mirror this behaviour, that is the source of the problem.
If it did the ftrace structures wouldn't go away on unload and there
wouldn't be no crash.

But if you want to maintain this disparity between the two frameworks
then yes Li's patch, or yours (they're identical) seems the way to solve
it.

Still think its daft though.

