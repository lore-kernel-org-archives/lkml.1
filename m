Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZHYH61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZHYH61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZHYH61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:58:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbZHYH60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:58:26 -0400
Date: Tue, 25 Aug 2009 09:58:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Neil Horman <nhorman@tuxdriver.com>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] trace_events: fix napi's tracepoint
Message-ID: <20090825075816.GB857@elte.hu>
References: <4A937EF5.4040505@cn.fujitsu.com> <4A93895F.4010708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A93895F.4010708@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> Currently, the napi's tracepoint works will is depend on
> "DECLARE_TRACE" definiens in include/trace/define_trace.h,
> like below:
> 
> #include <trace/events/skb.h>    // include define_trace.h
> #include <trace/events/napi.h>
> 
> there have error, if we remove "#include <trace/events/skb.h>"
> or include napi.h in the front of include skb.h, It should
> depend on the definiens in include/linux/tracepoint.h and we
> can remove the "DECLARE_TRACE" definiens in
> include/trace/define_trace.h, because "TRACE_EVENT" not use it
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  include/trace/define_trace.h |    4 ----
>  net/core/net-traces.c        |    4 +++-
>  2 files changed, 3 insertions(+), 5 deletions(-)

This will collide with tracing bits in the networking tree. The 
skb-tracing plugin there should be turned into proper TRACE_EVENT() 
tracepoints.

Neil was away for some time but i think soon we should see some 
movement here.

	Ingo
