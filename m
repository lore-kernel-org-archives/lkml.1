Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbZIKOwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbZIKOwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZIKOwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:52:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37983 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZIKOwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:52:03 -0400
Subject: Re: [PATCH 2/3] tracing/profile: add ref count for registering
 profile events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <1252679849.7126.37.camel@laptop>
References: <20090911135452.866274568@goodmis.org>
	 <20090911135626.421489476@goodmis.org>  <1252677861.7126.32.camel@laptop>
	 <1252678183.7126.34.camel@laptop>
	 <1252679606.18996.681.camel@gandalf.stny.rr.com>
	 <1252679849.7126.37.camel@laptop>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 11 Sep 2009 10:52:05 -0400
Message-Id: <1252680725.18996.686.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 16:37 +0200, Peter Zijlstra wrote:

> > I originally tried to do it in the tracepoint logic, but that broke a
> > lot of assumptions about tracepoints that Mathieu pointed out. This is
> > not a normal use of tracepoints. It is expected that if you register a
> > probe in a module, you will unregister it before exiting.
> > 
> > I can't remember all the details, but at the end, it seemed that the fix
> > belonged at the ftrace level.
> 
> Right, Mathieu thinks its sane to be able to attach to
> tracepoints/markers before they exist, so you can put them in module
> init code. I disagree.
> 
> ftrace doesn't mirror this behaviour, that is the source of the problem.
> If it did the ftrace structures wouldn't go away on unload and there
> wouldn't be no crash.
> 
> But if you want to maintain this disparity between the two frameworks
> then yes Li's patch, or yours (they're identical) seems the way to solve
> it.

I'll take Li's patch then. He wrote it first.

> 
> Still think its daft though.
> 

Well, it needs to be fixed, and I don't want to put up with a flamewar
about changing the way tracepoints currently work. I'll take Li's patch
and send out another pull request.

-- Steve


