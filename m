Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbZGCAfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbZGCAfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbZGCAfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:35:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65427 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbZGCAfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:35:46 -0400
Message-ID: <4A4D529A.3090706@cn.fujitsu.com>
Date: Fri, 03 Jul 2009 08:36:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kmemtrace: print binary output only if 'bin' option is
 set
References: <4A4C4FEA.6010109@cn.fujitsu.com> <alpine.DEB.2.00.0907020854440.9647@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0907020854440.9647@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2 Jul 2009, Li Zefan wrote:
>> ---
>>  kernel/trace/kmemtrace.c |  119 ++++++++++++++++++++++++++++++++++------------
>>  1 files changed, 89 insertions(+), 30 deletions(-)
>>
>> diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
>> index 1edaa95..9a58f37 100644
>> --- a/kernel/trace/kmemtrace.c
>> +++ b/kernel/trace/kmemtrace.c
>> @@ -239,12 +239,51 @@ struct kmemtrace_user_event_alloc {
>>  };
>>  
>>  static enum print_line_t
>> -kmemtrace_print_alloc_user(struct trace_iterator *iter,
>> -			   struct kmemtrace_alloc_entry *entry)
>> +kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
>> +{
>> +	struct trace_seq *s = &iter->seq;
>> +	struct kmemtrace_alloc_entry *entry;
>> +	int ret;
>> +
>> +	trace_assign_type(entry, iter->ent);
>> +
>> +	ret = trace_seq_printf(s, "type_id %d call_site %lu ptr %lu "
>> +	    "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d\n",
>> +	    entry->type_id, entry->call_site, (unsigned long)entry->ptr,
>> +	    (unsigned long)entry->bytes_req, (unsigned long)entry->bytes_alloc,
>> +	    (unsigned long)entry->gfp_flags, entry->node);
> 
> Could we make the call_site %pF ?  That way we can see the name of the 
> function and not just the address.
> 

Sure, I'll fix it. I just restored the old format.

