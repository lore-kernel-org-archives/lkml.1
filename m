Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYFDFAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYFDFAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 01:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYFDFAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 01:00:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbYFDFAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 01:00:39 -0400
Message-ID: <4846210E.8080401@redhat.com>
Date: Wed, 04 Jun 2008 00:58:54 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>
CC: Hideo AOKI <haoki@redhat.com>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Kernel marker has no performance impact on ia64.
References: <48447052.3030300@redhat.com> <1212445965.6269.22.camel@lappy.programming.kicks-ass.net> <20080602232135.GA20173@Krystal>
In-Reply-To: <20080602232135.GA20173@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter and Mathieu,

Thank you for your comments.

Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
>> On Mon, 2008-06-02 at 18:12 -0400, Hideo AOKI wrote:
>>> Hello,
>>>
>>> I evaluated overhead of kernel marker using linux-2.6-sched-fixes
>>> git tree, which includes several markers for LTTng, using an ia64
>>> server.
>>>
>>> While the immediate trace mark feature isn't implemented on ia64,
>>> there is no major performance regression. So, I think that we 
>>> don't have any issues to propose merging marker point patches 
>>> into Linus's tree from the viewpoint of performance impact.
>> Performance is atm the least of the concerns regarding this work.
>>
>> I'm still convinced markers are too ugly to live.
>>
>> I also worry greatly about the fact that its too easy to expose too much
>> to user-space. There are no clear rules and the free form marker format
>> just begs for an inconsistent mess to arise.

Sure, I think we should review each point carefully
and should make clear rules what is acceptable or not and why.

>>
>> IMHO the current free-form trace_mark() should be removed from the tree
>> - its great for ad-hoc debugging but its a disaster waiting to happen
>> for anything else. Anybody doing ad-hoc debugging can patch it in
>> themselves if needed.
>>
>> Regular trace points can be custom made; this has the advantages that it
>> raises the implementation barrier and hopefully that encourages some
>> thought in the process. It also avoid the code from growing into
>> something that looks like someone had a long night of debugging.
>>
> 
> Maybe we could settle for an intermediate solution : I agree with you
> that defining the trace points in headers, like you did for the
> scheduler, makes the code much cleaner and makes things much easier to
> maintain afterward. However, having the trace_mark mechanism underneath
> helps a lot in plugging a generic tracer (actually, if we can settle the
> marker issue, I've got a kernel tracer, LTTng, that I've been waiting
> for quite a while to push to mainline that I would like to post someday).

That's good to me.
BTW, I'd like to know your plan, would those static inline functions be
defined in new headers or marker.h(or other existing headers)?

Regards,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


