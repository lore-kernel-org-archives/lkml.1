Return-Path: <linux-kernel-owner+w=401wt.eu-S1751601AbZHSCTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbZHSCTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 22:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZHSCTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 22:19:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40542 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751326AbZHSCTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 22:19:52 -0400
Message-ID: <4A8B615B.7000200@redhat.com>
Date: Tue, 18 Aug 2009 22:20:11 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?UTF-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH -tip v14 07/12] tracing: Introduce TRACE_FIELD_ZERO()
 macro
References: <20090813203403.31965.20973.stgit@localhost.localdomain> <20090813203501.31965.30172.stgit@localhost.localdomain> <20090819010903.GI5231@nowhere>
In-Reply-To: <20090819010903.GI5231@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Aug 13, 2009 at 04:35:01PM -0400, Masami Hiramatsu wrote:
>> Use TRACE_FIELD_ZERO(type, item) instead of TRACE_FIELD_ZERO_CHAR(item).
>> This also includes a fix of TRACE_ZERO_CHAR() macro.
> 
> 
> I can't find what the fix is about (see below)

Ah, OK. This patch actually includes two parts.

One is introducing TRACE_FIELD_ZERO which is more generic than
TRACE_FIELD_ZERO_CHAR, I think.

Another is a typo fix of TRACE_ZERO_CHAR.

>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Avi Kivity <avi@redhat.com>
>> Cc: Andi Kleen <ak@linux.intel.com>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: Frank Ch. Eigler <fche@redhat.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Jason Baron <jbaron@redhat.com>
>> Cc: Jim Keniston <jkenisto@us.ibm.com>
>> Cc: K.Prasad <prasad@linux.vnet.ibm.com>
>> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
>> Cc: Li Zefan <lizf@cn.fujitsu.com>
>> Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
>> Cc: Roland McGrath <roland@redhat.com>
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Tom Zanussi <tzanussi@gmail.com>
>> Cc: Vegard Nossum <vegard.nossum@gmail.com>
>> ---
>>
>>  kernel/trace/trace_event_types.h |    4 ++--
>>  kernel/trace/trace_export.c      |   16 ++++++++--------
>>  2 files changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
>> index 6db005e..e74f090 100644
>> --- a/kernel/trace/trace_event_types.h
>> +++ b/kernel/trace/trace_event_types.h
>> @@ -109,7 +109,7 @@ TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
>>  	TRACE_STRUCT(
>>  		TRACE_FIELD(unsigned long, ip, ip)
>>  		TRACE_FIELD(char *, fmt, fmt)
>> -		TRACE_FIELD_ZERO_CHAR(buf)
>> +		TRACE_FIELD_ZERO(char, buf)
>>  	),
>>  	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
>>  );
>> @@ -117,7 +117,7 @@ TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
>>  TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
>>  	TRACE_STRUCT(
>>  		TRACE_FIELD(unsigned long, ip, ip)
>> -		TRACE_FIELD_ZERO_CHAR(buf)
>> +		TRACE_FIELD_ZERO(char, buf)
>>  	),
>>  	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
>>  );
>> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
>> index 71c8d7f..b0ac92c 100644
>> --- a/kernel/trace/trace_export.c
>> +++ b/kernel/trace/trace_export.c
>> @@ -42,9 +42,9 @@ extern void __bad_type_size(void);
>>  	if (!ret)							\
>>  		return 0;
>>  
>> -#undef TRACE_FIELD_ZERO_CHAR
>> -#define TRACE_FIELD_ZERO_CHAR(item)					\
>> -	ret = trace_seq_printf(s, "\tfield:char " #item ";\t"		\
>> +#undef TRACE_FIELD_ZERO
>> +#define TRACE_FIELD_ZERO(type, item)					\
>> +	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
>>  			       "offset:%u;\tsize:0;\n",			\
>>  			       (unsigned int)offsetof(typeof(field), item)); \
>>  	if (!ret)							\
>> @@ -92,9 +92,6 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
>>  
>>  #include "trace_event_types.h"
>>  
>> -#undef TRACE_ZERO_CHAR
>> -#define TRACE_ZERO_CHAR(arg)
>> -
>>  #undef TRACE_FIELD
>>  #define TRACE_FIELD(type, item, assign)\
>>  	entry->item = assign;
>> @@ -107,6 +104,9 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
>>  #define TRACE_FIELD_SIGN(type, item, assign, is_signed)	\
>>  	TRACE_FIELD(type, item, assign)
>>  
>> +#undef TRACE_FIELD_ZERO
>> +#define TRACE_FIELD_ZERO(type, item)
>> +
> 
> 
> 
> Is it about the above moving?
> If so, could you just tell so that I can add something about
> it in the changelog.

No, I assume that TRACE_ZERO_CHAR is just a typo of TRACE_FIELD_ZERO_CHAR.
(because I couldn't find any other TRACE_ZERO_CHAR)

BTW, this patch may not be needed after applying patch 10/12, since
it removes ftrace event definitions of TRACE_KPROBE/KRETPROBE.

Perhaps, would I better merge and split those additional patches(and
remove this change)?
(It also could make the incremental review hard...)

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

