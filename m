Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbYFXEEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbYFXEEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 00:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbYFXEDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 00:03:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbYFXEDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 00:03:53 -0400
Message-ID: <486071AF.3080709@redhat.com>
Date: Tue, 24 Jun 2008 00:01:51 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>
Subject: Re: [RFC] Tracepoint proposal
References: <485BE2C6.1080901@redhat.com> <20080620174529.GB10943@Krystal> <1213992446.3223.195.camel@lappy.programming.kicks-ass.net> <20080622171135.GA19432@Krystal> <20080622175928.GA5022@martell.zuzino.mipt.ru> <20080622182705.GA23301@Krystal> <20080624002010.GA4777@martell.zuzino.mipt.ru>
In-Reply-To: <20080624002010.GA4777@martell.zuzino.mipt.ru>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

Alexey Dobriyan wrote:
> On Sun, Jun 22, 2008 at 02:27:05PM -0400, Mathieu Desnoyers wrote:
>> * Alexey Dobriyan (adobriyan@gmail.com) wrote:
>>> On Sun, Jun 22, 2008 at 01:11:35PM -0400, Mathieu Desnoyers wrote:
>>>> Tracepoint proposal
>>>>
>>>> - Tracepoint infrastructure
>>>>   - In-kernel users
>>>>   - Complete typing, verified by the compiler
>>>>   - Dynamically linked and activated
>>>>
>>>> - Marker infrastructure
>>>>   - Exported API to userland
>>>>   - Basic types only
>>>>
>>>> - Dynamic vs static
>>>>   - In-kernel probes are dynamically linked, dynamically activated, connected to
>>>>     tracepoints. Type verification is done at compile-time. Those in-kernel
>>>>     probes can be a probe extracting the information to put in a marker or a
>>>>     specific in-kernel tracer such as ftrace.
>>>>   - Information sinks (LTTng, SystemTAP) are dynamically connected to the
>>>>     markers inserted in the probes and are dynamically activated.
>>>>
>>>> - Near instrumentation site vs in a separate tracer module
>>>>
>>>> A probe module, only if provided with the kernel tree, could connect to internal
>>>> tracing sites. This argues for keeping the tracepoing probes near the
>>>> instrumentation site code. However, if a tracer is general purpose and exports
>>>> typing information to userspace through some mechanism, it should only export
>>>> the "basic type" information and could be therefore shipped outside of the
>>>> kernel tree.
>>>>
>>>> In-kernel probes should be integrated to the kernel tree. They would be close to
>>>> the instrumented kernel code and would translate between the in-kernel
>>>> instrumentation and the "basic type" exports. Other in-kernel probes could
>>>> provide a different output (statistics available through debugfs for instance).
>>>> ftrace falls into this category.
>>>>
>>>> Generic or specialized information "sinks" (LTTng, systemtap) could be connected
>>>> to the markers put in tracepoint probes to extract the information to userspace.
>>>> They would extract both typing information and the per-tracepoint execution
>>>> information to userspace.
>>>>
>>>> Therefore, the code would look like :
>>>>
>>>> kernel/sched.c:
>>>>
>>>> #include "sched-trace.h"
>>>>
>>>> schedule()
>>>> {
>>>>   ...
>>>>   trace_sched_switch(prev, next);
>>>>   ...
>>>> }
>>> Once this is accepted you're going to add hundreds of such calls to every
>>> core subsystem, right?
>>>
>> The LTTng instrumentation has about 125 of such calls. Tests have
>> revealed that adding such dormant tracepoints to the kernel often
>> increase kernel performances rather than decreasing it (see the ia64
>> benchmarks posted on lkml a few weeks ago).
> 
> We're not adding this for performance increase, you do realize this?
> 
>> The core subsystem maintainers are being involved in the process.
> 
> NAK this from proc if you about this.

Hmm, Mathieu, for this issue, I think that no one agrees
if there is no clear policy for trace points (for example,
subsystem maintainer or patch committer can modify or
erase trace points by their patch, if they need; tracepoint
maintainers should follow the changes, etc.).

>> Actually, marking up the source code has the interesting effect of
>> letting knowledgeable people influence the trace point decisions.
> 
> I'd say that maximum source code overhead any tracing facility should be
> allowed is "__xxx" annotation at very start of function definition.
> Anything beyond should be rejected and there are good reasons for that.

(Out of curiously, would you know any __xxx magic for that?)

One reason why we need markers or other in-the-middle-of-function
trace point is that some events happen inside functions, not it's
interface.

Actually, we might be able to break those functions into several
functions to export it's interface to tracers. However, I think
it is easier to call trace_XXX than that.


Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

