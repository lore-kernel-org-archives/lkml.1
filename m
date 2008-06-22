Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbYFVEdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbYFVEdD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 00:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYFVEcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 00:32:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbYFVEcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 00:32:52 -0400
Message-ID: <485DD589.6070503@redhat.com>
Date: Sun, 22 Jun 2008 00:31:05 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][Patch 2/2] markers: example of irq regular kernel markers
References: <20080620174529.GB10943@Krystal> <485C064E.5020705@redhat.com> <20080621190132.E835.KOSAKI.MOTOHIRO@jp.fujitsu.com> <Pine.LNX.4.58.0806211013300.32694@gandalf.stny.rr.com> <y0mwskiyh36.fsf@ton.toronto.redhat.com> <Pine.LNX.4.58.0806211058510.28481@gandalf.stny.rr.com> <1214064834.3223.231.camel@lappy.programming.kicks-ass.net> <20080621180203.GA11804@redhat.com>
In-Reply-To: <20080621180203.GA11804@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Frank Ch. Eigler wrote:
>> I do think we must make a clear distinction between these cases because:
>>
>> 1) tracers provide a kernel<->user interface - and whilst we don't
>> have a stable in-kernel API/ABI we are anal about the kernel/user
>> boundary.  Andrew also greatly worries about this aspect.
> 
> Well, how to set Andrew's mind at ease then, beyond what we've already
> said?  Back a few months ago, both systemtap and lttng guys - the
> primary user-space clients - have said that we are fine with this
> interface changing.  We each have mechanisms to adapt.
> 
>> 2) it highly uglyfies the code, Frank doesn't need to maintain it,
>> so its easy for him to say. But IMHO its much harder to read code
>> that is littered with debug statements that it is to read regular
>> code.
> 
> Then don't put too many in, or hide them with inline functions.
> 
>>  3) it bloats the kernel,.. while it may not be fast path bloat, all
>> that marker stuff does go somewhere.
> 
> That bloat has been quantified and appears negligible in space and time.
> 
>> So, while I see the value of 'stable' mark sites for 'stable'
>> events, I'm dead-set against littering the kernel with markers just
>> because we can, and hoping they might some day be useful for
>> someone.
> 
> We're in violent agreement.  No one suggested "littering just because
> we can".  The initial lttng suite of markers consisted of about one
> hundred *in total*.  If some other subsystem maintainer runs amok and
> adds thousands, please take it up with them, not with us.

Indeed.

Peter, I thought, we were discussing what interface we could accept,
not how many or where tracepoints we could accept. Or, am I misreading?

I know that if someone pushes markers into kernel in his own sweet way,
of course, the kernel code will be bloated endlessly. But I also know
why we review patches and send Ack/Nack before merging them to the tree.
(If you still worry about it, we might be able to make linux-markers
git tree, and review all regular markers on it)

I think and agree that we should make clear policies and criteria of
acceptance of each marker, but it should be discussed on actual
marker uses patches after making agreement for the interface.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

