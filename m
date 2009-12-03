Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZLCNtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZLCNtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZLCNti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:49:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbZLCNth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:49:37 -0500
Message-ID: <4B17C25A.8090703@redhat.com>
Date: Thu, 03 Dec 2009 08:51:22 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, wcohen@redhat.com, fweisbec@gmail.com,
       tglx@linutronix.de, jbaron@redhat.com,
       linux-tip-commits@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: trace/events: DECLARE vs DEFINE semantic
References: <20091202144334.GA30359@elte.hu>	 <1259765735.12870.42.camel@gandalf.stny.rr.com>	 <20091202162715.GB9710@Krystal>	 <1259773888.12870.61.camel@gandalf.stny.rr.com>	 <20091202180633.GF9710@Krystal>	 <1259777987.12870.70.camel@gandalf.stny.rr.com>	 <20091202190135.GA23316@Krystal>	 <1259781578.12870.78.camel@gandalf.stny.rr.com>	 <4B16EC06.6010706@redhat.com>	 <1259794005.12870.102.camel@gandalf.stny.rr.com>	 <20091202231019.GB14770@Krystal>  <4B1737E2.6010502@redhat.com> <1259813228.12870.108.camel@gandalf.stny.rr.com>
In-Reply-To: <1259813228.12870.108.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2009-12-02 at 23:00 -0500, Masami Hiramatsu wrote:
>> Mathieu Desnoyers wrote:
>>> In addition, I wonder if we should rename "CREATE_TRACE_POINTS" to
>>> something more suitable while we are here ? Basically, it will affect
>>> all TRACE_CLASS/TRACE_CLASS_EVENT/TRACE_EVENT from headers included
>>> after it's defined.
>>
>> Agreed, CREATE_TRACE_POINTS is a bit irritating thing :-(
> 
> Well, I think the name could use some help, but I don't think it is the
> name that irritates you.

Yes :-)

>> For example, if we call tracepoints defined in same-header on
>> several different files, we need to check other people have
>> already defined CREATE_TRACE_POINTS on another file, because
>> CREATE_TRACE_POINTS must be used once for each header...
>>
>> So, how about introducing a c file which is only for defining
>> tracepoints for kernel parts ? or defining tracepoints in
>> kernel at the beginning of kernel/tracepoint.c ? (and don't
>> touch tracepoints in modules)
> 
> I think the proper fix is to have each tracepoint header have its own C
> file. I believe Christoph does this with xfs.
> 
> Basically, we should have a:
> 
> kernel/sched_trace.c that includes the include/trace/events/sched.h and
> does the define.
> 
> And the same goes for other trace points.

Hmm, I'd rather like to move it into kernel/events/ or something new
sub directory, since those files will have just two lines (define and
include).

>> e.g.
>>
>> @kernel/tracepoint.c
>>  ...
>>  #define CREATE_TRACE_POINTS
>>  #include <trace/events/sched.h>
>>  #include <trace/events/...>
> 
> We could do this for all that is defined in the include/trace/events.
> 
>>  ...
>>
>> @kernel/sched.c
>>  ...
>>  #include <trace/events/sched.h>	/* Just include events header */
>>  ...
>>
>> @fs/ext4/super.c (no change, since it can be module)
>>  ...
>>  #define CREATE_TRACE_POINTS
>>  #include <trace/events/ext4.h>
> 
> Perhaps we should move out anything in include/trace/events that is also
> a module into its sub system?

Would you mean putting those headers in sub-system's directory?
(e.g. fs/ext4/)
In that case, a problem will happen when user want to hook those
tracepoint from their module, because it is hard to find those
local headers.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

