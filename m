Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbZESGKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbZESGKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZESGKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:10:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51920 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbZESGKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:10:42 -0400
Message-ID: <4A124DAB.109@cn.fujitsu.com>
Date: Tue, 19 May 2009 14:11:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] convert block trace points to TRACE_EVENT()
References: <4A0BB813.9080807@cn.fujitsu.com> <20090518130514.GB4704@nowhere>
In-Reply-To: <20090518130514.GB4704@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, May 14, 2009 at 02:20:03PM +0800, Li Zefan wrote:
>> TRACE_EVENT is a more generic way to define tracepoints. Doing so adds
>> these new capabilities to this tracepoint:
>>
>>   - zero-copy and per-cpu splice() tracing
>>   - binary tracing without printf overhead
>>   - structured logging records exposed under /debug/tracing/events
>>   - trace events embedded in function tracer output and other plugins
>>   - user-defined, per tracepoint filter expressions
>>   ...
>>
>> Cons and problems:
>>
>>   - no dev_t info for the output of plug, unplug_timer and unplug_io events.
>>     no dev_t info for getrq and sleeprq events if bio == NULL.
>>     no dev_t info for rq_abort,...,rq_requeue events if rq->rq_disk == NULL.
>>
>>   - for large packet commands, only 16 bytes of the command will be output.
>>     Because TRACE_EVENT doesn't support dynamic-sized arrays, though it
>>     supports dynamic-sized strings.
>>
>>   - a packet command is converted to a string in TP_assign, not TP_print.
>>     While blktrace do the convertion just before output.
>>
>>   - in blktrace, an event can have 2 different print formats, but a TRACE_EVENT
>>     has a unique format. (see the output of getrq and rq_insert)
> 
> I'm starting to think it would be nice to choose between several outputs
> in a trace event.
> Ie: perhaps we need a kind of per event flag, something simple, just to
> choose between several TP_printk output. Not sure how much it would
> (non) trivial to implement though...
> 

If a trace event wants several TP_printk output, probably it wants different
structs of trace entry, otherwise we'll be wasting memory.

