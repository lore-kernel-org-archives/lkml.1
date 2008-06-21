Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYFUTmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYFUTmZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYFUTmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:42:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbYFUTmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:42:17 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>
Subject: Re: [RFC][Patch 2/2] markers: example of irq regular kernel markers
References: <20080620174529.GB10943@Krystal> <485C064E.5020705@redhat.com>
	<20080621190132.E835.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<Pine.LNX.4.58.0806211013300.32694@gandalf.stny.rr.com>
	<y0mwskiyh36.fsf@ton.toronto.redhat.com>
	<Pine.LNX.4.58.0806211058510.28481@gandalf.stny.rr.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sat, 21 Jun 2008 15:39:21 -0400
In-Reply-To: <Pine.LNX.4.58.0806211058510.28481@gandalf.stny.rr.com> (Steven Rostedt's message of "Sat, 21 Jun 2008 11:07:35 -0400 (EDT)")
Message-ID: <y0mskv6y3va.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Steven Rostedt <rostedt@goodmis.org> writes:

> [...]
>> That is not so.  They are far from panaceanic, but printf formats are
>> useful for type checked simple scalars, which we can extract and use
>> for purposes other than printf like operations.
>
> It doesn't help much if you mix a pid and prio of a task_struct, and then
> use the prio to find the actual task, or try setting another task priority
> to the pid.

Right, though the same is true for a tracer client flipping around
"next" and "prev" pointer values.

>[...]
>> > Passing in a pointer to the structure being traced should be enough
>> > for all tracers.
>>
>> On the contrary, we have explained why *this is not so*.  Using raw
>> general structure pointers in impractical for some tracers.
>
> The thing that those tracers need is something that can be stored in the
> kernel that can easily extract the needed information.

Well sure, but who is to do that storage & extraction?  Some code the
marker site maintainer needs to write for each marker?


> [...]
>> Maybe a solution could involve some restrictions on the generalities.
>> For example, can we narrow down the number of different scalar +
>> pointer types to a fixed handful?  Can we tolerate type-safety being
>> provided by families of function declarations rather than one generic
>> one?
>
> I'm all for restricting this, I even suggested something similar a while
> ago (http://lists.openwall.net/linux-kernel/2006/10/07/21). No, I'm not
> pushing that solution, that solution was only to bring out more ideas.

Parts of that approach have a lot of merit.  Perhaps we should spend
some time cataloguing the types of all the lttng/logdev/blktrace
"markers" and their nearby pointers.  Maybe it's only a few dozen
types altogether.

- FChE
