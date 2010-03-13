Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab0CMDJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 22:09:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60514 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab0CMDJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 22:09:10 -0500
X-Authority-Analysis: v=1.0 c=1 a=8OTfl9jic9UA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=TLS6gJher1GsWqhQ0egA:9 a=OTmqYKwTmmkMlLXJcXDicy7bFSMA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Using tracing_off() in __schedule_bug()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, kernel-team <kernel-team@lists.ubuntu.com>
In-Reply-To: <40ec3ea41003121850y44e08737mf0544c10f1193129@mail.gmail.com>
References: <40ec3ea41003120732w5f44a2ebq728047e742f32bba@mail.gmail.com>
	 <1268436844.4471.783.camel@gandalf.stny.rr.com>
	 <40ec3ea41003121812j7cb349e4g1c455ae096da35cd@mail.gmail.com>
	 <1268447444.4471.789.camel@gandalf.stny.rr.com>
	 <40ec3ea41003121850y44e08737mf0544c10f1193129@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 12 Mar 2010 22:09:08 -0500
Message-ID: <1268449748.4471.795.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 21:50 -0500, Chase Douglas wrote:
> On Fri, Mar 12, 2010 at 9:30 PM, Steven Rostedt <rostedt@goodmis.org> wrote:

> I was thinking that there may be times where you want to skip warnings
> to trace real bugs. For example, there's a WARNING that you hit if
> your resume takes too long. I may want to skip that warning for the
> oops that occurs just after it. As a distro, we also want to be
> flexible in our official kernels so we don't have to build special
> ones when people hit bugs. It's not as though it would be very
> difficult to design with a few priorities, so unless it's really
> unnecessary I don't see why we shouldn't. The default would also fire
> tracing_off in all cases, so most people wouldn't have to modify it
> unless they hit a corner case.

I'm fine with having a two layer. Stop tracing on bugs and/or on
warnings. I would actually have disable on warnings be default off.
There are too many kernel warnings that trigger too easily, having your
resume warning be one of them.

I'm still not sure we need a separate one for critical errors. A oops,
panic and BUG should all be the same. Since any of them can cause the
system to halt.

-- Steve


