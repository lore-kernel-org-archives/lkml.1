Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbZHZOBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbZHZOBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbZHZOBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:01:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62352 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436AbZHZOBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:01:19 -0400
Date: Wed, 26 Aug 2009 10:01:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Neil Horman <nhorman@tuxdriver.com>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] trace_events: fix napi's tracepoint
In-Reply-To: <4A94CACD.6020309@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0908260957470.23885@gandalf.stny.rr.com>
References: <4A937EF5.4040505@cn.fujitsu.com> <4A93895F.4010708@cn.fujitsu.com> <4A94C612.60200@cn.fujitsu.com> <4A94CACD.6020309@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Aug 2009, Xiao Guangrong wrote:

> 
> 
> Xiao Guangrong wrote:
> > 
> > Xiao Guangrong wrote:
> >> Currently, the napi's tracepoint works will is depend on
> >> "DECLARE_TRACE" definiens in include/trace/define_trace.h,
> >> like below:
> >>
> >> #include <trace/events/skb.h>    // include define_trace.h
> >> #include <trace/events/napi.h>
> >>
> >> there have error, if we remove "#include <trace/events/skb.h>"
> >> or include napi.h in the front of include skb.h, It should
> >> depend on the definiens in include/linux/tracepoint.h and we
> >> can remove the "DECLARE_TRACE" definiens in
> >> include/trace/define_trace.h, because "TRACE_EVENT" not use it
> >>
> >> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> > 
> > Hi Steven,
> > 
> > I'm sorry, please pull this patch too, because 
> > "[PATCH 7/8] tracing/events: fix the include file dependencies" 
> > is based on this patch, else will occur building error.
> > 
> 
> Sorry again, I say the wrong words, it not has building error, just
> not complete fix the bug which I mention it in the changelog of
> "[PATCH 7/8] tracing/events: fix the include file dependencies", that
> is we can't include more TRACE_EVENT head file in .c file all the same,
> like below:
> 
> Both define TRACE_EVENT in trace_a.h and trace_b.h, if we include
> those in .c file, like this:
> 
> #define CREATE_TRACE_POINTS
> include <trace/events/trace_a.h>  // re-define DECLARE_TRACE
> 
> include <trace/events/trace_b.h>  // use the DECLARE_TRACE definition
> 				  // that re-define by trace_a.h

Hi Xiao,

I pushed out the "fix the include file dependencies" patch since that was 
a bug fix in its own right. I held off the NAPI patch because it looked 
like it needed rework and only depended on the include dependencies fix. 

Could you update this code to do as Neil and Ingo has mentioned.

Thanks,

-- Steve

