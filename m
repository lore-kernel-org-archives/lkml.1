Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbZHZFlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbZHZFlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbZHZFlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:41:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55212 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756659AbZHZFlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:41:01 -0400
Message-ID: <4A94CACD.6020309@cn.fujitsu.com>
Date: Wed, 26 Aug 2009 13:40:29 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Neil Horman <nhorman@tuxdriver.com>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] trace_events: fix napi's tracepoint
References: <4A937EF5.4040505@cn.fujitsu.com> <4A93895F.4010708@cn.fujitsu.com> <4A94C612.60200@cn.fujitsu.com>
In-Reply-To: <4A94C612.60200@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Xiao Guangrong wrote:
> 
> Xiao Guangrong wrote:
>> Currently, the napi's tracepoint works will is depend on
>> "DECLARE_TRACE" definiens in include/trace/define_trace.h,
>> like below:
>>
>> #include <trace/events/skb.h>    // include define_trace.h
>> #include <trace/events/napi.h>
>>
>> there have error, if we remove "#include <trace/events/skb.h>"
>> or include napi.h in the front of include skb.h, It should
>> depend on the definiens in include/linux/tracepoint.h and we
>> can remove the "DECLARE_TRACE" definiens in
>> include/trace/define_trace.h, because "TRACE_EVENT" not use it
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> 
> Hi Steven,
> 
> I'm sorry, please pull this patch too, because 
> "[PATCH 7/8] tracing/events: fix the include file dependencies" 
> is based on this patch, else will occur building error.
> 

Sorry again, I say the wrong words, it not has building error, just
not complete fix the bug which I mention it in the changelog of
"[PATCH 7/8] tracing/events: fix the include file dependencies", that
is we can't include more TRACE_EVENT head file in .c file all the same,
like below:

Both define TRACE_EVENT in trace_a.h and trace_b.h, if we include
those in .c file, like this:

#define CREATE_TRACE_POINTS
include <trace/events/trace_a.h>  // re-define DECLARE_TRACE

include <trace/events/trace_b.h>  // use the DECLARE_TRACE definition
				  // that re-define by trace_a.h

Thanks,
Xiao


