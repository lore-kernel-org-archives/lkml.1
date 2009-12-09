Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZLIQIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZLIQIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 11:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZLIQID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 11:08:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbZLIQIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:08:02 -0500
Message-ID: <4B1FCB54.6000105@redhat.com>
Date: Wed, 09 Dec 2009 11:07:48 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH v3] [RFC] tracepoint: Add signal coredump tracepoint
References: <20091208104324.B589.A69D9226@jp.fujitsu.com> <20091208204007.31287.62096.stgit@dhcp-100-2-132.bos.redhat.com> <20091209142322.F4C8.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091209142322.F4C8.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



KOSAKI Motohiro wrote:
>> +	TP_fast_assign(
>> +		__entry->sig	= (int)cprm->signr;
>> +		__entry->limit	= cprm->limit;
>> +		__entry->flags	= cprm->mm_flags;
>> +		__entry->retval	= retval;
>> +		__assign_str(name,	core_name);
>> +	),
>> +
>> +	TP_printk("sig=%d limit=%lu dumpable=0x%lx dump_filter=0x%lx "
>> +		  "corename=\"%s\" retval=%d",
>> +		  __entry->sig, __entry->limit,
>> +		  __entry->flags&  MMF_DUMPABLE_MASK,
>> +		  (__entry->flags&  MMF_DUMP_FILTER_MASK)>>
>> +		  MMF_DUMP_FILTER_SHIFT,
>> +		  __get_str(name), __entry->retval)
>> +);
>>   #endif /* _TRACE_SIGNAL_H */
>
> I don't think "limit" is userfriendly name, core_limit or core_size_limit is better?
> plus, we have core_pipe_limit sysctl too. (it's similar but different concept limit).

Ah, I missed it. OK, so I'll rename core_limit and add core_pipe_limit.
Thank you for pointed it out :-)

>
> other parts looks good to me.
>
>
>

Thanks!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

