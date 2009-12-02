Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbZLBWhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbZLBWhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 17:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbZLBWhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 17:37:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807AbZLBWhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:37:39 -0500
Message-ID: <4B16EC06.6010706@redhat.com>
Date: Wed, 02 Dec 2009 17:36:54 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, wcohen@redhat.com, fweisbec@gmail.com,
       tglx@linutronix.de, jbaron@redhat.com,
       linux-tip-commits@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: trace/events: DECLARE vs DEFINE semantic
References: <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org>	 <1259761934.12870.12.camel@gandalf.stny.rr.com>	 <20091202140128.GA2611@elte.hu>	 <1259764109.12870.37.camel@gandalf.stny.rr.com>	 <20091202144334.GA30359@elte.hu>	 <1259765735.12870.42.camel@gandalf.stny.rr.com>	 <20091202162715.GB9710@Krystal>	 <1259773888.12870.61.camel@gandalf.stny.rr.com>	 <20091202180633.GF9710@Krystal>	 <1259777987.12870.70.camel@gandalf.stny.rr.com>	 <20091202190135.GA23316@Krystal> <1259781578.12870.78.camel@gandalf.stny.rr.com>
In-Reply-To: <1259781578.12870.78.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
>>> I think the kernel developers are smart enough to figure out that these
>>> macros are not a typical DECLARE/DEFINE that is elsewhere. But I think
>>> using the DECLARE/DEFINE names will give them a better idea of what is
>>> happening than to make up something completely new.
>>
>> In my opinion, re-using a well-known keyword (e.g. DECLARE/DEFINE) but
>> applying a different semantic to what is generally agreed upon is a
>> recipe for confusing developers and users, who will skip the review of
>> some pieces of code assuming they already know what "DECLARE" and
>> "DEFINE" stands for.
>>
>> I argue here that the content of trace/events/ headers are _not_ per se
>> declarations nor definitions, and hence they should not confuse people
>> by using inappropriately well-known keywords. They are actually more
>> evolved macros that can be turned in either a declaration or definition,
>> depending if CREATE_TRACE_POINTS is declared.
> 
> And I argue that the semantics here are not too far off to what those
> are. Yes, these macros behave differently if CREATE_TRACE_POINTS is
> declared or not, but I argue that the average (and below average) kernel
> developer is smart enough to understand this difference.
> 
> 
>>
>> When I created the markers/tracepoints, Andrew Morton explained to me
>> the importance of distinguishing DECLARE vs DEFINE macros. I would
>> really like to hear his point of view on the current question.
> 
> I would like to hear Andrew's comments too, as well as anyone else.
> Randy Dunlap seemed to already approve of these naming conventions, and
> he's a pretty picky person too.
> 
> Randy, do you agree that the use of DECLARE/DEFINE here is fine, or do
> you think that we should come up with a better naming. I do not want to
> add any needless abstraction layer for the sake of naming. These macros
> are confusing enough without that.
> 
> Or do you (or anyone else) have a better name?

How about renaming DEFINE_EVENT to TRACE_EVENT_CLASS?

DECLARE_EVENT_CLASS(y, ...)	declare an event-class y
TRACE_EVENT_CLASS(x, y, ...)	define/declare a trace event x from event-class y
TRACE_EVENT(x, ...)		define/declare a trace event x

Thus TRACE_EVENT_* implies that this macro will be expanded
to both of definition and declaration.
I don't think separating it is good idea from the viewpoint
of maintaining code.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

