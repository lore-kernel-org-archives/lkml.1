Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZHYK5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZHYK5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 06:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbZHYK5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 06:57:21 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48939 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbZHYK5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 06:57:20 -0400
Date: Tue, 25 Aug 2009 06:57:07 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, David Miller <davem@davemloft.net>,
       Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] trace_events: fix napi's tracepoint
Message-ID: <20090825105707.GA24710@hmsreliant.think-freely.org>
References: <4A937EF5.4040505@cn.fujitsu.com> <4A93895F.4010708@cn.fujitsu.com> <20090825075816.GB857@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825075816.GB857@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.7 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 09:58:16AM +0200, Ingo Molnar wrote:
> 
> * Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> 
> > Currently, the napi's tracepoint works will is depend on
> > "DECLARE_TRACE" definiens in include/trace/define_trace.h,
> > like below:
> > 
> > #include <trace/events/skb.h>    // include define_trace.h
> > #include <trace/events/napi.h>
> > 
> > there have error, if we remove "#include <trace/events/skb.h>"
> > or include napi.h in the front of include skb.h, It should
> > depend on the definiens in include/linux/tracepoint.h and we
> > can remove the "DECLARE_TRACE" definiens in
> > include/trace/define_trace.h, because "TRACE_EVENT" not use it
> > 
> > Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> > ---
> >  include/trace/define_trace.h |    4 ----
> >  net/core/net-traces.c        |    4 +++-
> >  2 files changed, 3 insertions(+), 5 deletions(-)
> 
> This will collide with tracing bits in the networking tree. The 
> skb-tracing plugin there should be turned into proper TRACE_EVENT() 
> tracepoints.
> 
> Neil was away for some time but i think soon we should see some 
> movement here.
> 
> 	Ingo
> 

Thank you Ingo, yes, I'm back from the beach now and will look at this shortly.
I concur, we should just convert the napi_poll tracepoint to be defined via the
TRACE_EVENT macro, same as the kfree_skb tracepoint.  Xaio would you like to
take care of that, or shall I?

Best
Neil

